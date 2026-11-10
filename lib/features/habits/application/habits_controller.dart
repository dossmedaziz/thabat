import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/utils/clock.dart';
import '../../../core/utils/dates.dart';
import '../../achievements/domain/achievements.dart';
import '../../auth/data/auth_service.dart';
import '../../settings/application/settings_controller.dart';
import '../data/app_data.dart';
import '../data/remote_api.dart';
import '../data/seed.dart';
import '../domain/habit_stats.dart';
import '../domain/models.dart';

part 'habits_controller.g.dart';

/// Overridden in main() (file store) and tests (memory store).
@Riverpod(keepAlive: true)
DataStore dataStore(Ref ref) => MemoryDataStore();

class DeletedHabit {
  const DeletedHabit(this.habit, this.logs);
  final Habit habit;
  final LogMap logs;
}

enum CelebrationKind { badge, goal }

@immutable
class Celebration {
  const Celebration.badge(this.achievementId)
      : kind = CelebrationKind.badge,
        habitName = null,
        habitId = null;
  const Celebration.goal(this.habitId, this.habitName)
      : kind = CelebrationKind.goal,
        achievementId = AchievementIds.goalReached;
  final CelebrationKind kind;
  final String achievementId;
  final String? habitId;
  final String? habitName;
}

/// Pending celebration overlays (shown one after another by the app shell).
@Riverpod(keepAlive: true)
class Celebrations extends _$Celebrations {
  @override
  List<Celebration> build() => const [];

  void push(Iterable<Celebration> items) => state = [...state, ...items];

  void pop() {
    if (state.isNotEmpty) state = state.sublist(1);
  }
}

UserProfile profileFromAuth(AuthUser u) => UserProfile(
      name: u.firstName,
      fullName: u.fullName.isEmpty ? u.firstName : u.fullName,
      email: u.email,
      joinedAt: u.createdAt.toLocal(),
      photoUrl: u.photoUrl,
    );

/// Applies one change to the local data set. The same function is used for new
/// changes and to replay unsynced changes on top of a fresh server download.
AppData applyOp(AppData d, SyncOp op) {
  final p = op.payload;
  switch (op.kind) {
    case SyncOp.upsertHabit:
      final h = habitFromRow(p);
      final list = [...d.habits];
      final i = list.indexWhere((x) => x.id == h.id);
      if (i >= 0) {
        list[i] = h;
      } else {
        list.add(h);
      }
      return d.copyWith(habits: list, logs: {...d.logs, h.id: d.logs[h.id] ?? const {}});
    case SyncOp.deleteHabit:
      final id = p['id'] as String;
      return d.copyWith(habits: d.habits.where((x) => x.id != id).toList(), logs: Map.of(d.logs)..remove(id));
    case SyncOp.upsertLogs:
      final logs = Map.of(d.logs);
      for (final r in (p['rows'] as List).cast<Map<String, dynamic>>()) {
        final hid = r['habit_id'] as String;
        if (!d.habits.any((h) => h.id == hid)) continue;
        final l = logFromRow(r);
        logs[hid] = {...?logs[hid], l.date: l};
      }
      return d.copyWith(logs: logs);
    case SyncOp.deleteLog:
      final hid = p['habit_id'] as String;
      final logs = Map.of(d.logs);
      logs[hid] = Map.of(logs[hid] ?? const {})..remove(p['date']);
      return d.copyWith(logs: logs);
    case SyncOp.upsertAchievements:
      final ach = Map.of(d.achievements);
      for (final r in (p['rows'] as List).cast<Map<String, dynamic>>()) {
        ach.putIfAbsent(r['achievement_id'] as String, () => DateTime.parse(r['unlocked_at'] as String).toLocal());
      }
      return d.copyWith(achievements: ach);
    default:
      return d;
  }
}

