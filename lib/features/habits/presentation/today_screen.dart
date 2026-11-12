import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_x.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/clock.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/chips.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/pressable.dart';
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
                      Text(l.longDate(today), style: context.text.subtitle),
                      const SizedBox(height: 2),
                      Text(greet, style: context.text.title),
                    ],
                  ),
                ),
                CircleIconButton(
                  icon: 'bell',
                  semanticLabel: l.remindersTitle,
                  onPressed: () => context.push(Routes.reminders),
                ),
                const SizedBox(width: 10),
                Pressable(
                  semanticLabel: l.tabProfile,
                  onTap: () => context.go(Routes.profile),
                  child: UserAvatar(name: name, photoUrl: user?.photoUrl, size: 44),
                ),
              ],
            ),
            const SizedBox(height: 22),
            if (habits.isEmpty)
              const _EmptyState()
            else ...[
              _HeroCard(progress: p, today: today),
              const SizedBox(height: 18),
              Semantics(
                label: l.habitTypeFilter,
                container: true,
                child: Row(children: [
                  FilterPill(label: l.build, dot: c.good, selected: _tab == HabitType.good, onTap: () => setState(() => _tab = HabitType.good)),
                  const SizedBox(width: AppSpacing.chipGap),
                  FilterPill(label: l.avoid, dot: c.bad, selected: _tab == HabitType.bad, onTap: () => setState(() => _tab = HabitType.bad)),
                ]),
              ),
              const SizedBox(height: AppSpacing.groupGap),
              SectionTitle(
                _tab == HabitType.good ? l.buildHead : l.avoidHead,
                trailing: Text(
                  _tab == HabitType.good
                      ? l.doneOf('${p.goodDone}', '${p.goodTotal}')
                      : l.cleanOf('${p.badDone}', '${p.badTotal}'),
                  style: context.text.subtitle,
                ),
              ),
              const SizedBox(height: 10),
              if (list.isEmpty)
                _TabEmpty(type: _tab)
              else
                GroupedCard(children: [for (final h in list) HabitCard(key: ValueKey(h.id), habit: h)]),
            ],
          ],
        ),
      ),
    );
  }
}

/// Hero card (Cashflow's total card): indigo tint, label + date pill, big
/// "done of total", a status pill, and the progress ring at the end.
class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.progress, required this.today});
  final DayProgress progress;
  final DateTime today;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final t = context.text;
    final left = progress.total - progress.done;
    final allDone = progress.total > 0 && left == 0;
    final (Color fg, Color bg, String icon) =
        allDone ? (c.good, c.goodSoft, 'check') : (c.text, c.heroChip, 'flame');
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(22, 22, 22, 20),
      decoration: BoxDecoration(color: c.hero, borderRadius: AppRadii.heroAll),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Flexible(child: Text(l.todayProgress, style: t.bodyMedium.copyWith(color: c.sub, height: 1.3))),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: c.heroChip, borderRadius: AppRadii.pillAll),
                    child: Text(l.shortDate(today), style: t.caption.copyWith(fontWeight: FontWeight.w600, height: 1.2)),
                  ),
                ]),
                const SizedBox(height: 10),
                Semantics(
                  label: l.ringTitle('${progress.done}', '${progress.total}'),
                  excludeSemantics: true,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: 8,
                    children: [
                      Text('${progress.done}', textDirection: TextDirection.ltr, style: t.heroTotal),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(bottom: 5),
                        child: Text(l.ofTotal('${progress.total}'), style: t.body.copyWith(fontSize: 17, color: c.sub, height: 1.2)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(color: bg, borderRadius: AppRadii.pillAll),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    AppIcon(icon, size: 15, strokeWidth: 2.2, color: allDone ? fg : c.flame),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        progress.total == 0 ? l.ringNothingDue : (allDone ? l.allDoneToday : l.ringLeft(left)),
                        style: t.subtitle.copyWith(color: fg, fontWeight: FontWeight.w600, height: 1.3),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          ProgressRing(value: progress.ratio, color: c.good, track: c.heroChip, size: 84, stroke: 9),
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
            icon: AppIcon('plus', size: 20, color: c.lilac, strokeWidth: 2.2),
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
    Widget pick(String preset, String icon, String label, HabitType type) => FilterPill(
          label: label,
          icon: icon,
          iconColor: type == HabitType.good ? c.goodText : c.badText,
          selected: false,
          onTap: () => context.push(Routes.newHabit(type: type, preset: preset)),
        );
    return Column(
      children: [
        const SizedBox(height: 24),
        const _Plant(),
        const SizedBox(height: 16),
        Text(l.emptyTitle, textAlign: TextAlign.center, style: context.text.sheetTitle.copyWith(fontSize: 21)),
        const SizedBox(height: 8),
        Text(l.emptyBody, textAlign: TextAlign.center, style: context.text.bodyMedium.copyWith(color: c.sub, fontWeight: FontWeight.w400, height: 1.7)),
        const SizedBox(height: 24),
        AppButton(label: l.emptyCta, icon: 'plus', onPressed: () => context.push(Routes.newHabit())),
        const SizedBox(height: 24),
        Text(l.emptyOr, style: context.text.label),
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
