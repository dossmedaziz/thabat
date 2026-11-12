import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/l10n_x.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import 'app_button.dart';
import 'app_icon.dart';
import 'pressable.dart';

/// Flat card (r22, card surface, no shadow). Tappable cards scale on press.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsetsDirectional.all(16),
    this.color,
    this.radius = AppRadii.listCard,
    this.onTap,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final box = Container(
      padding: padding,
      decoration: BoxDecoration(color: color ?? context.colors.card, borderRadius: BorderRadius.circular(radius)),
      child: child,
    );
    return onTap == null ? box : Pressable(onTap: onTap, scale: .98, child: box);
  }
}

/// Several rows in one card, separated by hairlines (Cashflow's grouped list).
class GroupedCard extends StatelessWidget {
  const GroupedCard({super.key, required this.children, this.color});
  final List<Widget> children;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ClipRRect(
      borderRadius: AppRadii.listCardAll,
      child: ColoredBox(
        color: color ?? c.card,
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) Divider(height: 1, thickness: 1, color: c.line, indent: 72, endIndent: 0),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

/// Segmented control: card-colored track (r18, 4 px padding), 44-px segments,
/// the selected one solid indigo.
class Segmented<T> extends StatelessWidget {
  const Segmented({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.height = 44,
    this.semanticLabel,
    this.trackColor,
  });
  final T value;
  final List<(T, String, Color?)> items;
  final ValueChanged<T> onChanged;
  final double height;
  final String? semanticLabel;

  /// Track color; defaults to the card surface (use the field color on cards).
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final duration = AppMotion.of(context, AppMotion.toggle);
    return Semantics(
      label: semanticLabel,
      container: true,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: trackColor ?? c.card, borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              Expanded(
                child: Pressable(
                  onTap: () => onChanged(items[i].$1),
                  selected: items[i].$1 == value,
                  semanticLabel: items[i].$2,
                  child: AnimatedContainer(
                    duration: duration,
                    curve: AppMotion.ease,
                    constraints: BoxConstraints(minHeight: height),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: items[i].$1 == value ? c.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (items[i].$3 != null) ...[
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: items[i].$1 == value ? c.onPrimary : items[i].$3,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: AnimatedDefaultTextStyle(
                            duration: duration,
                            style: context.text.body.copyWith(
                              fontSize: 14,
                              height: 1.2,
                              color: items[i].$1 == value ? c.onPrimary : c.sub,
                            ),
                            child: Text(items[i].$2, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Circular progress ring. Fills clockwise in LTR and counter-clockwise in RTL.
class ProgressRing extends StatelessWidget {
  const ProgressRing({super.key, required this.value, required this.color, required this.track, this.size = 92, this.stroke = 10, this.child});
  final double value;
  final Color color, track;
  final double size, stroke;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: value.clamp(0, 1)),
        duration: AppMotion.of(context, const Duration(milliseconds: 500)),
        curve: AppMotion.ease,
        builder: (context, v, _) => CustomPaint(
          painter: _RingPainter(v, color, track, stroke, rtl),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.v, this.color, this.track, this.stroke, this.rtl);
  final double v, stroke;
  final Color color, track;
  final bool rtl;

  @override
  void paint(Canvas canvas, Size size) {
    final r = (size.shortestSide - stroke) / 2;
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: r);
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );
    if (v <= 0) return;
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * v * (rtl ? -1 : 1), false, p);
  }

  @override
  bool shouldRepaint(_RingPainter o) => o.v != v || o.color != color || o.track != track || o.rtl != rtl;
}

/// Linear bar that grows from the start edge (right in Arabic).
class DirectionalBar extends StatelessWidget {
  const DirectionalBar({super.key, required this.value, required this.color, required this.track, this.height = 10});
  final double value;
  final Color color, track;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Container(
        height: height,
        color: track,
        alignment: AlignmentDirectional.centerStart,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: value.clamp(0, 1)),
          duration: AppMotion.of(context, const Duration(milliseconds: 400)),
          curve: AppMotion.ease,
          builder: (_, v, _) => FractionallySizedBox(
            widthFactor: v,
            child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(height / 2))),
          ),
        ),
      ),
    );
  }
}

