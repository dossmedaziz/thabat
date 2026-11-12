import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import 'app_icon.dart';
import 'pressable.dart';

/// Filter chip (40 high). Active = solid indigo.
class FilterPill extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.dot,
    this.iconColor,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Line icon or a colored dot before the label (optional).
  final String? icon;
  final Color? dot;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final duration = AppMotion.of(context, AppMotion.toggle);
    final fg = selected ? c.onPrimary : c.textSecondary;
    return Pressable(
      onTap: onTap,
      selected: selected,
      semanticLabel: label,
      child: AnimatedContainer(
        duration: duration,
        curve: AppMotion.ease,
        height: AppSizes.chip,
        padding: EdgeInsetsDirectional.symmetric(horizontal: icon == null && dot == null ? 18 : 14),
        decoration: BoxDecoration(color: selected ? c.primary : c.card, borderRadius: AppRadii.pillAll),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              AppIcon(icon!, size: 16, strokeWidth: 1.9, color: selected ? c.onPrimary : iconColor ?? c.text),
              const SizedBox(width: 7),
            ] else if (dot != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: selected ? c.onPrimary : dot, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
            ],
            AnimatedDefaultTextStyle(
              duration: duration,
              style: context.text.body.copyWith(fontSize: 14, color: fg, height: 1.2),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

/// Choice pill (44 high) on a field background. Selected = tinted fill + 1.5 px border.
class PickerPill extends StatelessWidget {
  const PickerPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.tone,
    this.expand = true,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? icon;

  /// Accent for the selected state; defaults to indigo.
  final HabitTone? tone;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final accent = tone?.fg ?? c.primary;
    final selectedBg = tone?.selectedBg ?? c.primary.withValues(alpha: context.isDark ? .22 : .12);
    final duration = AppMotion.of(context, AppMotion.toggle);
    return Pressable(
      onTap: onTap,
      selected: selected,
      semanticLabel: label,
      child: AnimatedContainer(
        duration: duration,
        curve: AppMotion.ease,
        height: AppSizes.pickerPill,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? selectedBg : c.field,
          borderRadius: AppRadii.pillAll,
          border: Border.all(color: selected ? accent : Colors.transparent, width: 1.5),
        ),
        child: Row(
          mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              AppIcon(icon!, size: 17, strokeWidth: 1.9, color: tone?.fg ?? (selected ? accent : c.sub)),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: AnimatedDefaultTextStyle(
                duration: duration,
                style: context.text.body.copyWith(fontSize: 13, height: 1.2, color: selected ? accent : c.textSecondary),
                child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small tinted pill (11 / 600), e.g. a habit's frequency in its color.
class TintBadge extends StatelessWidget {
  const TintBadge({super.key, required this.label, required this.fg, required this.bg, this.large = false});
  final String label;
  final Color fg, bg;
  final bool large;

  @override
  Widget build(BuildContext context) => Container(
        padding: large
            ? const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 4)
            : const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: bg, borderRadius: AppRadii.pillAll),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.text.badge.copyWith(color: fg, fontSize: large ? 12 : 11),
        ),
      );
}