/// Single source of truth for the signed-in user's data.
///
/// Every change is applied locally first (instant UI, works offline), saved to the
/// device cache, queued, and then written to Supabase. Failed writes stay queued
/// and are retried on the next change, on app resume and every 30 seconds.
@Riverpod(keepAlive: true)
class AppDataController extends _$AppDataController {
  Timer? _retry;
  bool _flushing = false;
  bool _profileChecked = false;

  RemoteApi get _api => ref.read(remoteApiProvider);
  AppData get _d => state.value ?? AppData.empty;
  DateTime get _today => ref.read(todayProvider);
  WeekStart get _ws => ref.read(settingsControllerProvider).weekStart;

  @override
  Future<AppData> build() async {
    ref.onDispose(() => _retry?.cancel());
    final uid = await ref.watch(authUserIdProvider.future);
    _profileChecked = false;
    if (uid == null) return AppData.empty;
    final auth = ref.read(authServiceProvider).currentUser;

    var cached = await ref.read(dataStoreProvider).load();
    if (cached.uid != uid) cached = AppData(uid: uid); // another account's cache → ignore it
    final data = cached.copyWith(uid: uid, user: auth == null ? cached.user : profileFromAuth(auth));

    // Keep language / week start / theme in the user's profile row.
    ref.listen(settingsControllerProvider, (prev, next) {
      if (prev == null || !_d.signedIn) return;
      if (prev.locale != next.locale || prev.weekStart != next.weekStart || prev.themeMode != next.themeMode) {
        _enqueue([_profileOp(next)]);
      }
    });

    Future.microtask(refresh);
    return data;
  }

  // ---------- sync ----------

  void _save(AppData d) {
    state = AsyncData(d);
    ref.read(dataStoreProvider).save(d);
  }

  void _enqueue(List<SyncOp> ops, {List<Celebration> celebrate = const []}) {
    var d = _d;
    if (d.uid == null) return;
    for (final op in ops) {
      d = applyOp(d, op);
    }
    _save(d.copyWith(pending: [...d.pending, ...ops]));
    if (celebrate.isNotEmpty) ref.read(celebrationsProvider.notifier).push(celebrate);
    unawaited(_flush());
  }

  Future<void> _flush() async {
    if (_flushing) return;
    _flushing = true;
    try {
      while (true) {
        final d = _d;
        final uid = d.uid;
        if (uid == null || d.pending.isEmpty) break;
        final op = d.pending.first;
        try {
          await _api.apply(uid, op);
        } on PermanentSyncError catch (e) {
          debugPrint('Thabat: server rejected ${op.kind}, dropping it: $e');
        } catch (e) {
          debugPrint('Thabat: offline or server unreachable, will retry: $e');
          _scheduleRetry();
          break;
        }
        final cur = _d;
        if (cur.uid != uid || cur.pending.isEmpty || !identical(cur.pending.first, op)) break;
        _save(cur.copyWith(pending: cur.pending.sublist(1)));
      }
    } finally {
      _flushing = false;
    }
  }

  void _scheduleRetry() {
    _retry?.cancel();
    _retry = Timer(const Duration(seconds: 30), () => unawaited(refresh()));
  }

  /// Pushes queued changes, then downloads the latest server state.
  Future<void> refresh() async {
    final uid = _d.uid;
    if (uid == null) return;
    await _flush();
    try {
      final snap = await _api.fetchAll(uid);
      final cur = _d;
      if (cur.uid != uid) return;
      var next = cur.copyWith(habits: snap.habits, logs: snap.logs, achievements: snap.achievements, synced: true);
      for (final op in cur.pending) {
        next = applyOp(next, op); // keep changes the server hasn't received yet
      }
      _save(next);
      if (!_profileChecked) {
        _profileChecked = true;
        _applyProfile(snap.profile);
      }
    } catch (e) {
      debugPrint('Thabat: refresh failed (offline?): $e');
      _scheduleRetry();
    }
  }

