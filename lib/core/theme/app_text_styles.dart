import 'package:flutter/material.dart';

/// Type scale from the style guide.
///
/// Inter renders Latin text and every digit; Arabic glyphs fall back to
/// IBM Plex Sans Arabic. Amounts use tabular figures.
@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.amount,
    required this.heroTotal,
    required this.title,
    required this.heading,
    required this.sheetTitle,
    required this.body,
    required this.bodyMedium,
    required this.subtitle,
    required this.label,
    required this.caption,
    required this.badge,
    required this.rowAmount,
    required this.button,
    required this.buttonSmall,
  });

  static const fontFamily = 'Inter';
  static const fontFallback = <String>['IBMPlexSansArabic'];
  static const tabular = <FontFeature>[FontFeature.tabularFigures()];

  /// 54 / 800 / −3%
  final TextStyle amount;

  /// 44 / 800 / −3%
  final TextStyle heroTotal;

  /// 30 / 800
  final TextStyle title;

  /// 26 / 700
  final TextStyle heading;

  /// 17 / 700
  final TextStyle sheetTitle;

  /// 15 / 600
  final TextStyle body;

  /// 14 / 500
  final TextStyle bodyMedium;

  /// 13 / 500 · muted
  final TextStyle subtitle;

  /// 13 / 600 · muted — section labels above fields.
  final TextStyle label;

  /// 12 / 500
  final TextStyle caption;

  /// 11 / 600
  final TextStyle badge;

  /// 16 / 700 tabular
  final TextStyle rowAmount;

  /// 17 / 700
  final TextStyle button;

  /// 15 / 600
  final TextStyle buttonSmall;

  /// Arabic reads best at 1.6 line-height, Latin at 1.4.
  static AppTextStyles build({required Color text, required Color muted, required bool arabic}) {
    final h = arabic ? 1.6 : 1.4;
    TextStyle s(double size, FontWeight w, {Color? color, double tracking = 0, double? height}) => TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFallback,
          fontSize: size,
          fontWeight: w,
          color: color ?? text,
          letterSpacing: size * tracking,
          height: height ?? h,
        );
    return AppTextStyles(
      amount: s(54, FontWeight.w800, tracking: -0.03, height: 1.15).copyWith(fontFeatures: tabular),
      heroTotal: s(44, FontWeight.w800, tracking: -0.03, height: 1.05).copyWith(fontFeatures: tabular),
      title: s(30, FontWeight.w800, tracking: -0.01, height: 1.25),
      heading: s(26, FontWeight.w700, tracking: -0.01, height: 1.3),
      sheetTitle: s(17, FontWeight.w700),
      body: s(15, FontWeight.w600),
      bodyMedium: s(14, FontWeight.w500),
      subtitle: s(13, FontWeight.w500, color: muted),
      label: s(13, FontWeight.w600, color: muted),
      caption: s(12, FontWeight.w500, color: muted),
      badge: s(11, FontWeight.w600, height: 1.3),
      rowAmount: s(16, FontWeight.w700, height: 1.25).copyWith(fontFeatures: tabular),
      button: s(17, FontWeight.w700, height: 1.2),
      buttonSmall: s(15, FontWeight.w600, height: 1.2),
    );
  }

  @override
  AppTextStyles copyWith() => this;

  @override
  AppTextStyles lerp(AppTextStyles? other, double t) {
    if (other == null) return this;
    TextStyle l(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return AppTextStyles(
      amount: l(amount, other.amount),
      heroTotal: l(heroTotal, other.heroTotal),
      title: l(title, other.title),
      heading: l(heading, other.heading),
      sheetTitle: l(sheetTitle, other.sheetTitle),
      body: l(body, other.body),
      bodyMedium: l(bodyMedium, other.bodyMedium),
      subtitle: l(subtitle, other.subtitle),
      label: l(label, other.label),
      caption: l(caption, other.caption),
      badge: l(badge, other.badge),
      rowAmount: l(rowAmount, other.rowAmount),
      button: l(button, other.button),
      buttonSmall: l(buttonSmall, other.buttonSmall),
    );
  }
}

extension AppTextStylesX on BuildContext {
  AppTextStyles get text => Theme.of(this).extension<AppTextStyles>()!;
}