/// 44×44 round icon button on the card surface.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({super.key, required this.icon, required this.onTap, required this.tooltip, this.size = 44});
  final String icon;
  final VoidCallback onTap;
  final String tooltip;
  final double size;

  @override
  Widget build(BuildContext context) =>
      CircleIconButton(icon: icon, onPressed: onTap, semanticLabel: tooltip, size: size);
}

/// Habit glyph on a tinted circle (44 in rows, larger in headers).
class HabitTile extends StatelessWidget {
  const HabitTile({super.key, required this.glyph, required this.bg, required this.fg, this.size = AppSizes.rowIcon, this.radius});
  final String glyph;
  final Color bg, fg;
  final double size;

  /// Ignored: habit badges are always round (kept for older call sites).
  final double? radius;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: AppMotion.of(context, AppMotion.toggle),
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: HabitGlyph(glyph, size: size * 20 / 44, color: fg),
      );
}

/// Small neutral pill.
class Chip2 extends StatelessWidget {
  const Chip2(this.label, {super.key, this.bg, this.fg, this.bold = false});
  final String label;
  final Color? bg, fg;
  final bool bold;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg ?? c.field, borderRadius: AppRadii.pillAll),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.text.badge.copyWith(fontWeight: bold ? FontWeight.w700 : FontWeight.w600, color: fg ?? c.sub),
      ),
    );
  }
}

/// Group header above a list: label at the start, muted note at the end.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing, this.color});
  final String text;
  final Widget? trailing;
  final Color? color;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(text, style: context.text.body.copyWith(fontWeight: FontWeight.w700, color: color ?? context.colors.text)),
            ),
            ?trailing,
          ],
        ),
      );
}

/// Muted label above a group of controls (Settings).
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(start: 6, bottom: 10),
        child: Text(text, style: context.text.label),
      );
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});
  @override
  Widget build(BuildContext context) => Center(
        child: Semantics(
          label: context.l10n.loading,
          child: const SizedBox.square(dimension: 28, child: CircularProgressIndicator(strokeWidth: 2.5)),
        ),
      );
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, this.onRetry, this.message});
  final VoidCallback? onRetry;
  final String? message;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: c.badSoft, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: AppIcon('ban', size: 24, color: c.badText),
            ),
            const SizedBox(height: 14),
            Text(message ?? l.errorGeneric, textAlign: TextAlign.center, style: context.text.body),
            if (onRetry != null) ...[const SizedBox(height: 8), TextButton(onPressed: onRetry, child: Text(l.retry))],
          ],
        ),
      ),
    );
  }
}

/// Row with a title, optional subtitle and a switch.
class SwitchRow extends StatelessWidget {
  const SwitchRow({super.key, required this.title, this.subtitle, required this.value, required this.onChanged, this.leading});
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? leading;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return MergeSemantics(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onChanged == null ? null : () => onChanged!(!value),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 12)],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: context.text.body),
                    if (subtitle != null) Text(subtitle!, style: context.text.subtitle.copyWith(color: c.sub)),
                  ],
                ),
              ),
              Switch(value: value, onChanged: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}

/// Settings-style row: tinted icon circle · title · value · chevron.
class NavRow extends StatelessWidget {
  const NavRow({super.key, required this.title, required this.onTap, this.value, this.icon, this.iconFg, this.iconBg, this.titleColor});
  final String title;
  final String? value;
  final VoidCallback onTap;
  final String? icon;
  final Color? iconFg, iconBg, titleColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Pressable(
      onTap: onTap,
      semanticLabel: value == null ? title : '$title, $value',
      scale: .98,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.rowHorizontal, vertical: AppSpacing.rowVertical),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: AppSizes.rowIcon,
                height: AppSizes.rowIcon,
                decoration: BoxDecoration(color: iconBg ?? c.field, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: AppIcon(icon!, size: 20, color: iconFg ?? c.text, strokeWidth: 1.9),
              ),
              const SizedBox(width: 14),
            ],
            Expanded(child: Text(title, style: context.text.body.copyWith(fontSize: 16, color: titleColor))),
            if (value != null) ...[
              Flexible(
                child: Text(value!, maxLines: 1, overflow: TextOverflow.ellipsis, style: context.text.bodyMedium.copyWith(color: c.sub)),
              ),
              const SizedBox(width: 6),
            ],
            AppIcon('forward', size: 18, color: c.faint, strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}