  /// First sync after sign-in: adopt the saved preferences, or create the profile row.
  void _applyProfile(Map<String, dynamic>? row) {
    final s = ref.read(settingsControllerProvider.notifier);
    if (row == null) {
      _enqueue([_profileOp(ref.read(settingsControllerProvider))]);
      return;
    }
    final locale = row['locale'] as String?;
    if (locale != null) s.setLocale(locale);
    s.setWeekStart(WeekStart.fromName(row['week_start'] as String?));
    s.setThemeMode(ThemeMode.values.firstWhere((m) => m.name == row['theme_mode'], orElse: () => ThemeMode.system));
  }

  SyncOp _profileOp(AppSettings s) {
    final u = _d.user;
    return SyncOp(SyncOp.upsertProfile, {
      'id': _d.uid,
      'display_name': u?.fullName,
      'email': u?.email,
      'photo_url': u?.photoUrl,
      'locale': s.locale,
      'week_start': s.weekStart.name,
      'theme_mode': s.themeMode.name,
    });
  }

  // ---------- account ----------

  Future<void> signOut() async {
    await _flush();
    await ref.read(dataStoreProvider).save(AppData.empty);
    await ref.read(authServiceProvider).signOut();
  }

  /// Deletes the account and all its data on the server. Needs a connection.
  Future<void> deleteAccount() async {
    await _api.deleteAccount();
    await ref.read(dataStoreProvider).save(AppData.empty);
    try {
      await ref.read(authServiceProvider).signOut();
    } catch (_) {}
  }

  void addSampleData(AppLocalizations l) {
    final uid = _d.uid;
    if (uid == null) return;
    final s = buildSampleData(l, _today, _ws);
    final ops = <SyncOp>[
      for (final h in s.habits) SyncOp(SyncOp.upsertHabit, habitToRow(h, uid)),
      SyncOp(SyncOp.upsertLogs, {
        'rows': [
          for (final h in s.habits)
            for (final log in (s.logs[h.id] ?? const <String, HabitLog>{}).values) logToRow(h.id, log, uid),
        ],
      }),
    ];
    // Badges earned by the sample history are unlocked silently.
    var preview = _d;
    for (final op in ops) {
      preview = applyOp(preview, op);
    }
    final progress = evaluateAchievements(habits: preview.habits, logs: preview.logs, today: _today, weekStart: _ws);
    final at = addDays(_today, -1).add(const Duration(hours: 20)).toUtc().toIso8601String();
    final newBadges = [
      for (final e in progress.entries)
        if (e.value.unlocked && !preview.achievements.containsKey(e.key))
          {'user_id': uid, 'achievement_id': e.key, 'unlocked_at': at},
    ];
    if (newBadges.isNotEmpty) ops.add(SyncOp(SyncOp.upsertAchievements, {'rows': newBadges}));
    _enqueue(ops);
  }

  // ---------- habits ----------

  void upsertHabit(Habit h) {
    final uid = _d.uid;
    if (uid == null) return;
    final exists = _d.habits.any((x) => x.id == h.id);
    _enqueue([SyncOp(SyncOp.upsertHabit, habitToRow(exists ? h.copyWith(updatedAt: DateTime.now()) : h, uid))]);
  }

  DeletedHabit? deleteHabit(String id) {
    final h = _d.habits.where((x) => x.id == id).firstOrNull;
    if (h == null) return null;
    final removed = DeletedHabit(h, _d.logs[id] ?? const {});
    _enqueue([SyncOp(SyncOp.deleteHabit, {'id': id})]);
    return removed;
  }

  void restoreHabit(DeletedHabit r) {
    final uid = _d.uid;
    if (uid == null || _d.habits.any((x) => x.id == r.habit.id)) return;
    _enqueue([
      SyncOp(SyncOp.upsertHabit, habitToRow(r.habit, uid)),
      if (r.logs.isNotEmpty)
        SyncOp(SyncOp.upsertLogs, {
          'rows': [for (final l in r.logs.values) logToRow(r.habit.id, l, uid)],
        }),
    ]);
  }

