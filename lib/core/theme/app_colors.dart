import 'package:flutter/material.dart';

/// Color tokens, following the Cashflow design system:
/// flat surfaces (no shadows or gradients), indigo for actions, mint for good news
/// ("done", good habits), rose for bad habits / destructive actions, and a soft
/// pastel per habit.
///
/// Thabat's semantic names are kept (good / bad / gold …) so every screen picks
/// up the palette; Cashflow's own roles (primary, hero, lilac …) are added.
@immutable
class ThabatColors extends ThemeExtension<ThabatColors> {
  const ThabatColors({
    required this.brightness,
    required this.bg,
    required this.card,
    required this.text,
    required this.textSecondary,
    required this.sub,
    required this.faint,
    required this.line,
    required this.track,
    required this.chip,
    required this.field,
    required this.fieldPressed,
    required this.segOn,
    required this.tab,
    required this.primary,
    required this.onPrimary,
    required this.hero,
    required this.heroChip,
    required this.avatarBg,
    required this.avatarFg,
    required this.fab,
    required this.fabFg,
    required this.lilac,
    required this.lilacBg,
    required this.toastBg,
    required this.toastFg,
    required this.handle,
    required this.good,
    required this.goodText,
    required this.goodSoft,
    required this.goodBtn,
    required this.onGood,
    required this.bad,
    required this.badText,
    required this.badSoft,
    required this.onBad,
    required this.flame,
    required this.flameFill,
    required this.gold,
    required this.goldText,
    required this.goldSoft,
    required this.lockBg,
    required this.lockIcon,
    required this.missLine,
    required this.skip,
    required this.off,
  });

  final Brightness brightness;

  /// Screen background / cards & sheets / inputs and keys.
  final Color bg, card, field, fieldPressed;
  final Color text, textSecondary;

  /// Muted text (Cashflow "muted").
  final Color sub;
  final Color faint;

  /// Dividers between rows (Cashflow "stroke").
  final Color line;

  /// Progress tracks, unselected segment track.
  final Color track;

  /// Small neutral pills.
  final Color chip;
  final Color segOn;

  /// Bottom navigation surface.
  final Color tab;

  /// Indigo — every main action (buttons, selected chips/segments, add).
  final Color primary, onPrimary;

  /// Indigo-tinted hero card and the pill on it.
  final Color hero, heroChip;
  final Color avatarBg, avatarFg;

  /// Neutral add button.
  final Color fab, fabFg;

  /// Links, undo, secondary accents.
  final Color lilac, lilacBg;
  final Color toastBg, toastFg;

  /// Bottom-sheet grab handle.
  final Color handle;

  /// Good habits / done (mint). [goodBtn] is the action color (= primary).
  final Color good, goodText, goodSoft, goodBtn, onGood;

  /// Bad habits / slips / destructive (rose).
  final Color bad, badText, badSoft, onBad;

  /// Streak flame (peach).
  final Color flame, flameFill;

  /// Badges (yellow).
  final Color gold, goldText, goldSoft, lockBg, lockIcon;
  final Color missLine, skip, off;

  /// Flat design: no shadows anywhere.
  List<BoxShadow> get shadow => const [];

  /// Bottom-sheet scrim: black 55%.
  Color get scrim => const Color(0x8C000000);

