import 'package:flutter/material.dart';

/// Design tokens taken from the Thabat design file (light + dark).
@immutable
class ThabatColors extends ThemeExtension<ThabatColors> {
  const ThabatColors({
    required this.bg,
    required this.card,
    required this.text,
    required this.sub,
    required this.faint,
    required this.line,
    required this.track,
    required this.chip,
    required this.field,
    required this.segOn,
    required this.tab,
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
    required this.shadow,
  });

  final Color bg, card, text, sub, faint, line, track, chip, field, segOn, tab;
  final Color good, goodText, goodSoft, goodBtn, onGood;
  final Color bad, badText, badSoft, onBad;
  final Color flame, flameFill, gold, goldText, goldSoft, lockBg, lockIcon;
  final Color missLine, skip, off;
  final List<BoxShadow> shadow;

  static const light = ThabatColors(
    bg: Color(0xFFF5F6F8),
    card: Color(0xFFFFFFFF),
    text: Color(0xFF15181D),
    sub: Color(0xFF5A6370),
    faint: Color(0xFFA3AAB3),
    line: Color(0xFFE7EAEE),
    track: Color(0xFFEBEEF1),
    chip: Color(0xFFF0F2F5),
    field: Color(0xFFF2F4F6),
    segOn: Color(0xFFFFFFFF),
    tab: Color(0xFFFFFFFF),
    good: Color(0xFF14A383),
    goodText: Color(0xFF0B7A61),
    goodSoft: Color(0xFFE2F5EF),
    goodBtn: Color(0xFF0C8569),
    onGood: Color(0xFFFFFFFF),
    bad: Color(0xFFF0715A),
    badText: Color(0xFFB8432D),
    badSoft: Color(0xFFFDECE7),
    onBad: Color(0xFFFFFFFF),
    flame: Color(0xFFE8792B),
    flameFill: Color(0xFFFFE3CC),
    gold: Color(0xFFE0A526),
    goldText: Color(0xFF8A5E00),
    goldSoft: Color(0xFFFCF3DC),
    lockBg: Color(0xFFE2E6EA),
    lockIcon: Color(0xFF8C949E),
    missLine: Color(0xFFA3AAB3),
    skip: Color(0xFFE6E9ED),
    off: Color(0xFFD5DAE0),
    shadow: [
      BoxShadow(color: Color(0x0A14181D), blurRadius: 2, offset: Offset(0, 1)),
      BoxShadow(color: Color(0x0F14181D), blurRadius: 20, offset: Offset(0, 6)),
    ],
  );

  static const dark = ThabatColors(
    bg: Color(0xFF0E1114),
    card: Color(0xFF171B21),
    text: Color(0xFFF1F3F5),
    sub: Color(0xFFA2ACB8),
    faint: Color(0xFF5D6772),
    line: Color(0xFF262D35),
    track: Color(0xFF232A32),
    chip: Color(0xFF232A32),
    field: Color(0xFF222830),
    segOn: Color(0xFF2E363F),
    tab: Color(0xFF13171C),
    good: Color(0xFF2BC59C),
    goodText: Color(0xFF5ED9B8),
    goodSoft: Color(0xFF14312A),
    goodBtn: Color(0xFF2BC59C),
    onGood: Color(0xFF062A21),
    bad: Color(0xFFFF8770),
    badText: Color(0xFFFF9F8C),
    badSoft: Color(0xFF3A2420),
    onBad: Color(0xFF3A140C),
    flame: Color(0xFFFFA45C),
    flameFill: Color(0xFF4A2E17),
    gold: Color(0xFFF4C152),
    goldText: Color(0xFFF4C152),
    goldSoft: Color(0xFF3A3120),
    lockBg: Color(0xFF20262D),
    lockIcon: Color(0xFF6D7782),
    missLine: Color(0xFF5D6772),
    skip: Color(0xFF2A3038),
    off: Color(0xFF3A424C),
    shadow: [],
  );

  @override
  ThabatColors copyWith() => this;

  @override
  ThabatColors lerp(ThemeExtension<ThabatColors>? other, double t) =>
      (other is ThabatColors && t > .5) ? other : this;
}

/// Palette offered in the habit editor (from the design).
class HabitPalette {
  const HabitPalette(this.id, this.dot, this.fg, this.bg);
  final String id;
  final Color dot, fg, bg;

  static const all = [
    HabitPalette('teal', Color(0xFF14A383), Color(0xFF0B7A61), Color(0xFFE2F5EF)),
    HabitPalette('blue', Color(0xFF3B7BE8), Color(0xFF2158B8), Color(0xFFE3EDFB)),
    HabitPalette('purple', Color(0xFF8B5CF6), Color(0xFF6340C2), Color(0xFFEEE8FB)),
    HabitPalette('coral', Color(0xFFF0715A), Color(0xFFB8432D), Color(0xFFFDECE7)),
    HabitPalette('amber', Color(0xFFE8A317), Color(0xFF8A5800), Color(0xFFFCF1D9)),
    HabitPalette('pink', Color(0xFFE55A96), Color(0xFFA8306A), Color(0xFFFBE6EF)),
  ];

  static HabitPalette fromHex(String hex) {
    final c = hex.toUpperCase().replaceAll('#', '');
    return all.firstWhere(
      (p) => p.dot.toARGB32().toRadixString(16).toUpperCase().substring(2) == c,
      orElse: () => all.first,
    );
  }

  String get hex => '#${dot.toARGB32().toRadixString(16).toUpperCase().substring(2)}';

  /// Tile colors for the current brightness (dark uses a translucent dot color).
  (Color bg, Color fg) tile(bool dark) => dark ? (dot.withValues(alpha: .2), dot) : (bg, fg);
}

extension ThabatColorsX on BuildContext {
  ThabatColors get colors => Theme.of(this).extension<ThabatColors>()!;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