  // ---------- logs ----------

  void setLog(String habitId, LogStatus status, {DateTime? day, String? note}) {
    final uid = _d.uid;
    if (uid == null) return;
    final d = dayOnly(day ?? _today);
    final log = HabitLog(date: dateKey(d), status: status, note: note, createdAt: DateTime.now());
    _commitLog(habitId, SyncOp(SyncOp.upsertLogs, {
      'rows': [logToRow(habitId, log, uid)],
    }));
  }

  void removeLog(String habitId, {DateTime? day}) {
    _commitLog(habitId, SyncOp(SyncOp.deleteLog, {'habit_id': habitId, 'date': dateKey(dayOnly(day ?? _today))}));
  }

  /// Applies a log change and works out which celebrations it earns.
  void _commitLog(String habitId, SyncOp op) {
    final uid = _d.uid;
    if (uid == null) return;
    final before = _d;
    final after = applyOp(before, op);
    final celebrations = <Celebration>[];
    final ops = [op];

    final habit = after.habits.where((h) => h.id == habitId).firstOrNull;
    var goalCrossed = false;
    if (habit?.goal != null) {
      final was = computeStats(habit!, before.logs[habitId] ?? const {}, _today, _ws).goalProgress ?? 0;
      final now = computeStats(habit, after.logs[habitId] ?? const {}, _today, _ws).goalProgress ?? 0;
      if (was < 1 && now >= 1) {
        goalCrossed = true;
        celebrations.add(Celebration.goal(habit.id, habit.name));
      }
    }

    final progress = evaluateAchievements(habits: after.habits, logs: after.logs, today: _today, weekStart: _ws);
    final at = DateTime.now().toUtc().toIso8601String();
    final rows = <Map<String, dynamic>>[];
    for (final id in AchievementIds.all) {
      if (progress[id]!.unlocked && !after.achievements.containsKey(id)) {
        rows.add({'user_id': uid, 'achievement_id': id, 'unlocked_at': at});
        if (!(goalCrossed && id == AchievementIds.goalReached)) celebrations.add(Celebration.badge(id));
      }
    }
    if (rows.isNotEmpty) ops.add(SyncOp(SyncOp.upsertAchievements, {'rows': rows}));
    _enqueue(ops, celebrate: celebrations);
  }
}

// ---------- derived, read-only views ----------

@riverpod
List<Habit> habits(Ref ref) {
  final d = ref.watch(appDataControllerProvider).value;
  return (d?.habits ?? const <Habit>[]).where((h) => !h.archived).toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
}

@riverpod
AllLogs allLogs(Ref ref) => ref.watch(appDataControllerProvider).value?.logs ?? const {};

@riverpod
Habit? habitById(Ref ref, String id) => ref.watch(habitsProvider).where((h) => h.id == id).firstOrNull;

@riverpod
HabitStats? habitStats(Ref ref, String id) {
  final h = ref.watch(habitByIdProvider(id));
  if (h == null) return null;
  final logs = ref.watch(allLogsProvider)[id] ?? const {};
  return computeStats(h, logs, ref.watch(todayProvider), ref.watch(settingsControllerProvider).weekStart);
}

@riverpod
Map<String, AchievementProgress> achievementProgress(Ref ref) => evaluateAchievements(
      habits: ref.watch(habitsProvider),
      logs: ref.watch(allLogsProvider),
      today: ref.watch(todayProvider),
      weekStart: ref.watch(settingsControllerProvider).weekStart,
    );

@riverpod
Map<String, DateTime> unlockedAchievements(Ref ref) =>
    ref.watch(appDataControllerProvider).value?.achievements ?? const {};

/// Number of local changes not yet saved to the server.
@riverpod
int pendingSyncCount(Ref ref) => ref.watch(appDataControllerProvider).value?.pending.length ?? 0;
