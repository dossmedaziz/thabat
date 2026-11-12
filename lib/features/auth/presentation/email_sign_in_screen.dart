import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/l10n/l10n_x.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/common.dart';
import '../data/auth_service.dart';

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]{2,}$');

/// Passwordless sign-in: email → one-time code. The same flow signs in an
/// existing account or creates a new one.
class EmailSignInScreen extends ConsumerStatefulWidget {
  const EmailSignInScreen({super.key});
  @override
  ConsumerState<EmailSignInScreen> createState() => _EmailSignInScreenState();
}

class _EmailSignInScreenState extends ConsumerState<EmailSignInScreen> {
  static const _cooldown = 60;

  /// One-time codes are exactly 6 digits.
  static const _codeLength = 6;

  final _emailForm = GlobalKey<FormState>();
  final _codeForm = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _code = TextEditingController();

  bool _codeStep = false;
  bool _busy = false;
  String? _error;
  int _resendIn = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _email.dispose();
    _code.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _resendIn = _cooldown);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() => _resendIn--);
      if (_resendIn <= 0) t.cancel();
    });
  }

  String _message(AppLocalizations l, SignInException e) => switch (e.kind) {
        SignInError.invalidCode => l.codeInvalid,
        SignInError.rateLimited => l.codeRateLimited,
        SignInError.emailNotAuthorized => l.emailNotAuthorized,
        SignInError.invalidEmail => l.emailInvalid,
        SignInError.network => l.signInNetwork,
        _ => l.signInFailed,
      };

  Future<void> _sendCode({bool resend = false}) async {
    final l = context.l10n;
    if (!resend && !(_emailForm.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authServiceProvider).sendEmailCode(_email.text);
      if (!mounted) return;
      setState(() => _codeStep = true);
      _startCooldown();
      if (resend) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.codeResent)));
    } on SignInException catch (e) {
      debugPrint('Thabat: send code failed: $e');
      if (mounted) setState(() => _error = _message(l, e));
    } catch (e) {
      debugPrint('Thabat: send code failed: $e');
      if (mounted) setState(() => _error = l.signInFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify() async {
    final l = context.l10n;
    if (!(_codeForm.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authServiceProvider).verifyEmailCode(_email.text, _code.text);
      // Signed in: the router redirect takes the user to Today.
    } on SignInException catch (e) {
      debugPrint('Thabat: verify code failed: $e');
      if (mounted) setState(() => _error = _message(l, e));
    } catch (e) {
      debugPrint('Thabat: verify code failed: $e');
      if (mounted) setState(() => _error = l.signInFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _changeEmail() {
    _timer?.cancel();
    setState(() {
      _codeStep = false;
      _code.clear();
      _error = null;
      _resendIn = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 32),
          children: [
            Row(children: [
              RoundIconButton(
                icon: 'back',
                tooltip: l.back,
                onTap: () {
                  if (_codeStep) return _changeEmail();
                  context.canPop() ? context.pop() : context.go(Routes.signIn);
                },
              ),
            ]),
            const SizedBox(height: 24),
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: c.lilacBg, shape: BoxShape.circle),
              child: AppIcon(_codeStep ? 'lock' : 'mail', size: 28, color: c.lilac, strokeWidth: 2),
            ),
            const SizedBox(height: 18),
            Text(_codeStep ? l.codeTitle : l.emailTitle, style: context.text.heading),
            const SizedBox(height: 6),
            Text(
              _codeStep ? l.codeSentTo(_email.text.trim()) : l.emailSubtitle,
              style: context.text.bodyMedium.copyWith(color: c.sub, fontWeight: FontWeight.w400, height: 1.7),
            ),
            const SizedBox(height: 24),
            if (!_codeStep) _emailStep(context) else _codeStepView(context),
            if (_error != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: c.badSoft, borderRadius: BorderRadius.circular(14)),
                child: Text(_error!, style: TextStyle(color: c.badText, fontWeight: FontWeight.w600)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _primaryButton(String label, VoidCallback onPressed) {
    final c = context.colors;
    return FilledButton(
      onPressed: _busy ? null : onPressed,
      child: _busy
          ? SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: c.onGood))
          : Text(label),
    );
  }

  Widget _emailStep(BuildContext context) {
    final l = context.l10n;
    return Form(
      key: _emailForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: TextFormField(
              controller: _email,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              autocorrect: false,
              textInputAction: TextInputAction.send,
              onFieldSubmitted: (_) => _sendCode(),
              decoration: InputDecoration(labelText: l.emailLabel, hintText: 'name@example.com'),
              validator: (v) => _emailPattern.hasMatch(v?.trim() ?? '') ? null : l.emailInvalid,
            ),
          ),
          const SizedBox(height: 16),
          _primaryButton(l.sendCode, _sendCode),
        ],
      ),
    );
  }

  Widget _codeStepView(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    return Form(
      key: _codeForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: TextFormField(
              controller: _code,
              autofocus: true,
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.oneTimeCode],
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(_codeLength)],
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _verify(),
              // Sign in as soon as the 6th digit is typed (or pasted).
              onChanged: (v) {
                if (v.length == _codeLength && !_busy) _verify();
              },
              style: const TextStyle(fontFamily: kLatinFont, fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: 8),
              decoration: InputDecoration(labelText: l.codeLabel, hintText: '••••••', counterText: ''),
              // Supabase → Authentication → Email → "Email OTP Length" must be 6.
              validator: (v) => (v?.trim().length ?? 0) == _codeLength ? null : l.codeRequired,
            ),
          ),
          const SizedBox(height: 16),
          _primaryButton(l.verifyCode, _verify),
          const SizedBox(height: 8),
          // Wrap (not Row) so long labels — e.g. French — move to a second line instead of overflowing.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(foregroundColor: c.sub),
                onPressed: _busy ? null : _changeEmail,
                child: Text(l.changeEmail),
              ),
              TextButton(
                onPressed: _busy || _resendIn > 0 ? null : () => _sendCode(resend: true),
                child: Text(_resendIn > 0 ? l.resendIn('$_resendIn') : l.resendCode),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
