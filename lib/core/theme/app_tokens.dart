import 'package:flutter/widgets.dart';

/// Spacing on a 4 pt grid.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;

  /// Horizontal screen gutter.
  static const double gutter = 20;

  /// Hero card padding.
  static const double cardPadding = 22;

  /// Gap between day groups on Home.
  static const double groupGap = 18;

  /// List row padding.
  static const double rowVertical = 12;
  static const double rowHorizontal = 14;

  /// Gap between chips.
  static const double chipGap = 8;
}

abstract final class AppRadii {
  static const double swatch = 12;
  static const double field = 16;
  static const double listCard = 22;
  static const double hero = 24;
  static const double sheet = 28;
  static const double logo = 32;
  static const double pill = 999;

  static const BorderRadius fieldAll = BorderRadius.all(Radius.circular(field));
  static const BorderRadius listCardAll = BorderRadius.all(Radius.circular(listCard));
  static const BorderRadius heroAll = BorderRadius.all(Radius.circular(hero));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
  static const BorderRadius sheetTop = BorderRadius.vertical(top: Radius.circular(sheet));
}

/// Component sizes from the UI kit.
abstract final class AppSizes {
  static const double primaryButton = 56;
  static const double secondaryButton = 48;
  static const double iconButton = 44;
  static const double fabWidth = 112;
  static const double fabHeight = 60;
  static const double chip = 40;
  static const double pickerPill = 44;
  static const double rowIcon = 44;
  static const double key = 52;
  static const double field = 48;
  static const double input = 52;
}

/// Motion: ease-out, short, only to confirm what the user did.
abstract final class AppMotion {
  static const Curve ease = Cubic(0.2, 0.8, 0.2, 1);

  /// Button and key press (scale .96).
  static const Duration press = Duration(milliseconds: 120);

  /// Chip filter, toggles, color picks.
  static const Duration toggle = Duration(milliseconds: 200);

  /// Swipe reveal, list re-flow.
  static const Duration reflow = Duration(milliseconds: 300);

  /// Bottom sheet in and out.
  static const Duration sheet = Duration(milliseconds: 450);

  static const double pressedScale = 0.96;

  /// Undo toast lifetime.
  static const Duration toast = Duration(seconds: 5);

  /// Respect the OS "Reduce motion" setting.
  static bool reduced(BuildContext context) => MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  static Duration of(BuildContext context, Duration d) => reduced(context) ? Duration.zero : d;
}
