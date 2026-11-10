import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_x.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/clock.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../settings/application/settings_controller.dart';
import '../application/habits_controller.dart';
import '../domain/habit_stats.dart';
import '../domain/models.dart';
import 'widgets/habit_card.dart';

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});
  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  HabitType _tab = HabitType.good;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final data = ref.watch(appDataControllerProvider);
    if (!data.hasValue) return const Scaffold(body: LoadingView());
    final habits = ref.watch(habitsProvider);
    final logs = ref.watch(allLogsProvider);
    final today = ref.watch(todayProvider);
    final ws = ref.watch(settingsControllerProvider).weekStart;
    final user = data.value!.user;
    final name = user?.name ?? '';
    final hour = DateTime.now().hour;
    final greet = habits.isEmpty
        ? l.welcomeName(name)
        : hour < 12
            ? l.greetingMorning(name)
            : hour < 18
                ? l.greetingAfternoon(name)
                : l.greetingEvening(name);

    final p = dayProgress(habits, logs, today, ws);
    final list = habits.where((h) => h.type == _tab).toList();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 32),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.longDate(today), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: c.sub)),
                      Text(greet, style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                ),
                Semantics(
                  button: true,
                  label: l.tabProfile,
                  excludeSemantics: true,
                  child: GestureDetector(
                    onTap: () => context.go(Routes.profile),
                    child: UserAvatar(name: name, photoUrl: user?.photoUrl, size: 44, ring: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (habits.isEmpty)
              const _EmptyState()
            else ...[
              _RingCard(progress: p),
              const SizedBox(height: 16),
              Segmented<HabitType>(
                value: _tab,
                semanticLabel: l.habitTypeFilter,
                items: [(HabitType.good, l.build, c.good), (HabitType.bad, l.avoid, c.bad)],
                onChanged: (t) => setState(() => _tab = t),
              ),
              const SizedBox(height: 16),
              SectionTitle(
                _tab == HabitType.good ? l.buildHead : l.avoidHead,
                color: _tab == HabitType.good ? c.goodText : c.badText,
                trailing: Text(
                  _tab == HabitType.good
                      ? l.doneOf('${p.goodDone}', '${p.goodTotal}')
                      : l.cleanOf('${p.badDone}', '${p.badTotal}'),
                  style: TextStyle(fontSize: 13, color: c.sub),
                ),
              ),
              const SizedBox(height: 10),
              if (list.isEmpty)
                _TabEmpty(type: _tab)
              else
                for (final h in list)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: HabitCard(key: ValueKey(h.id), habit: h),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RingCard extends StatelessWidget {
  const _RingCard({required this.progress});
  final DayProgress progress;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final left = progress.total - progress.done;
    return AppCard(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 18, 20, 18),
      child: Row(
        children: [
          ProgressRing(
            value: progress.ratio,
            color: c.good,
            track: c.track,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(text: '${progress.done}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                  TextSpan(text: '/${progress.total}', style: TextStyle(fontSize: 16, color: c.sub, fontWeight: FontWeight.w600)),
                ]),
                textScaler: TextScaler.linear(MediaQuery.textScalerOf(context).scale(1).clamp(1, 1.3)),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.ringTitle('${progress.done}', '${progress.total}'), style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(progress.total == 0 ? l.ringNothingDue : l.ringLeft(left), style: TextStyle(fontSize: 14, color: c.sub)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabEmpty extends StatelessWidget {
  const _TabEmpty({required this.type});
  final HabitType type;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(type == HabitType.good ? l.emptyTabBuild : l.emptyTabAvoid, style: TextStyle(color: c.sub)),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => context.push(Routes.newHabit(type: type)),
            icon: AppIcon('plus', size: 20, color: c.goodText, strokeWidth: 2.2),
            label: Text(l.addHabit),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    Widget pick(String preset, String icon, String label, HabitType type) => ActionChip(
          onPressed: () => context.push(Routes.newHabit(type: type, preset: preset)),
          avatar: AppIcon(icon, size: 18, color: type == HabitType.good ? c.goodText : c.badText),
          label: Text(label),
          backgroundColor: c.card,
          side: BorderSide(color: c.line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 8),
        );
    return Column(
      children: [
        const SizedBox(height: 24),
        const _Plant(),
        const SizedBox(height: 16),
        Text(l.emptyTitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(l.emptyBody, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: c.sub)),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => context.push(Routes.newHabit()),
            icon: AppIcon('plus', size: 22, color: c.onGood, strokeWidth: 2.4),
            label: Text(l.emptyCta),
          ),
        ),
        const SizedBox(height: 24),
        Text(l.emptyOr, style: TextStyle(fontSize: 13, color: c.sub, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            pick('water', 'water', l.seedWater, HabitType.good),
            pick('read', 'read', l.seedRead, HabitType.good),
            pick('soda', 'soda', l.seedSoda, HabitType.bad),
          ],
        ),
      ],
    );
  }
}

/// Plant-in-a-pot illustration from the design's empty state.
class _Plant extends StatelessWidget {
  const _Plant();
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(color: c.goodSoft, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: CustomPaint(size: const Size(120, 120), painter: _PlantPainter(c)),
    );
  }
}

class _PlantPainter extends CustomPainter {
  _PlantPainter(this.c);
  final ThabatColors c;
  @override
  void paint(Canvas canvas, Size s) {
    canvas.scale(s.width / 200);
    canvas.translate(0, 10);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawLine(const Offset(100, 138), const Offset(100, 92), stroke..color = c.goodText..strokeWidth = 5);
    final leaf1 = Path()
      ..moveTo(100, 104)
      ..cubicTo(104, 84, 122, 74, 142, 77)
      ..cubicTo(140, 97, 124, 108, 100, 104);
    final leaf2 = Path()
      ..moveTo(100, 94)
      ..cubicTo(96, 70, 76, 58, 54, 62)
      ..cubicTo(56, 85, 74, 98, 100, 94);
    canvas.drawPath(leaf1, Paint()..color = c.good);
    canvas.drawPath(leaf1, stroke..color = c.goodText..strokeWidth = 4);
    canvas.drawPath(leaf2, Paint()..color = const Color(0xFF7FD9BF));
    canvas.drawPath(leaf2, stroke);
    final pot = Path()
      ..moveTo(70, 140)
      ..lineTo(130, 140)
      ..lineTo(124, 172)
      ..quadraticBezierTo(122, 178, 116, 178)
      ..lineTo(84, 178)
      ..quadraticBezierTo(78, 178, 76, 172)
      ..close();
    canvas.drawPath(pot, Paint()..color = c.card);
    canvas.drawPath(pot, stroke..color = c.text..strokeWidth = 4);
    canvas.drawLine(const Offset(62, 140), const Offset(138, 140), stroke..strokeWidth = 6);
    canvas.drawLine(const Offset(86, 158), const Offset(114, 158), stroke..color = c.bad..strokeWidth = 4);
  }

  @override
  bool shouldRepaint(_PlantPainter o) => o.c != c;
}
