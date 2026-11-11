import 'dart:async';

import 'package:thabat/features/auth/data/auth_service.dart';
import 'package:thabat/features/habits/data/remote_api.dart';
import 'package:thabat/features/habits/domain/models.dart';

class FakeAuthService implements AuthService {
  FakeAuthService({AuthUser? signedIn, AuthUser? account}) : _user = signedIn, _account = account ?? demo;
  AuthUser? _user;
  final AuthUser _account;
  final _ctrl = StreamController<AuthUser?>.broadcast();

  static final demo = AuthUser(
    id: '00000000-0000-4000-8000-000000000001',
    email: 'ahmed@example.com',
    fullName: 'Ahmed Ben Ali',
    createdAt: DateTime(2026, 9, 15),
  );

  @override
  AuthUser? get currentUser => _user;

  @override
  Stream<AuthUser?> userChanges() async* {
    yield _user;
    yield* _ctrl.stream;
  }

  @override
  Future<void> signInWithGoogle() async {
    _user = _account;
    _ctrl.add(_user);
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _ctrl.add(null);
  }
}

/// In-memory stand-in for Supabase. Set [offline] to simulate no connection.
class FakeRemoteApi implements RemoteApi {
  bool offline = false;
  final habits = <String, Map<String, dynamic>>{};
  final logs = <String, Map<String, dynamic>>{}; // key: habitId|date
  final achievements = <String, Map<String, dynamic>>{};
  Map<String, dynamic>? profile;
  final applied = <String>[];

  void _check() {
    if (offline) throw Exception('SocketException: offline');
  }

  @override
  Future<RemoteSnapshot> fetchAll(String uid) async {
    _check();
    final hs = habits.values.map(habitFromRow).toList();
    final ls = <String, LogMap>{for (final h in hs) h.id: {}};
    for (final r in logs.values) {
      final l = logFromRow(r);
      (ls[r['habit_id'] as String] ??= {})[l.date] = l;
    }
    return RemoteSnapshot(
      habits: hs,
      logs: ls,
      achievements: {for (final r in achievements.values) r['achievement_id'] as String: DateTime.parse(r['unlocked_at'] as String)},
      profile: profile,
    );
  }

  @override
  Future<void> apply(String uid, SyncOp op) async {
    _check();
    applied.add(op.kind);
    final p = op.payload;
    switch (op.kind) {
      case SyncOp.upsertHabit:
        habits[p['id'] as String] = p;
      case SyncOp.deleteHabit:
        habits.remove(p['id']);
        logs.removeWhere((k, _) => k.startsWith('${p['id']}|'));
      case SyncOp.upsertLogs:
        for (final r in (p['rows'] as List).cast<Map<String, dynamic>>()) {
          if (!habits.containsKey(r['habit_id'])) throw PermanentSyncError('rls: habit missing');
          logs['${r['habit_id']}|${r['date']}'] = r;
        }
      case SyncOp.deleteLog:
        logs.remove('${p['habit_id']}|${p['date']}');
      case SyncOp.upsertAchievements:
        for (final r in (p['rows'] as List).cast<Map<String, dynamic>>()) {
          achievements.putIfAbsent(r['achievement_id'] as String, () => r);
        }
      case SyncOp.upsertProfile:
        profile = p;
    }
  }

  @override
  Future<void> deleteAccount() async {
    _check();
    habits.clear();
    logs.clear();
    achievements.clear();
    profile = null;
  }
}
