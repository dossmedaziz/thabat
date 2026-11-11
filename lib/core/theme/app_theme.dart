import 'package:flutter/material.dart';

import 'app_colors.dart';

const kArabicFont = 'IBMPlexSansArabic';
const kLatinFont = 'IBMPlexSans';

String fontFor(String languageCode) => languageCode == 'ar' ? kArabicFont : kLatinFont;
List<String> fallbackFor(String languageCode) => [languageCode == 'ar' ? kLatinFont : kArabicFont];

ThemeData buildTheme(Brightness brightness, String languageCode) {
  final c = brightness == Brightness.dark ? ThabatColors.dark : ThabatColors.light;
  final family = fontFor(languageCode);
  final scheme = ColorScheme.fromSeed(
    seedColor: c.good,
    brightness: brightness,
  ).copyWith(
    primary: c.goodBtn,
    onPrimary: c.onGood,
    secondary: c.bad,
    onSecondary: c.onBad,
    error: c.badText,
    surface: c.card,
    onSurface: c.text,
    surfaceContainerHighest: c.track,
    outline: c.line,
  );
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    fontFamily: family,
    fontFamilyFallback: fallbackFor(languageCode),
    scaffoldBackgroundColor: c.bg,
    extensions: [c],
  );
  final height = languageCode == 'ar' ? 1.55 : 1.35;
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: c.text, displayColor: c.text).copyWith(
          headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, height: 1.4, color: c.text),
          titleLarge: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, height: height, color: c.text),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: height, color: c.text),
          bodyLarge: TextStyle(fontSize: 16, height: height, color: c.text),
          bodyMedium: TextStyle(fontSize: 14, height: height, color: c.text),
          bodySmall: TextStyle(fontSize: 13, height: height, color: c.sub),
          labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.text),
        )
        // The styles above are new TextStyles without a family: re-apply IBM Plex to all of them,
        // otherwise text silently falls back to the system font (Roboto / default Arabic).
        .apply(fontFamily: family, fontFamilyFallback: fallbackFor(languageCode)),
    primaryTextTheme: base.primaryTextTheme.apply(fontFamily: family, fontFamilyFallback: fallbackFor(languageCode)),
    appBarTheme: AppBarTheme(
      backgroundColor: c.bg,
      foregroundColor: c.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: brightness == Brightness.dark ? const Color(0xFF2E363F) : const Color(0xFF15181D),
      contentTextStyle: TextStyle(fontFamily: family, color: Colors.white, fontSize: 14),
      actionTextColor: brightness == Brightness.dark ? c.goodText : const Color(0xFF7FD9BF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.card,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.field,
      contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.good, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.bad, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c.bad, width: 2)),
      hintStyle: TextStyle(color: c.faint),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.good : c.off),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(44, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: TextStyle(fontFamily: family, fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(44, 44),
        foregroundColor: c.goodText,
        textStyle: TextStyle(fontFamily: family, fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    dividerTheme: DividerThemeData(color: c.line, thickness: 1, space: 1),
    timePickerTheme: TimePickerThemeData(backgroundColor: c.card),
  );
}
