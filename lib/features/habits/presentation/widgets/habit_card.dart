import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_icon.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/chips.dart';
import '../../../../core/widgets/pressable.dart';
import '../../application/habits_controller.dart';
import '../../domain/habit_stats.dart';
import '../../domain/models.dart';
import '../habit_actions.dart';
import 'swipe_actions.dart';

String streakText(AppLocalizations l, Habit h, HabitStats s) =>
    h.isGood ? l.periodCount(s.currentStreak, h.frequency) : l.daysClean(l.daysCount(s.daysClean));

String? metaText(AppLocalizations l, Habit h, HabitStats s) {
  if (h.isBad) return null;
  switch (h.frequency) {
    case Frequency.daily:
      return s.doneToday ? l.done : null;
    case Frequency.weekly:
      return l.weekProgress('${s.doneThisPeriod.clamp(0, s.target)}', '${s.target}');
    case Frequency.monthly:
      return s.target == 1
          ? (s.periodComplete ? l.done : l.monthProgress('0', '1'))
          : l.monthProgress('${s.doneThisPeriod.clamp(0, s.target)}', '${s.target}');
  }
}

class HabitCard extends ConsumerWidget {
  const HabitCard({super.key, required this.habit});
  final Habit habit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(habitStatsProvider(habit.id));
    if (s == null) return const SizedBox.shrink();
    final c = context.colors;
    final l = context.l10n;
    final actions = HabitActions(context, ref);
    final h = habit;
    final meta = metaText(l, h, s);

    final tone = HabitPalette.resolve(h.colorHex, Theme.of(context).brightness);
    final t = context.text;
    // Row inside the grouped card (Cashflow's list row): icon · name + tag/streak · action.
    final card = ColoredBox(
      color: c.card,
      child: Pressable(
        scale: .98,
        onTap: () => context.push(Routes.habit(h.id)),
        semanticLabel: h.name,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.rowHorizontal, vertical: AppSpacing.rowVertical),
          child: Row(
            children: [
              habitTileFor(context, h, size: AppSizes.rowIcon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(h.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: t.body.copyWith(height: 1.3)),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        TintBadge(label: l.freq(h.frequency), fg: tone.fg, bg: tone.bg),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppIcon('flame', size: 14, color: c.flame, strokeWidth: 2),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                h.isBad && s.slippedToday ? l.freshStart : streakText(l, h, s),
                                style: t.caption.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                  color: h.isBad && s.slippedToday ? c.sub : c.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (meta != null) Text(meta, style: t.caption.copyWith(height: 1.2)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (h.isGood)
                CheckButton(
                  done: s.doneToday,
                  label: s.doneToday ? l.undoA11y(h.name) : l.markDoneA11y(h.name),
                  onTap: () => actions.toggleDone(h, s),
                )
              else
                _SlipButton(slipped: s.slippedToday, onTap: () => s.slippedToday ? actions.undoSlip(h) : actions.confirmSlip(h, s)),
            ],
          ),
        ),
      ),
    );

    return SwipeActions(
      actions: [
        if (h.isGood && !s.doneToday && !s.skippedToday)
          SwipeAction(icon: 'skip', label: l.skip, color: c.chip, fg: c.sub, onTap: () => actions.skip(h)),
        SwipeAction(icon: 'edit', label: l.edit, color: c.goodSoft, fg: c.goodText, onTap: () => actions.edit(h)),
        SwipeAction(icon: 'trash', label: l.delete, color: c.badSoft, fg: c.badText, onTap: () => actions.deleteWithUndo(h)),
      ],
      endAction: h.isGood && !s.doneToday
          ? SwipeAction(icon: 'check', label: l.done, color: c.good, fg: c.onGood, onTap: () => actions.toggleDone(h, s))
          : null,
      child: card,
    );
  }
}

/// One-tap check button with a pop (0.94 → 1.18 → 1.0) and a ray burst.
class CheckButton extends StatefulWidget {
  const CheckButton({super.key, required this.done, required this.onTap, required this.label, this.size = 44});
  final bool done;
  final VoidCallback onTap;
  final String label;
  final double size;

  @override
  State<CheckButton> createState() => _CheckButtonState();
}

class _CheckButtonState extends State<CheckButton> with TickerProviderStateMixin {
  late final AnimationController _pop = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
  late final AnimationController _burst = AnimationController(vsync: this);
  late final Animation<double> _scale = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: .94, end: 1.18).chain(CurveTween(curve: Curves.easeOut)), weight: 45),
    TweenSequenceItem(tween: Tween(begin: 1.18, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 55),
  ]).animate(_pop);

  @override
  void didUpdateWidget(CheckButton old) {
    super.didUpdateWidget(old);
    if (widget.done && !old.done) {
      _pop.forward(from: 0);
      if (_burst.duration != null) _burst.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pop.dispose();
    _burst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final d = widget.done;
    return Semantics(
      button: true,
      toggled: d,
      label: widget.label,
      excludeSemantics: true,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
              left: -22,
              top: -22,
              right: -22,
              bottom: -22,
              child: IgnorePointer(
                // Only drawn while the burst plays, so the idle first frame never shows.
                child: AnimatedBuilder(
                  animation: _burst,
                  builder: (context, child) =>
                      Visibility(visible: _burst.isAnimating, maintainState: true, maintainAnimation: true, child: child!),
                  child: Lottie.asset(
                    'assets/lottie/check_pop.json',
                    controller: _burst,
                    onLoaded: (comp) => _burst.duration = comp.duration,
                    delegates: LottieDelegates(
                      values: [
                        ValueDelegate.strokeColor(const ['**'], value: c.good),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _pop,
              builder: (context, child) => Transform.scale(scale: _pop.isAnimating ? _scale.value : (d ? 1 : .94), child: child),
              child: GestureDetector(
                onTap: widget.onTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: d ? c.good : c.field),
                  alignment: Alignment.center,
                  child: AppIcon('check', size: widget.size / 2, color: d ? c.onGood : c.faint, strokeWidth: 2.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlipButton extends StatelessWidget {
  const _SlipButton({required this.slipped, required this.onTap});
  final bool slipped;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    return Pressable(
      onTap: onTap,
      semanticLabel: slipped ? l.undo : l.slip,
      child: Container(
        constraints: const BoxConstraints(minHeight: 40, minWidth: 44),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: slipped ? c.field : c.badSoft, borderRadius: AppRadii.pillAll),
        child: Text(slipped ? l.undo : l.slip, style: context.text.buttonSmall.copyWith(fontSize: 14, color: slipped ? c.sub : c.badText)),
      ),
    );
  }
}
