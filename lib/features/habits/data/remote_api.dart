import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models.dart';

part 'remote_api.g.dart';

/// A change waiting to be written to the server (kept on the device while offline).
@immutable
class SyncOp {
  const SyncOp(this.kind, this.payload);
  final String kind;
  final Map<String, dynamic> payload;

  static const upsertHabit = 'upsert_habit';
  static const deleteHabit = 'delete_habit';
  static const upsertLogs = 'upsert_logs';
  static const deleteLog = 'delete_log';
  static const upsertAchievements = 'upsert_achievements';
  static const upsertProfile = 'upsert_profile';

  Map<String, dynamic> toJson() => {'kind': kind, 'payload': payload};
  factory SyncOp.fromJson(Map<String, dynamic> j) =>
      SyncOp(j['kind'] as String, Map<String, dynamic>.from(j['payload'] as Map));
}

/// Everything the server holds for one user.
class RemoteSnapshot {
  const RemoteSnapshot({required this.habits, required this.logs, required this.achievements, this.profile});
  final List<Habit> habits;
  final AllLogs logs;
  final Map<String, DateTime> achievements;
  final Map<String, dynamic>? profile;
}

/// Thrown when the server rejected an operation for good (bad data / policy),
/// as opposed to a network error that is worth retrying.
class PermanentSyncError implements Exception {
  PermanentSyncError(this.cause);
  final Object cause;
  @override
  String toString() => 'PermanentSyncError($cause)';
}

abstract class RemoteApi {
  Future<RemoteSnapshot> fetchAll(String uid);
  Future<void> apply(String uid, SyncOp op);
  Future<void> deleteAccount();
}

// ---------- row mapping (camelCase model ↔ snake_case columns) ----------

Map<String, dynamic> habitToRow(Habit h, String uid) => {
      'id': h.id,
      'user_id': uid,
      'type': h.type.name,
      'name': h.name,
      'emoji': h.emoji,
      'color_hex': h.colorHex,
      'note': h.note,
      'frequency': h.frequency.name,
      'target_per_period': h.targetPerPeriod,
      'weekdays': h.weekdays,
      'goal': h.goal?.toJson(),
      'reminder': h.reminder?.toJson(),
      'archived': h.archived,
      'created_at': h.createdAt.toUtc().toIso8601String(),
      'updated_at': h.updatedAt.toUtc().toIso8601String(),
    };

Habit habitFromRow(Map<String, dynamic> r) => Habit.fromJson({
      'id': r['id'],
      'type': r['type'],
      'name': r['name'],
      'emoji': r['emoji'],
      'colorHex': r['color_hex'],
      'note': r['note'],
      'frequency': r['frequency'],
      'targetPerPeriod': r['target_per_period'],
      'weekdays': r['weekdays'] ?? const <int>[],
      'goal': r['goal'],
      'reminder': r['reminder'],
      'archived': r['archived'] ?? false,
      'createdAt': DateTime.parse(r['created_at'] as String).toLocal().toIso8601String(),
      'updatedAt': DateTime.parse(r['updated_at'] as String).toLocal().toIso8601String(),
    });

Map<String, dynamic> logToRow(String habitId, HabitLog l, String uid) => {
      'habit_id': habitId,
      'user_id': uid,
      'date': l.date,
      'status': l.status.name,
      'count': l.count,
      'note': l.note,
      'created_at': l.createdAt.toUtc().toIso8601String(),
    };

HabitLog logFromRow(Map<String, dynamic> r) => HabitLog.fromJson({
      'date': r['date'],
      'status': r['status'],
      'count': r['count'] ?? 1,
      'note': r['note'],
      'createdAt': DateTime.parse(r['created_at'] as String).toLocal().toIso8601String(),
    });

class SupabaseRemoteApi implements RemoteApi {
  SupabaseRemoteApi(this._db);
  final SupabaseClient _db;
  static const _page = 1000; // PostgREST returns at most 1000 rows per request

  Future<List<Map<String, dynamic>>> _all(String table, String uid, {String order = 'created_at'}) async {
    final out = <Map<String, dynamic>>[];
    for (var from = 0;; from += _page) {
      final rows = await _db.from(table).select().eq('user_id', uid).order(order).range(from, from + _page - 1);
      out.addAll(rows);
      if (rows.length < _page) return out;
    }
  }

  @override
  Future<RemoteSnapshot> fetchAll(String uid) async {
    final (habitRows, logRows, achRows, profile) = await (
      _all('habits', uid),
      _all('habit_logs', uid, order: 'date'),
      _all('achievements', uid, order: 'unlocked_at'),
      _db.from('profiles').select().eq('id', uid).maybeSingle().then((r) => r),
    ).wait;
    final habits = habitRows.map(habitFromRow).toList();
    final logs = <String, LogMap>{for (final h in habits) h.id: {}};
    for (final r in logRows) {
      final l = logFromRow(r);
      (logs[r['habit_id'] as String] ??= {})[l.date] = l;
    }
    final ach = {
      for (final r in achRows)
        r['achievement_id'] as String: DateTime.parse(r['unlocked_at'] as String).toLocal(),
    };
    return RemoteSnapshot(habits: habits, logs: logs, achievements: ach, profile: profile);
  }

  @override
  Future<void> apply(String uid, SyncOp op) async {
    final p = op.payload;
    try {
      switch (op.kind) {
        case SyncOp.upsertHabit:
          await _db.from('habits').upsert(p);
        case SyncOp.deleteHabit:
          await _db.from('habits').delete().eq('id', p['id'] as String);
        case SyncOp.upsertLogs:
          final rows = (p['rows'] as List).cast<Map<String, dynamic>>();
          for (var i = 0; i < rows.length; i += 500) {
            await _db.from('habit_logs').upsert(rows.sublist(i, (i + 500).clamp(0, rows.length)));
          }
        case SyncOp.deleteLog:
          await _db.from('habit_logs').delete().eq('habit_id', p['habit_id'] as String).eq('date', p['date'] as String);
        case SyncOp.upsertAchievements:
          await _db.from('achievements').upsert((p['rows'] as List).cast<Map<String, dynamic>>(), ignoreDuplicates: true);
        case SyncOp.upsertProfile:
          await _db.from('profiles').upsert(p);
      }
    } on PostgrestException catch (e) {
      // The server answered and refused (constraint, RLS, bad data): retrying won't help.
      // Network failures never reach here (they surface as ClientException/SocketException).
      // PGRST3xx = expired/invalid JWT → keep the op and retry after the session refreshes.
      if (e.code?.startsWith('PGRST3') ?? false) rethrow;
      throw PermanentSyncError(e);
    }
  }

  @override
  Future<void> deleteAccount() => _db.rpc('delete_my_account');
}

@Riverpod(keepAlive: true)
RemoteApi remoteApi(Ref ref) => SupabaseRemoteApi(Supabase.instance.client);
