import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n/l10n_x.dart';
import '../theme/app_colors.dart';
import 'app_icon.dart';

/// Rounded white card with the design's soft shadow.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding = const EdgeInsetsDirectional.all(16), this.color, this.radius = 20, this.onTap});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final br = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(color: color ?? c.card, borderRadius: br, boxShadow: c.shadow),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: br,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Segmented control from the design (track + raised selected segment).
class Segmented<T> extends StatelessWidget {
  const Segmented({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.height = 44,
    this.semanticLabel,
  });
  final T value;
  final List<(T, String, Color?)> items;
  final ValueChanged<T> onChanged;
  final double height;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: semanticLabel,
      container: true,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: c.track, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            for (final (v, label, dot) in items)
              Expanded(
                child: Semantics(
                  selected: v == value,
                  button: true,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onChanged(v),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      constraints: BoxConstraints(minHeight: height),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: v == value ? c.segOn : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: v == value ? const [BoxShadow(color: Color(0x1F000000), blurRadius: 3, offset: Offset(0, 1))] : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (dot != null) ...[
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Text(
                              label,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: v == value ? c.text : c.sub),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
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
    final base = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawCircle(center, r, base);
    if (v <= 0) return;
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;
    final sweep = 2 * math.pi * v * (rtl ? -1 : 1);
    canvas.drawArc(rect, -math.pi / 2, sweep, false, p);
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
          duration: const Duration(milliseconds: 400),
          builder: (_, v, _) => FractionallySizedBox(
            widthFactor: v,
            child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(height / 2))),
          ),
        ),
      ),
    );
  }
}

/// 44×44 round icon button on a card background.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({super.key, required this.icon, required this.onTap, required this.tooltip, this.size = 44});
  final String icon;
  final VoidCallback onTap;
  final String tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        excludeSemantics: true,
        child: Material(
          color: c.card,
          shape: const CircleBorder(),
          elevation: 0,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: c.shadow),
              child: AppIcon(icon, size: 22, color: c.text, strokeWidth: 2),
            ),
          ),
        ),
      ),
    );
  }
}

/// Colored tile holding the habit glyph.
class HabitTile extends StatelessWidget {
  const HabitTile({super.key, required this.glyph, required this.bg, required this.fg, this.size = 48, this.radius = 15});
  final String glyph;
  final Color bg, fg;
  final double size, radius;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(radius)),
        child: HabitGlyph(glyph, size: size / 2, color: fg),
      );
}

class Chip2 extends StatelessWidget {
  const Chip2(this.label, {super.key, this.bg, this.fg, this.bold = false});
  final String label;
  final Color? bg, fg;
  final bool bold;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(color: bg ?? c.chip, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: bold ? FontWeight.w700 : FontWeight.w600, color: fg ?? c.sub)),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing, this.color});
  final String text;
  final Widget? trailing;
  final Color? color;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(child: Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color ?? context.colors.text))),
            ?trailing,
          ],
        ),
      );
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});
  @override
  Widget build(BuildContext context) => Center(
        child: Semantics(
          label: context.l10n.loading,
          child: CircularProgressIndicator(color: context.colors.good),
        ),
      );
}

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, this.onRetry, this.message});
  final VoidCallback? onRetry;
  final String? message;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon('ban', size: 40, color: context.colors.sub),
            const SizedBox(height: 12),
            Text(message ?? l.errorGeneric, textAlign: TextAlign.center),
            if (onRetry != null) TextButton(onPressed: onRetry, child: Text(l.retry)),
          ],
        ),
      ),
    );
  }
}

/// Settings-style switch row.
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
      child: InkWell(
        onTap: onChanged == null ? null : () => onChanged!(!value),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 12)],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    if (subtitle != null) Text(subtitle!, style: TextStyle(fontSize: 13, color: c.sub)),
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
