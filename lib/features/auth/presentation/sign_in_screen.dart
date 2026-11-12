import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_x.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/common.dart';
import '../data/auth_service.dart';
import '../../settings/application/settings_controller.dart';

/// Indigo app tile with the rising-line mark (flat, like Cashflow's logo).
class ThabatLogo extends StatelessWidget {
  const ThabatLogo({super.key, this.size = 104});
  final double size;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: c.primary, borderRadius: BorderRadius.circular(size * .31)),
      alignment: Alignment.center,
      // The logo is a fixed mark, so it is not mirrored in RTL.
      child: AppIcon('logo', size: size * .56, color: c.onPrimary, strokeWidth: 1.6),
    );
  }
}

/// The logo with habit icons floating around it in their pastel tints.
class _LogoArt extends StatelessWidget {
  const _LogoArt();
  @override
  Widget build(BuildContext context) {
    final b = Theme.of(context).brightness;
    Widget bubble(String icon, String hex, double size) {
      final t = HabitPalette.resolve(hex, b);
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: t.bg, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: AppIcon(icon, size: size * .42, color: t.fg, strokeWidth: 1.9),
      );
    }

    // Fixed composition: positions are physical so the art doesn't mirror.
    return SizedBox(
      width: 280,
      height: 220,
      child: Stack(
        children: [
          Positioned(left: 26, top: 20, child: bubble('water', '#93C5FD', 34)),
          Positioned(right: 26, top: 4, child: bubble('read', '#6EE7B7', 40)),
          Positioned(left: 4, bottom: 18, child: bubble('smoke', '#FCA5A5', 44)),
          Positioned(right: 18, bottom: 34, child: bubble('heart', '#F9A8D4', 32)),
          const Center(child: ThabatLogo()),
        ],
      ),
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
        _ => l.signInFailed, // email-only errors can't happen on the Google path
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
    final t = context.text;
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
                  // Compact language pill (Cashflow login).
                  SizedBox(
                    width: 200,
                    child: Segmented<String>(
                      value: lang,
                      height: 36,
                      semanticLabel: l.sectionLanguage,
                      items: const [('ar', 'ع', null), ('fr', 'FR', null), ('en', 'EN', null)],
                      onChanged: ref.read(settingsControllerProvider.notifier).setLocale,
                    ),
                  ),
                  SizedBox(height: box.maxHeight * .08),
                  const _LogoArt(),
                  const SizedBox(height: 20),
                  Text(l.appName, style: t.title.copyWith(fontSize: 44, height: 1.2)),
                  Text(l.appNameLatin, style: t.label.copyWith(letterSpacing: lang == 'ar' ? 3 : 0)),
                  const SizedBox(height: 12),
                  Text(l.tagline, textAlign: TextAlign.center, style: t.body.copyWith(fontSize: 18, color: c.sub, fontWeight: FontWeight.w500)),
                  SizedBox(height: box.maxHeight * .08),
                  AppButton.google(label: l.continueWithGoogle, onPressed: _signIn, loading: _busy),
                  const SizedBox(height: 14),
                  AppButton(
                    label: l.continueWithEmail,
                    icon: 'mail',
                    variant: AppButtonVariant.secondary,
                    height: 54,
                    onPressed: _busy ? null : () => context.push(Routes.signInEmail),
                  ),
                  const SizedBox(height: 16),
                  Text(l.signInNewHint, textAlign: TextAlign.center, style: t.subtitle),
                  const SizedBox(height: 10),
                  Text(l.signInPrivacy, textAlign: TextAlign.center, style: t.caption.copyWith(height: 1.6)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
