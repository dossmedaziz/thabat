import 'package:flutter/material.dart';

import '../../../../core/widgets/app_icon.dart';

class SwipeAction {
  const SwipeAction({required this.icon, required this.label, required this.color, required this.fg, required this.onTap});
  final String icon;
  final String label;
  final Color color, fg;
  final VoidCallback onTap;
}

/// Card swipe: drag toward the start edge reveals [actions] on the end side;
/// drag toward the end edge past a threshold fires [onSwipeEnd] (e.g. "done").
/// Directions follow the layout direction, so everything mirrors in Arabic.
class SwipeActions extends StatefulWidget {
  const SwipeActions({super.key, required this.child, required this.actions, this.endAction});
  final Widget child;
  final List<SwipeAction> actions;
  final SwipeAction? endAction;

  @override
  State<SwipeActions> createState() => _SwipeActionsState();
}

class _SwipeActionsState extends State<SwipeActions> with SingleTickerProviderStateMixin {
  static const _actionW = 72.0;
  late final AnimationController _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 220));
  double _offset = 0; // logical: negative = toward start
  double _from = 0, _to = 0;

  double get _maxOpen => widget.actions.length * _actionW + 8;

  @override
  void initState() {
    super.initState();
    _ac.addListener(() => setState(() => _offset = _from + (_to - _from) * Curves.easeOutCubic.transform(_ac.value)));
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  void _animateTo(double v) {
    _from = _offset;
    _to = v;
    _ac.forward(from: 0);
  }

  void close() => _animateTo(0);

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final dir = rtl ? -1.0 : 1.0;
    return GestureDetector(
        onHorizontalDragUpdate: (d) {
          _ac.stop();
          setState(() {
            _offset = (_offset + d.delta.dx * dir).clamp(-_maxOpen - 24, widget.endAction == null ? 0.0 : 120.0);
          });
        },
        onHorizontalDragEnd: (d) {
          final v = (d.primaryVelocity ?? 0) * dir;
          if (_offset > 72 && widget.endAction != null) {
            widget.endAction!.onTap();
            _animateTo(0);
          } else if (_offset < -_maxOpen / 2 || v < -600) {
            _animateTo(-_maxOpen);
          } else {
            _animateTo(0);
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                children: [
                  if (widget.endAction != null && _offset > 0)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: widget.endAction!.color, borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsetsDirectional.only(start: 20),
                        alignment: AlignmentDirectional.centerStart,
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          AppIcon(widget.endAction!.icon, color: widget.endAction!.fg, strokeWidth: 2.4),
                          const SizedBox(width: 6),
                          Text(widget.endAction!.label,
                              style: TextStyle(color: widget.endAction!.fg, fontWeight: FontWeight.w700)),
                        ]),
                      ),
                    )
                  else
                    const Spacer(),
                  if (_offset < 0)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      child: Row(
                        children: [
                          for (final a in widget.actions)
                            Padding(
                              padding: const EdgeInsetsDirectional.only(start: 6),
                              child: Semantics(
                                button: true,
                                label: a.label,
                                excludeSemantics: true,
                                child: GestureDetector(
                                  onTap: () {
                                    close();
                                    a.onTap();
                                  },
                                  child: Container(
                                    width: _actionW - 6,
                                    height: double.infinity,
                                    decoration: BoxDecoration(color: a.color, borderRadius: BorderRadius.circular(18)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        AppIcon(a.icon, size: 20, color: a.fg, strokeWidth: 2),
                                        const SizedBox(height: 4),
                                        Text(a.label,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: a.fg)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(_offset * dir, 0),
              child: GestureDetector(
                onTap: _offset != 0 ? close : null,
                behavior: HitTestBehavior.deferToChild,
                child: AbsorbPointer(absorbing: _offset.abs() > 2, child: widget.child),
              ),
            ),
          ],
        ),
      );
  }
}