  static const dark = ThabatColors(
    brightness: Brightness.dark,
    bg: Color(0xFF1C1C1E),
    card: Color(0xFF262629),
    field: Color(0xFF2E2E32),
    fieldPressed: Color(0xFF38383D),
    text: Color(0xFFF2F2F4),
    textSecondary: Color(0xFFD4D4D8),
    sub: Color(0xFF8E8E93),
    faint: Color(0xFF5E5E66),
    line: Color(0xFF333337),
    track: Color(0xFF2E2E32),
    chip: Color(0xFF2E2E32),
    segOn: Color(0xFF4263EB),
    tab: Color(0xFF1C1C1E),
    primary: Color(0xFF4263EB),
    onPrimary: Color(0xFFFFFFFF),
    hero: Color(0xFF262A40),
    heroChip: Color(0x12FFFFFF),
    avatarBg: Color(0xFF2E3350),
    avatarFg: Color(0xFFAFC0FF),
    fab: Color(0xFF2E2E32),
    fabFg: Color(0xFFFFFFFF),
    lilac: Color(0xFFC4B5FD),
    lilacBg: Color(0x24C4B5FD),
    toastBg: Color(0xFF26262C),
    toastFg: Color(0xFFF4F4F6),
    handle: Color(0xFF3A3A42),
    good: Color(0xFF6EE7B7),
    goodText: Color(0xFF6EE7B7),
    goodSoft: Color(0x1F6EE7B7),
    goodBtn: Color(0xFF4263EB),
    onGood: Color(0xFF052E22),
    bad: Color(0xFFFB7185),
    badText: Color(0xFFFB7185),
    badSoft: Color(0x24FB7185),
    onBad: Color(0xFF3B0A14),
    flame: Color(0xFFFDBA74),
    flameFill: Color(0x33FDBA74),
    gold: Color(0xFFFDE68A),
    goldText: Color(0xFFFDE68A),
    goldSoft: Color(0x24FDE68A),
    lockBg: Color(0xFF2E2E32),
    lockIcon: Color(0xFF5E5E66),
    missLine: Color(0xFF5E5E66),
    skip: Color(0xFF38383D),
    off: Color(0xFF3A3A42),
  );

  static const light = ThabatColors(
    brightness: Brightness.light,
    bg: Color(0xFFF2F2F4),
    card: Color(0xFFFFFFFF),
    field: Color(0xFFE9E9EE),
    fieldPressed: Color(0xFFDCDCE2),
    text: Color(0xFF111114),
    textSecondary: Color(0xFF3F3F46),
    sub: Color(0xFF62626B),
    faint: Color(0xFFA1A1AA),
    line: Color(0xFFEBEBEF),
    track: Color(0xFFE9E9EE),
    chip: Color(0xFFE9E9EE),
    segOn: Color(0xFF4263EB),
    tab: Color(0xFFF2F2F4),
    primary: Color(0xFF4263EB),
    onPrimary: Color(0xFFFFFFFF),
    hero: Color(0xFFE6EAFF),
    heroChip: Color(0x0F111114),
    avatarBg: Color(0xFFE3E7FF),
    avatarFg: Color(0xFF3046C5),
    fab: Color(0xFF111114),
    fabFg: Color(0xFFFFFFFF),
    lilac: Color(0xFF6D28D9),
    lilacBg: Color(0xFFEDE9FE),
    toastBg: Color(0xFF26262C),
    toastFg: Color(0xFFF4F4F6),
    handle: Color(0xFFD4D4DA),
    good: Color(0xFF10B981),
    goodText: Color(0xFF047857),
    goodSoft: Color(0xFFD1FAE5),
    goodBtn: Color(0xFF4263EB),
    onGood: Color(0xFFFFFFFF),
    bad: Color(0xFFF43F5E),
    badText: Color(0xFFE11D48),
    badSoft: Color(0xFFFFE4E6),
    onBad: Color(0xFFFFFFFF),
    flame: Color(0xFFC2410C),
    flameFill: Color(0xFFFFEDD5),
    gold: Color(0xFFEAB308),
    goldText: Color(0xFFA16207),
    goldSoft: Color(0xFFFEF3C7),
    lockBg: Color(0xFFE9E9EE),
    lockIcon: Color(0xFFA1A1AA),
    missLine: Color(0xFFA1A1AA),
    skip: Color(0xFFDCDCE2),
    off: Color(0xFFD4D4DA),
  );

  @override
  ThabatColors copyWith() => this;

  @override
  ThabatColors lerp(ThemeExtension<ThabatColors>? other, double t) =>
      (other is ThabatColors && t > .5) ? other : this;
}

/// A habit color resolved for the current theme (Cashflow's CategoryTone).
@immutable
class HabitTone {
  const HabitTone({required this.fg, required this.bg, required this.selectedBg});

