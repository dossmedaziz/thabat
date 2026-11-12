import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/l10n_x.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_button.dart';
import '../../habits/application/habits_controller.dart';
import 'achievements_screen.dart';
import 'badge_info.dart';

Future<void> showCelebration(BuildContext context, Celebration cel) {
  HapticFeedback.heavyImpact();
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: context.l10n.continueBtn,
    barrierColor: Colors.black.withValues(alpha: .55),
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, _, _) => _CelebrationView(cel: cel),
    transitionBuilder: (_, a, _, child) =>
        FadeTransition(opacity: a, child: child),
  );
}

class _CelebrationView extends StatefulWidget {
  const _CelebrationView({required this.cel});
  final Celebration cel;
  @override
  State<_CelebrationView> createState() => _CelebrationViewState();
}

class _CelebrationViewState extends State<_CelebrationView>
    with TickerProviderStateMixin {
  late final ConfettiController _confetti = ConfettiController(
    duration: const Duration(milliseconds: 1400),
  );
  late final AnimationController _bounce = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final AnimationController _burst = AnimationController(vsync: this);
  Timer? _clearConfetti;
  bool _showConfetti = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confetti.play();
      _bounce.forward();
      // The confetti package only stops once every particle has left the screen,
      // which may never happen inside a dialog; remove it so nothing keeps animating.
      _clearConfetti = Timer(const Duration(seconds: 4), () {
        if (mounted) setState(() => _showConfetti = false);
      });
    });
  }

  @override
  void dispose() {
    _clearConfetti?.cancel();
    _confetti.dispose();
    _bounce.dispose();
    _burst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final cel = widget.cel;
    final info = badgeInfo(l, cel.achievementId);
    final title = cel.kind == CelebrationKind.goal
        ? l.celebrateGoal(cel.habitName ?? '')
        : celebrationTitle(l, cel.achievementId);
    final shareName = cel.kind == CelebrationKind.goal
        ? (cel.habitName ?? info.name)
        : info.name;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsetsDirectional.fromSTEB(24, 28, 24, 20),
              constraints: const BoxConstraints(maxWidth: 380),
              decoration: BoxDecoration(
                color: c.card,
                borderRadius: AppRadii.heroAll,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Lottie.asset(
                            'assets/lottie/badge_burst.json',
                            controller: _burst,
                            onLoaded: (comp) => _burst
                              ..duration = comp.duration
                              ..forward(),
                            delegates: LottieDelegates(
                              values: [
                                ValueDelegate.strokeColor(const [
                                  '**',
                                ], value: c.gold),
                              ],
                            ),
                          ),
                        ),
                        ScaleTransition(
                          scale: CurvedAnimation(
                            parent: _bounce,
                            curve: Curves.elasticOut,
                          ),
                          child: BadgeMedal(
                            id: cel.achievementId,
                            unlocked: true,
                            size: 104,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: context.text.sheetTitle.copyWith(fontSize: 21, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cel.kind == CelebrationKind.goal
                        ? l.celebrateBody
                        : info.description,
                    textAlign: TextAlign.center,
                    style: context.text.bodyMedium.copyWith(color: c.sub, fontWeight: FontWeight.w400, height: 1.7),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: l.share,
                          icon: 'share',
                          variant: AppButtonVariant.secondary,
                          height: 52,
                          onPressed: () => SharePlus.instance.share(ShareParams(text: l.shareText(shareName))),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(label: l.continueBtn, height: 52, onPressed: () => Navigator.of(context).pop()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_showConfetti)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                blastDirection: pi / 2,
                emissionFrequency: .08,
                numberOfParticles: 28,
                gravity: .25,
                shouldLoop: false,
                colors: const [
                  Color(0xFF14A383),
                  Color(0xFFF0715A),
                  Color(0xFFE0A526),
                  Color(0xFF7FD9BF),
                  Color(0xFF3B7BE8),
                  Color(0xFFF9B4A6),
                  Color(0xFF8B5CF6),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
