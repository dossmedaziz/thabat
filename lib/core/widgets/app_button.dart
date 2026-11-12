import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import 'app_icon.dart';
import 'pressable.dart';

enum AppButtonVariant {
  /// Indigo, 56 — main action.
  primary,

  /// Neutral field color, 48.
  secondary,

  /// Rose tint, 52 — destructive.
  danger,

  /// White, 58 — Continue with Google.
  google,
}

/// Flat pill button. No gradients, no shadows (except Google's white pill);
/// press = scale .96.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.height,
    this.expand = true,
    this.color,
    this.foreground,
  });

  const AppButton.google({super.key, required this.label, required this.onPressed, this.loading = false})
      : variant = AppButtonVariant.google,
        icon = null,
        height = 58,
        expand = true,
        color = null,
        foreground = null;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final String? icon;
  final bool loading;
  final double? height;
  final bool expand;

  /// Overrides the variant's colors (e.g. a rose "Yes, I slipped").
  final Color? color;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final enabled = onPressed != null && !loading;
    final (Color bg, Color fg, TextStyle style, double h) = switch (variant) {
      AppButtonVariant.primary => (c.primary, c.onPrimary, t.button, AppSizes.primaryButton),
      AppButtonVariant.secondary => (c.field, c.text, t.buttonSmall, AppSizes.secondaryButton),
      AppButtonVariant.danger => (c.badSoft, c.badText, t.buttonSmall.copyWith(fontWeight: FontWeight.w700), 52.0),
      AppButtonVariant.google => (const Color(0xFFFFFFFF), const Color(0xFF1F1F1F), t.buttonSmall.copyWith(fontSize: 16), 58.0),
    };
    final disabledLook = onPressed == null && !loading && variant == AppButtonVariant.primary;
    final effectiveBg = disabledLook ? c.field : (color ?? bg);
    final effectiveFg = disabledLook ? c.faint : (foreground ?? fg);

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2.2, color: effectiveFg))
        else ...[
          if (variant == AppButtonVariant.google) ...[const GoogleLogo(size: 22), const SizedBox(width: 12)],
          if (icon != null) ...[
            AppIcon(icon!, size: 20, color: effectiveFg, strokeWidth: 2.2),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: style.copyWith(color: effectiveFg)),
          ),
        ],
      ],
    );

    return Pressable(
      onTap: enabled ? onPressed : null,
      semanticLabel: label,
      child: AnimatedContainer(
        duration: AppMotion.of(context, AppMotion.toggle),
        height: height ?? h,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: effectiveBg,
          borderRadius: AppRadii.pillAll,
          boxShadow: variant == AppButtonVariant.google
              ? const [BoxShadow(color: Color(0x59000000), blurRadius: 30, offset: Offset(0, 10))]
              : null,
        ),
        child: ExcludeSemantics(child: content),
      ),
    );
  }
}

enum CircleButtonStyle {
  /// Card surface — header buttons (back, edit…).
  card,

  /// Field surface — sheet close.
  field,

  /// Rose tint — delete.
  danger,

  /// Indigo — add.
  primary,
}

/// 44-px round icon button (minimum touch target).
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.style = CircleButtonStyle.card,
    this.iconSize = 20,
    this.strokeWidth = 2,
    this.size = AppSizes.iconButton,
  });

  final String icon;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final CircleButtonStyle style;
  final double iconSize;
  final double strokeWidth;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (Color bg, Color fg) = switch (style) {
      CircleButtonStyle.card => (c.card, c.text),
      CircleButtonStyle.field => (c.field, c.textSecondary),
      CircleButtonStyle.danger => (c.badSoft, c.badText),
      CircleButtonStyle.primary => (c.primary, c.onPrimary),
    };
    return Tooltip(
      message: semanticLabel,
      child: Pressable(
        onTap: onPressed,
        semanticLabel: semanticLabel,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: AppIcon(icon, size: iconSize, color: fg, strokeWidth: strokeWidth),
        ),
      ),
    );
  }
}
