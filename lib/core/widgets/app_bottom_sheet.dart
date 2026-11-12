import 'package:flutter/material.dart';

import '../l10n/l10n_x.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.dart';
import 'app_button.dart';

/// Opens a bottom sheet: card surface, top radius 28, black 55% scrim,
/// 450 ms ease-out slide (instant with Reduce motion). Drag down or tap the
/// scrim to close.
Future<T?> showAppBottomSheet<T>({required BuildContext context, required WidgetBuilder builder}) {
  final reduced = AppMotion.reduced(context);
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: false,
    backgroundColor: context.colors.card,
    barrierColor: context.colors.scrim,
    sheetAnimationStyle: AnimationStyle(
      duration: reduced ? const Duration(milliseconds: 1) : AppMotion.sheet,
      reverseDuration: reduced ? const Duration(milliseconds: 1) : const Duration(milliseconds: 300),
      curve: AppMotion.ease,
    ),
    builder: builder,
  );
}

/// Grab handle (40×5 pill).
class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});
  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          width: 40,
          height: 5,
          decoration: BoxDecoration(color: context.colors.handle, borderRadius: AppRadii.pillAll),
        ),
      );
}

/// Sheet header: close · centered title · trailing (keeps the title centered).
class SheetHeader extends StatelessWidget {
  const SheetHeader({super.key, required this.title, this.trailing, this.onClose});
  final String title;
  final Widget? trailing;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          CircleIconButton(
            icon: 'close',
            style: CircleButtonStyle.field,
            iconSize: 18,
            semanticLabel: context.l10n.close,
            onPressed: onClose ?? () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Semantics(
              header: true,
              child: Text(title, textAlign: TextAlign.center, style: context.text.sheetTitle),
            ),
          ),
          const SizedBox(width: 12),
          trailing ?? const SizedBox(width: AppSizes.iconButton, height: AppSizes.iconButton),
        ],
      );
}

/// Sheet layout: grab handle, header, content.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.padding = const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 24),
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Padding(
        padding: padding.add(EdgeInsets.only(bottom: safeBottom > 0 ? safeBottom - 10 : 0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetHandle(),
            const SizedBox(height: 12),
            SheetHeader(title: title, trailing: trailing),
            const SizedBox(height: 12),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}
