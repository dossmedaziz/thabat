import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/models.dart';
import 'remote_api.dart';

/// The signed-in user as shown in the app (from the Google account via Supabase Auth).
class UserProfile {
  const UserProfile({required this.name, required this.fullName, required this.email, required this.joinedAt, this.photoUrl});
  final String name;
  final String fullName;
  final String email;
  final DateTime joinedAt;
  final String? photoUrl;

  Map<String, dynamic> toJson() => {
        'name': name,
        'fullName': fullName,
        'email': email,
        'joinedAt': joinedAt.toIso8601String(),
        'photoUrl': photoUrl,
      };

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
        name: j['name'] as String? ?? '',
        fullName: j['fullName'] as String? ?? j['name'] as String? ?? '',
        email: j['email'] as String? ?? '',
        joinedAt: DateTime.tryParse(j['joinedAt'] as String? ?? '') ?? DateTime.now(),
        photoUrl: j['photoUrl'] as String?,
      );
}

/// Local copy of one user's data (mirrors the Supabase tables) plus the queue of
/// changes not yet written to the server. Cached on the device for offline use.
@immutable
class AppData {
  const AppData({
    this.uid,
    this.user,
    this.habits = const [],
    this.logs = const {},
    this.achievements = const {},
    this.pending = const [],
    this.synced = false,
  });

  /// Supabase user id this data belongs to (null = signed out).
  final String? uid;
  final UserProfile? user;
  final List<Habit> habits;
  final AllLogs logs;
  final Map<String, DateTime> achievements;

  /// Changes waiting to be sent to Supabase, oldest first.
  final List<SyncOp> pending;

  /// At least one full download from the server has completed.
  final bool synced;

  static const empty = AppData();

  bool get signedIn => uid != null && user != null;

  AppData copyWith({
    String? uid,
    UserProfile? user,
    List<Habit>? habits,
    AllLogs? logs,
    Map<String, DateTime>? achievements,
    List<SyncOp>? pending,
    bool? synced,
  }) =>
      AppData(
        uid: uid ?? this.uid,
        user: user ?? this.user,
        habits: habits ?? this.habits,
        logs: logs ?? this.logs,
        achievements: achievements ?? this.achievements,
        pending: pending ?? this.pending,
        synced: synced ?? this.synced,
      );

  Map<String, dynamic> toJson() => {
        'version': 2,
        'uid': uid,
        'user': user?.toJson(),
        'synced': synced,
        'habits': [
          for (final h in habits)
            {
              ...h.toJson(),
              'logs': {for (final l in (logs[h.id] ?? const <String, HabitLog>{}).values) l.date: l.toJson()},
            },
        ],
        'achievements': {for (final e in achievements.entries) e.key: {'unlockedAt': e.value.toIso8601String()}},
        'pending': [for (final op in pending) op.toJson()],
      };

  factory AppData.fromJson(Map<String, dynamic> j) {
    final habits = <Habit>[];
    final logs = <String, LogMap>{};
    for (final raw in (j['habits'] as List? ?? const [])) {
      final m = Map<String, dynamic>.from(raw as Map);
      final rawLogs = Map<String, dynamic>.from(m.remove('logs') as Map? ?? const {});
      final h = Habit.fromJson(m);
      habits.add(h);
      logs[h.id] = {
        for (final e in rawLogs.entries) e.key: HabitLog.fromJson(Map<String, dynamic>.from(e.value as Map)),
      };
    }
    final ach = <String, DateTime>{};
    for (final e in Map<String, dynamic>.from(j['achievements'] as Map? ?? const {}).entries) {
      final at = DateTime.tryParse((e.value as Map)['unlockedAt'] as String? ?? '');
      if (at != null) ach[e.key] = at;
    }
    return AppData(
      uid: j['uid'] as String?,
      user: j['user'] == null ? null : UserProfile.fromJson(Map<String, dynamic>.from(j['user'] as Map)),
      habits: habits,
      logs: logs,
      achievements: ach,
      pending: [for (final op in (j['pending'] as List? ?? const [])) SyncOp.fromJson(Map<String, dynamic>.from(op as Map))],
      synced: j['synced'] as bool? ?? false,
    );
  }
}

/// Persists [AppData] somewhere on the device.
abstract class DataStore {
  Future<AppData> load();
  Future<void> save(AppData data);
}

class MemoryDataStore implements DataStore {
  MemoryDataStore([this._data = AppData.empty]);
  AppData _data;
  @override
  Future<AppData> load() async => _data;
  @override
  Future<void> save(AppData data) async => _data = data;
}

/// JSON file in the app documents directory, written atomically.
class FileDataStore implements DataStore {
  File? _file;
  Future<void> _pending = Future.value();

  Future<File> _getFile() async {
    if (_file != null) return _file!;
    final dir = await getApplicationDocumentsDirectory();
    return _file = File('${dir.path}/thabat_cache.json');
  }

  @override
  Future<AppData> load() async {
    try {
      final f = await _getFile();
      if (!await f.exists()) return AppData.empty;
      final txt = await f.readAsString();
      if (txt.trim().isEmpty) return AppData.empty;
      return AppData.fromJson(jsonDecode(txt) as Map<String, dynamic>);
    } catch (e, st) {
      debugPrint('Thabat: could not read data file: $e\n$st');
      return AppData.empty;
    }
  }

  @override
  Future<void> save(AppData data) {
    // Serialize writes so an older snapshot never overwrites a newer one.
    return _pending = _pending.then((_) async {
      final f = await _getFile();
      final tmp = File('${f.path}.tmp');
      await tmp.writeAsString(jsonEncode(data.toJson()), flush: true);
      await tmp.rename(f.path);
    }).catchError((Object e) => debugPrint('Thabat: could not save data: $e'));
  }
}
