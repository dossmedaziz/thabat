import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_x.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
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
    final ok = await showModalBottomSheet<bool>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.slipConfirmTitle(h.name), style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(l.slipConfirmBody, style: TextStyle(fontSize: 15, color: c.sub)),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: c.bad, foregroundColor: c.onBad),
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l.slipConfirmYes),
              ),
              const SizedBox(height: 8),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: c.sub),
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l.cancel),
              ),
            ],
          ),
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

/// Simple confirmation dialog.
Future<bool> confirmDialog(BuildContext context,
    {required String title, required String body, required String confirm, bool destructive = true}) async {
  final c = context.colors;
  final l = context.l10n;
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
      content: Text(body),
      actions: [
        TextButton(style: TextButton.styleFrom(foregroundColor: c.sub), onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: destructive ? c.badText : c.goodText),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirm),
        ),
      ],
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
