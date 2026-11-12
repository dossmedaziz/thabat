import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_tokens.dart';

/// Inter renders Latin text and every digit; Arabic glyphs fall back to
/// IBM Plex Sans Arabic (as in the Cashflow design system).
const kLatinFont = AppTextStyles.fontFamily;
const kArabicFont = 'IBMPlexSansArabic';

String fontFor(String languageCode) => AppTextStyles.fontFamily;
List<String> fallbackFor(String languageCode) => AppTextStyles.fontFallback;

ThemeData buildTheme(Brightness brightness, String languageCode) {
  final c = brightness == Brightness.dark ? ThabatColors.dark : ThabatColors.light;
  final isDark = brightness == Brightness.dark;
  final t = AppTextStyles.build(text: c.text, muted: c.sub, arabic: languageCode == 'ar');
  final scheme = ColorScheme(
    brightness: brightness,
    primary: c.primary,
    onPrimary: c.onPrimary,
    secondary: c.lilac,
    onSecondary: c.bg,
    error: c.badText,
    onError: c.onPrimary,
    surface: c.card,
    onSurface: c.text,
    surfaceContainerHighest: c.field,
    outline: c.line,
  );
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.bg,
    canvasColor: c.bg,
    fontFamily: AppTextStyles.fontFamily,
    fontFamilyFallback: AppTextStyles.fontFallback,
    // Flat design: presses scale to .96 (Pressable) instead of ink ripples.
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    extensions: [c, t],
  );
  final h = languageCode == 'ar' ? 1.6 : 1.4;
  return base.copyWith(
    textTheme: base.textTheme
        .apply(bodyColor: c.text, displayColor: c.text)
        .copyWith(
          headlineMedium: t.heading,
          titleLarge: t.sheetTitle.copyWith(fontSize: 19),
          titleMedium: t.body.copyWith(fontSize: 16),
          bodyLarge: TextStyle(fontSize: 16, height: h, color: c.text),
          bodyMedium: TextStyle(fontSize: 14, height: h, color: c.text),
          bodySmall: TextStyle(fontSize: 13, height: h, color: c.sub),
          labelLarge: t.buttonSmall,
        )
        // Re-apply the family to every style; styles built without one fall back
        // to the system font.
        .apply(fontFamily: AppTextStyles.fontFamily, fontFamilyFallback: AppTextStyles.fontFallback),
    primaryTextTheme: base.primaryTextTheme
        .apply(fontFamily: AppTextStyles.fontFamily, fontFamilyFallback: AppTextStyles.fontFallback),
    appBarTheme: AppBarTheme(
      backgroundColor: c.bg,
      foregroundColor: c.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: t.sheetTitle,
      systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    ),
    dividerTheme: DividerThemeData(color: c.line, thickness: 1, space: 1),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: c.primary,
      selectionColor: c.primary.withValues(alpha: 0.3),
      selectionHandleColor: c.primary,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: c.primary),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: c.toastBg,
      contentTextStyle: t.bodyMedium.copyWith(color: c.toastFg, fontSize: 14),
      actionTextColor: ThabatColors.dark.lilac,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      insetPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.card,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.heroAll),
      titleTextStyle: t.sheetTitle,
      contentTextStyle: t.bodyMedium.copyWith(color: c.sub, height: 1.6),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.card,
      modalBackgroundColor: c.card,
      surfaceTintColor: Colors.transparent,
      modalBarrierColor: c.scrim,
      showDragHandle: false,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.sheetTop),
      elevation: 0,
      modalElevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.field,
      contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 18, vertical: 15),
      border: const OutlineInputBorder(borderRadius: AppRadii.fieldAll, borderSide: BorderSide.none),
      enabledBorder: const OutlineInputBorder(borderRadius: AppRadii.fieldAll, borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: AppRadii.fieldAll, borderSide: BorderSide(color: c.primary, width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: AppRadii.fieldAll, borderSide: BorderSide(color: c.bad, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: AppRadii.fieldAll, borderSide: BorderSide(color: c.bad, width: 1.5)),
      hintStyle: TextStyle(color: c.faint),
      labelStyle: TextStyle(color: c.sub),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.primary : c.off),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: c.primary,
        foregroundColor: c.onPrimary,
        disabledBackgroundColor: c.field,
        disabledForegroundColor: c.faint,
        minimumSize: const Size(44, AppSizes.primaryButton),
        shape: const StadiumBorder(),
        elevation: 0,
        textStyle: t.button,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: c.text,
        backgroundColor: c.field,
        side: BorderSide.none,
        minimumSize: const Size(44, AppSizes.secondaryButton),
        shape: const StadiumBorder(),
        textStyle: t.buttonSmall,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(44, 44),
        foregroundColor: c.lilac,
        textStyle: t.buttonSmall,
      ),
    ),
    listTileTheme: ListTileThemeData(textColor: c.text, iconColor: c.sub),
    radioTheme: RadioThemeData(fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.primary : c.faint)),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: c.card,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.heroAll),
      hourMinuteColor: c.field,
      dayPeriodColor: c.field,
      dialBackgroundColor: c.field,
      dialHandColor: c.primary,
    ),
  );
}
