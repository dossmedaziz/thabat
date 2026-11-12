import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/achievements/presentation/celebration_overlay.dart';
import '../../features/habits/application/habits_controller.dart';
import '../../features/notifications/notification_service.dart';
import '../l10n/l10n_x.dart';
import '../router/app_router.dart';
import '../theme/app_colors.dart';
import '../utils/clock.dart';
import 'app_icon.dart';
import 'pressable.dart';
import '../theme/app_tokens.dart';

/// Bottom-navigation shell. Also hosts celebration overlays and notification deep links.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> with WidgetsBindingObserver {
  StreamSubscription<String>? _taps;
  bool _showingCelebration = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final n = ref.read(notificationServiceProvider);
    _taps = n.taps.listen(_openHabit);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = n.takeLaunchHabitId();
      if (id != null) _openHabit(id);
      _maybeCelebrate();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _taps?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(todayProvider.notifier).refresh();
      ref.read(appDataControllerProvider.notifier).refresh(); // push offline changes, pull latest
    }
  }

  void _openHabit(String id) {
    if (!mounted) return;
    if (ref.read(habitByIdProvider(id)) == null) return;
    GoRouter.of(context).push(Routes.habit(id));
  }

  Future<void> _maybeCelebrate() async {
    if (_showingCelebration || !mounted) return;
    final queue = ref.read(celebrationsProvider);
    if (queue.isEmpty) return;
    _showingCelebration = true;
    await showCelebration(context, queue.first);
    ref.read(celebrationsProvider.notifier).pop();
    _showingCelebration = false;
    if (mounted) _maybeCelebrate();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(celebrationsProvider, (_, next) {
      if (next.isNotEmpty) _maybeCelebrate();
    });
    return Scaffold(
      body: widget.shell,
      bottomNavigationBar: ThabatNavBar(
        index: widget.shell.currentIndex,
        onSelect: (i) => widget.shell.goBranch(i, initialLocation: i == widget.shell.currentIndex),
        onAdd: () => context.push(Routes.newHabit()),
      ),
    );
  }
}

/// Bottom bar from the design: 4 tabs with a raised "+" in the middle.
/// Order follows the reading direction, so in Arabic "اليوم" is on the right.
class ThabatNavBar extends StatelessWidget {
  const ThabatNavBar({super.key, required this.index, required this.onSelect, required this.onAdd});
  final int index;
  final ValueChanged<int> onSelect;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    Widget tab(int i, String icon, String label) {
      final on = i == index;
      return Expanded(
        child: Semantics(
          selected: on,
          button: true,
          label: label,
          excludeSemantics: true,
          child: Pressable(
            onTap: () => onSelect(i),
            button: false,
            child: SizedBox(
              height: 54,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIcon(icon, size: 24, color: on ? c.primary : c.sub, strokeWidth: on ? 2.1 : 1.8),
                  const SizedBox(height: 3),
                  Text(label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, height: 1.3, fontWeight: FontWeight.w600, color: on ? c.primary : c.sub)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(color: c.tab, border: Border(top: BorderSide(color: c.line))),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tab(0, 'home', l.tabToday),
              tab(1, 'chart', l.tabProgress),
              Expanded(
                child: Center(
                  // Cashflow's add button: a neutral pill, flat (no glow, not raised).
                  child: Pressable(
                    semanticLabel: l.addHabit,
                    onTap: onAdd,
                    haptic: true,
                    child: Container(
                      width: 64,
                      height: 46,
                      decoration: BoxDecoration(color: c.fab, borderRadius: AppRadii.pillAll),
                      alignment: Alignment.center,
                      child: AppIcon('plus', size: 26, color: c.fabFg, strokeWidth: 2.4),
                    ),
                  ),
                ),
              ),
              tab(2, 'award', l.tabAchievements),
              tab(3, 'profile', l.tabProfile),
            ],
          ),
        ),
      ),
    );
  }
}