  /// Icon and label color.
  final Color fg;

  /// Tinted fill behind icons and badges.
  final Color bg;
  final Color selectedBg;
}

/// The 8 habit colors (Cashflow's category palette): pastel on a 14% tint in dark
/// mode, deep text on a pale fill in light mode.
class HabitPalette {
  const HabitPalette(this.id, this.hex);
  final String id;

  /// Stored value, e.g. '#6EE7B7'.
  final String hex;

  static const all = [
    HabitPalette('green', '#6EE7B7'),
    HabitPalette('teal', '#67E8F9'),
    HabitPalette('blue', '#93C5FD'),
    HabitPalette('violet', '#C4B5FD'),
    HabitPalette('pink', '#F9A8D4'),
    HabitPalette('red', '#FCA5A5'),
    HabitPalette('orange', '#FDBA74'),
    HabitPalette('yellow', '#FDE68A'),
  ];

  /// Default colors for new habits.
  static const goodDefault = '#6EE7B7';
  static const badDefault = '#FCA5A5';

  /// Colors saved by earlier versions of the app → closest new pastel.
  static const _legacy = {
    '#14A383': '#6EE7B7',
    '#3B7BE8': '#93C5FD',
    '#8B5CF6': '#C4B5FD',
    '#F0715A': '#FCA5A5',
    '#E8A317': '#FDE68A',
    '#E55A96': '#F9A8D4',
  };

  /// Light-theme pairs: stored color → (deep text, pale fill).
  static const _light = <String, (int, int)>{
    '#FDBA74': (0xFFC2410C, 0xFFFFEDD5),
    '#93C5FD': (0xFF1D4ED8, 0xFFDBEAFE),
    '#F9A8D4': (0xFFBE185D, 0xFFFCE7F3),
    '#FDE68A': (0xFFA16207, 0xFFFEF3C7),
    '#6EE7B7': (0xFF047857, 0xFFD1FAE5),
    '#67E8F9': (0xFF0E7490, 0xFFCFFAFE),
    '#C4B5FD': (0xFF6D28D9, 0xFFEDE9FE),
    '#FCA5A5': (0xFFB91C1C, 0xFFFEE2E2),
  };

  static String normalize(String hex) {
    final h = hex.toUpperCase().startsWith('#') ? hex.toUpperCase() : '#${hex.toUpperCase()}';
    return _legacy[h] ?? h;
  }

  static HabitPalette fromHex(String hex) {
    final h = normalize(hex);
    return all.firstWhere((p) => p.hex == h, orElse: () => all.first);
  }

  static Color parse(String hex) {
    final v = int.tryParse(normalize(hex).substring(1), radix: 16);
    return v == null ? const Color(0xFFC4C4CC) : Color(0xFF000000 | v);
  }

  Color get dot => parse(hex);

  static HabitTone resolve(String hex, Brightness brightness) {
    final h = normalize(hex);
    final base = parse(h);
    if (brightness == Brightness.dark) {
      return HabitTone(fg: base, bg: base.withValues(alpha: 0.14), selectedBg: base.withValues(alpha: 0.18));
    }
    final pair = _light[h];
    if (pair != null) return HabitTone(fg: Color(pair.$1), bg: Color(pair.$2), selectedBg: Color(pair.$2));
    final hsl = HSLColor.fromColor(base);
    final deep = hsl.withLightness((hsl.lightness * 0.45).clamp(0.2, 0.4)).toColor();
    final pale = hsl.withLightness(0.93).toColor();
    return HabitTone(fg: deep, bg: pale, selectedBg: pale);
  }

  /// (background, foreground) of the habit's icon badge.
  (Color bg, Color fg) tile(bool dark) {
    final t = resolve(hex, dark ? Brightness.dark : Brightness.light);
    return (t.bg, t.fg);
  }
}

extension ThabatColorsX on BuildContext {
  ThabatColors get colors => Theme.of(this).extension<ThabatColors>()!;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
