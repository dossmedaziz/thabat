import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_x.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/common.dart';
import '../application/habits_controller.dart';
import '../domain/habit_stats.dart';
import '../domain/models.dart';

/// UI-level habit actions shared by the Today and Detail screens.
class HabitActions {
  HabitActions(this.context, this.ref);
  final BuildContext context;
  final WidgetRef ref;

  AppDataController get _c => ref.read(appDataControllerProvider.notifier);

  void toggleDone(Habit h, HabitStats s) {
    if (s.doneToday) {
      HapticFeedback.selectionClick();
      _c.removeLog(h.id);
    } else {
      HapticFeedback.mediumImpact();
      _c.setLog(h.id, LogStatus.done);
    }
  }

  void skip(Habit h) {
    HapticFeedback.selectionClick();
    _c.setLog(h.id, LogStatus.skipped);
    _snack(context.l10n.skippedSnack, onUndo: () => _c.removeLog(h.id));
  }

  Future<void> confirmSlip(Habit h, HabitStats s) async {
    final l = context.l10n;
    final c = context.colors;
    final ok = await showAppBottomSheet<bool>(
      context: context,
      builder: (ctx) => AppBottomSheet(
        title: l.slipConfirmTitle(h.name),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 4),
            Text(l.slipConfirmBody, textAlign: TextAlign.center, style: ctx.text.bodyMedium.copyWith(color: c.sub, height: 1.7)),
            const SizedBox(height: 20),
            AppButton(label: l.slipConfirmYes, variant: AppButtonVariant.danger, onPressed: () => Navigator.pop(ctx, true)),
            const SizedBox(height: 10),
            AppButton(label: l.cancel, variant: AppButtonVariant.secondary, onPressed: () => Navigator.pop(ctx, false)),
          ],
        ),
      ),
    );
    if (ok != true || !context.mounted) return;
    HapticFeedback.lightImpact();
    _c.setLog(h.id, LogStatus.slipped);
    _snack(l.slippedSnack('${s.daysClean}'), onUndo: () => _c.removeLog(h.id));
  }

  void undoSlip(Habit h) {
    HapticFeedback.selectionClick();
    _c.removeLog(h.id);
  }

  void edit(Habit h) => context.push(Routes.editHabit(h.id));

  void deleteWithUndo(Habit h) {
    final removed = _c.deleteHabit(h.id);
    if (removed == null) return;
    HapticFeedback.mediumImpact();
    _snack(context.l10n.deletedSnack(h.name), onUndo: () => _c.restoreHabit(removed));
  }

  void _snack(String text, {VoidCallback? onUndo}) {
    final m = ScaffoldMessenger.of(context);
    m.hideCurrentSnackBar();
    m.showSnackBar(SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 5),
      action: onUndo == null ? null : SnackBarAction(label: context.l10n.undo, onPressed: onUndo),
    ));
  }
}

/// Confirmation as a bottom sheet (Cashflow): title, message, danger + cancel pills.
Future<bool> confirmDialog(BuildContext context,
    {required String title, required String body, required String confirm, bool destructive = true}) async {
  final c = context.colors;
  final l = context.l10n;
  final r = await showAppBottomSheet<bool>(
    context: context,
    builder: (ctx) => AppBottomSheet(
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 4),
          Text(body, textAlign: TextAlign.center, style: ctx.text.bodyMedium.copyWith(color: c.sub, height: 1.7)),
          const SizedBox(height: 20),
          AppButton(
            label: confirm,
            variant: destructive ? AppButtonVariant.danger : AppButtonVariant.primary,
            onPressed: () => Navigator.pop(ctx, true),
          ),
          const SizedBox(height: 10),
          AppButton(label: l.cancel, variant: AppButtonVariant.secondary, onPressed: () => Navigator.pop(ctx, false)),
        ],
      ),
    ),
  );
  return r ?? false;
}

/// Tile colors for a habit glyph: custom palette or the type accent.
(Color, Color) habitTileColors(BuildContext context, Habit h) {
  final p = HabitPalette.fromHex(h.colorHex);
  return p.tile(context.isDark);
}

Widget habitTileFor(BuildContext context, Habit h, {double size = 48}) {
  final (bg, fg) = habitTileColors(context, h);
  return HabitTile(glyph: h.emoji, bg: bg, fg: fg, size: size, radius: size * .31);
}
