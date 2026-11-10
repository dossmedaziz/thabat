import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

import '../../../core/config/env.dart';

part 'auth_service.g.dart';

/// The signed-in user, independent of the auth SDK.
@immutable
class AuthUser {
  const AuthUser({required this.id, required this.email, required this.fullName, this.photoUrl, required this.createdAt});
  final String id;
  final String email;
  final String fullName;
  final String? photoUrl;
  final DateTime createdAt;

  /// First name for greetings.
  String get firstName => fullName.trim().isEmpty ? email.split('@').first : fullName.trim().split(RegExp(r'\s+')).first;

  @override
  bool operator ==(Object other) => other is AuthUser && other.id == id;
  @override
  int get hashCode => id.hashCode;
}

enum SignInError { notConfigured, cancelled, network, failed }

class SignInException implements Exception {
  const SignInException(this.kind, [this.detail]);
  final SignInError kind;
  final Object? detail;
  @override
  String toString() => 'SignInException($kind, $detail)';
}

abstract class AuthService {
  AuthUser? get currentUser;
  Stream<AuthUser?> userChanges();
  Future<void> signInWithGoogle();
  Future<void> signOut();
}

/// Google sign-in (native account picker) exchanged for a Supabase session.
class SupabaseAuthService implements AuthService {
  SupabaseAuthService(this._client);
  final SupabaseClient _client;
  Future<void>? _googleInit;

  static AuthUser? _map(User? u) {
    if (u == null) return null;
    final m = u.userMetadata ?? const {};
    return AuthUser(
      id: u.id,
      email: u.email ?? (m['email'] as String? ?? ''),
      fullName: (m['full_name'] ?? m['name'] ?? '') as String,
      photoUrl: (m['avatar_url'] ?? m['picture']) as String?,
      createdAt: DateTime.tryParse(u.createdAt) ?? DateTime.now(),
    );
  }

  @override
  AuthUser? get currentUser => _map(_client.auth.currentUser);

  @override
  Stream<AuthUser?> userChanges() async* {
    yield currentUser;
    yield* _client.auth.onAuthStateChange.map((s) => _map(s.session?.user));
  }

  Future<void> _ensureGoogle() => _googleInit ??= GoogleSignIn.instance.initialize(
        serverClientId: Env.googleWebClientId,
        clientId: !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS && Env.googleIosClientId.isNotEmpty
            ? Env.googleIosClientId
            : null,
      );

  @override
  Future<void> signInWithGoogle() async {
    if (!Env.googleConfigured) throw const SignInException(SignInError.notConfigured);
    try {
      await _ensureGoogle();
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) throw const SignInException(SignInError.failed, 'no id token');
      await _client.auth.signInWithIdToken(provider: OAuthProvider.google, idToken: idToken);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) throw const SignInException(SignInError.cancelled);
      throw SignInException(SignInError.failed, e);
    } on AuthRetryableFetchException catch (e) {
      throw SignInException(SignInError.network, e);
    } on AuthException catch (e) {
      throw SignInException(SignInError.failed, e);
    }
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
    try {
      await _ensureGoogle();
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }
}

@Riverpod(keepAlive: true)
AuthService authService(Ref ref) => SupabaseAuthService(Supabase.instance.client);

@Riverpod(keepAlive: true)
Stream<AuthUser?> authUser(Ref ref) => ref.watch(authServiceProvider).userChanges().distinct();

/// Id of the signed-in user (only changes on sign-in / sign-out, not on token refresh).
@Riverpod(keepAlive: true)
Future<String?> authUserId(Ref ref) async => (await ref.watch(authUserProvider.future))?.id;
