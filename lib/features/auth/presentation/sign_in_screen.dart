import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n_x.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/common.dart';
import '../data/auth_service.dart';
import '../../settings/application/settings_controller.dart';

class ThabatLogo extends StatelessWidget {
  const ThabatLogo({super.key, this.size = 76});
  final double size;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.goodBtn,
        borderRadius: BorderRadius.circular(size * .3),
        boxShadow: const [BoxShadow(color: Color(0x400C8569), blurRadius: 24, offset: Offset(0, 10))],
      ),
      alignment: Alignment.center,
      // The logo is a fixed mark, so it is not mirrored in RTL.
      child: AppIcon('logo', size: size * .62, color: c.onGood),
    );
  }
}

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});
  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  bool _busy = false;

  Future<void> _signIn() async {
    if (_busy) return;
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
      // The router moves on to Today as soon as the session arrives.
    } on SignInException catch (e) {
      debugPrint('Thabat: sign-in failed: $e');
      final msg = switch (e.kind) {
        SignInError.cancelled => null,
        SignInError.notConfigured => l.signInNotConfigured,
        SignInError.network => l.signInNetwork,
        SignInError.failed => l.signInFailed,
      };
      if (msg != null) messenger.showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      debugPrint('Thabat: sign-in failed: $e');
      messenger.showSnackBar(SnackBar(content: Text(l.signInFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final lang = ref.watch(settingsControllerProvider).locale;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, box) => SingleChildScrollView(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: box.maxHeight - 32),
              child: Column(
                children: [
                  Segmented<String>(
                    value: lang,
                    height: 40,
                    semanticLabel: l.sectionLanguage,
                    items: [
                      ('ar', l.langArabic, null),
                      ('en', l.langEnglish, null),
                      ('fr', l.langFrench, null),
                    ],
                    onChanged: ref.read(settingsControllerProvider.notifier).setLocale,
                  ),
                  SizedBox(height: box.maxHeight * .14),
                  const ThabatLogo(),
                  const SizedBox(height: 22),
                  Text(l.appName,
                      style: TextStyle(fontFamily: kArabicFont, fontSize: 44, fontWeight: FontWeight.w700, height: 1.25, color: c.text)),
                  Text(l.appNameLatin,
                      style: TextStyle(
                          fontFamily: lang == 'ar' ? kLatinFont : kArabicFont,
                          fontSize: 16,
                          letterSpacing: lang == 'ar' ? 3 : 0,
                          fontWeight: FontWeight.w600,
                          color: c.sub)),
                  const SizedBox(height: 14),
                  Text(l.tagline, textAlign: TextAlign.center, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500, color: c.text)),
                  SizedBox(height: box.maxHeight * .14),
                  _GoogleButton(onTap: _signIn, busy: _busy),
                  const SizedBox(height: 14),
                  Text(l.signInNewHint, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: c.sub)),
                  const SizedBox(height: 22),
                  Text(l.signInPrivacy, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, height: 1.6, color: c.sub)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.onTap, required this.busy});
  final VoidCallback onTap;
  final bool busy;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      child: Material(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: busy ? null : onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.line, width: 1.5),
              boxShadow: c.shadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (busy)
                  SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: c.good))
                else
                  const GoogleLogo(),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(context.l10n.continueWithGoogle,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.text)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
