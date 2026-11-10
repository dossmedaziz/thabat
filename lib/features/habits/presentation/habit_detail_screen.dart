import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/l10n/l10n_x.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/clock.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/common.dart';
import '../../settings/application/settings_controller.dart';
import '../application/habits_controller.dart';
import '../domain/habit_stats.dart';
import '../domain/models.dart';
import 'habit_actions.dart';

class _Accent {
  const _Accent(this.fill, this.soft, this.text, this.on);
  final Color fill, soft, text, on;
  factory _Accent.of(BuildContext context, Habit h) {
    final c = context.colors;
    return h.isGood ? _Accent(c.good, c.goodSoft, c.goodText, c.onGood) : _Accent(c.bad, c.badSoft, c.badText, c.onBad);
  }
}

class HabitDetailScreen extends ConsumerStatefulWidget {
  const HabitDetailScreen({super.key, required this.habitId});
  final String habitId;
  @override
  ConsumerState<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends ConsumerState<HabitDetailScreen> {
  DateTime? _month;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final h = ref.watch(habitByIdProvider(widget.habitId));
    final s = ref.watch(habitStatsProvider(widget.habitId));
    final loading = !ref.watch(appDataControllerProvider).hasValue;
    if (h == null || s == null) {
      return Scaffold(
        appBar: AppBar(leading: _BackButton()),
        body: loading ? const LoadingView() : ErrorView(message: l.habitNotFound),
      );
    }
    final logs = ref.watch(allLogsProvider)[h.id] ?? const <String, HabitLog>{};
    final today = ref.watch(todayProvider);
    final ws = ref.watch(settingsControllerProvider).weekStart;
    final a = _Accent.of(context, h);
    final month = _month ?? DateTime(today.year, today.month, 1);
    final start = habitStart(h, logs);

    final streakLabel = h.isBad
        ? l.streakLabelClean
        : switch (h.frequency) {
            Frequency.daily => l.streakLabelDays,
            Frequency.weekly => l.streakLabelWeeks,
            Frequency.monthly => l.streakLabelMonths,
          };
    final freqLine = [
      l.freq(h.frequency),
      if (h.reminder?.enabled ?? false) l.time(h.reminder!.time),
    ].join(' · ');

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 32),
          children: [
            Row(
              children: [
                _BackButton(),
                const Spacer(),
                RoundIconButton(icon: 'bell', tooltip: l.reminderSettingsA11y, onTap: () => context.push(Routes.reminders)),
                const SizedBox(width: 10),
                RoundIconButton(icon: 'edit', tooltip: l.editHabit, onTap: () => context.push(Routes.editHabit(h.id))),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                habitTileFor(context, h, size: 56),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(h.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.4)),
                      Wrap(spacing: 6, runSpacing: 4, children: [
                        Chip2(h.isGood ? l.build : l.avoid, bg: a.soft, fg: a.text, bold: true),
                        Chip2(freqLine),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
            if (h.note != null) ...[
              const SizedBox(height: 10),
              Text('«${h.note}»', style: TextStyle(fontSize: 14, color: c.sub, fontStyle: FontStyle.italic)),
            ],
            const SizedBox(height: 16),
            // ---- streak card ----
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('${s.currentStreak}',
                              style: TextStyle(fontFamily: kLatinFont, fontSize: 80, fontWeight: FontWeight.w700, height: 1, letterSpacing: -2, color: c.text)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppIcon('flame', size: 26, color: c.flame, fill: c.flameFill, strokeWidth: 2),
                              Text(streakLabel, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.sub)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _MiniStat(value: h.isGood ? l.periodCount(s.bestStreak, h.frequency) : l.daysCount(s.bestClean), label: l.bestStreak),
                      const SizedBox(width: 10),
                      _MiniStat(value: l.percent(s.successRate), label: l.successRate),
                      const SizedBox(width: 10),
                      _MiniStat(
                        value: '${h.isGood ? s.totalDone : s.totalCleanDays}',
                        label: h.isGood ? l.totalCheckins : l.totalCleanDays,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _CalendarCard(
              habit: h,
              logs: logs,
              month: month,
              today: today,
              start: start,
              ws: ws,
              accent: a,
              onPrev: () => setState(() => _month = DateTime(month.year, month.month - 1, 1)),
              onNext: month.year == today.year && month.month == today.month
                  ? null
                  : () => setState(() => _month = DateTime(month.year, month.month + 1, 1)),
            ),
            const SizedBox(height: 16),
            _GoalCard(habit: h, stats: s, accent: a),
            const SizedBox(height: 16),
            SectionTitle(l.recentActivity),
            const SizedBox(height: 8),
            _History(habit: h, logs: logs, today: today, start: start, ws: ws, accent: a),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RoundIconButton(
        icon: 'back',
        tooltip: context.l10n.back,
        onTap: () => context.canPop() ? context.pop() : context.go(Routes.today),
      );
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label});
  final String value, label;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Expanded(
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
        decoration: BoxDecoration(color: c.chip, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: c.sub)),
          ],
        ),
      ),
    );
  }
}

enum _Cell { blank, future, none, done, clean, missed, slipped, skipped }

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.habit,
    required this.logs,
    required this.month,
    required this.today,
    required this.start,
    required this.ws,
    required this.accent,
    required this.onPrev,
    required this.onNext,
  });
  final Habit habit;
  final LogMap logs;
  final DateTime month, today, start;
  final WeekStart ws;
  final _Accent accent;
  final VoidCallback onPrev;
  final VoidCallback? onNext;

  _Cell _state(DateTime d) {
    if (d.isAfter(today)) return _Cell.future;
    if (d.isBefore(start)) return _Cell.none;
    final st = logs[dateKey(d)]?.status;
    if (habit.isBad) return st == LogStatus.slipped ? _Cell.slipped : _Cell.clean;
    if (st == LogStatus.done) return _Cell.done;
    if (st == LogStatus.skipped) return _Cell.skipped;
    if (sameDay(d, today)) return _Cell.none;
    final dueDaily = habit.frequency == Frequency.daily ||
        (habit.frequency == Frequency.weekly && habit.weekdays.contains(d.weekday));
    return dueDaily ? _Cell.missed : _Cell.none;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final order = orderedWeekdays(ws);
    final lead = (DateTime(month.year, month.month, 1).weekday - ws.isoWeekday + 7) % 7;
    final n = daysInMonth(month.year, month.month);
    final cells = <Widget>[
      for (final wd in order)
        Center(child: Text(l.weekdayShort(wd), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c.sub))),
      for (var i = 0; i < lead; i++) const SizedBox.shrink(),
      for (var d = 1; d <= n; d++) _dayCell(context, DateTime(month.year, month.month, d)),
    ];
    return AppCard(
      padding: const EdgeInsetsDirectional.fromSTEB(14, 8, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(tooltip: l.prevMonth, onPressed: onPrev, icon: AppIcon('back', size: 20, color: c.sub, strokeWidth: 2)),
              Expanded(
                child: Text(l.monthYear(month), textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              IconButton(
                tooltip: l.nextMonth,
                onPressed: onNext,
                icon: AppIcon('forward', size: 20, color: onNext == null ? c.line : c.sub, strokeWidth: 2),
              ),
            ],
          ),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1,
            children: cells,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              _Legend(color: accent.fill, label: habit.isGood ? l.legendDone : l.legendClean),
              if (habit.isGood) _Legend(dashed: c.missLine, label: l.legendMissed),
              if (habit.isBad) _Legend(color: c.badSoft, dot: c.bad, label: l.legendSlipped),
              if (habit.isGood) _Legend(color: c.skip, label: l.legendSkipped),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dayCell(BuildContext context, DateTime d) {
    final c = context.colors;
    final l = context.l10n;
    final st = _state(d);
    final isToday = sameDay(d, today);
    Color bg = Colors.transparent;
    Color fg = c.faint;
    var weight = FontWeight.w500;
    Border? border;
    var dashed = false;
    String status = '';
    switch (st) {
      case _Cell.done:
      case _Cell.clean:
        bg = accent.fill;
        fg = accent.on;
        weight = FontWeight.w700;
        status = st == _Cell.done ? l.legendDone : l.legendClean;
      case _Cell.missed:
        dashed = true;
        fg = c.sub;
        status = l.legendMissed;
      case _Cell.slipped:
        bg = c.badSoft;
        fg = c.badText;
        weight = FontWeight.w700;
        status = l.legendSlipped;
      case _Cell.skipped:
        bg = c.skip;
        fg = c.sub;
        status = l.legendSkipped;
      case _Cell.none:
        fg = c.sub;
      case _Cell.future:
      case _Cell.blank:
        break;
    }
    if (isToday && bg == Colors.transparent) {
      border = Border.all(color: accent.fill, width: 2);
      fg = c.text;
      weight = FontWeight.w700;
    }
    final text = Text('${d.day}', style: TextStyle(fontFamily: kLatinFont, fontSize: 13, fontWeight: weight, color: fg));
    return Semantics(
      label: [l.shortDate(d), if (status.isNotEmpty) status, if (isToday) l.todayLabel].join('، '),
      excludeSemantics: true,
      child: CustomPaint(
        painter: dashed ? _DashedRRect(c.missLine) : null,
        child: Container(
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: border),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              text,
              if (st == _Cell.slipped)
                Positioned(
                  bottom: 4,
                  child: Container(width: 5, height: 5, decoration: BoxDecoration(color: c.bad, shape: BoxShape.circle)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedRRect extends CustomPainter {
  _DashedRRect(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)).deflate(.75));
    for (final m in path.computeMetrics()) {
      var d = 0.0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + 4), p);
        d += 7;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRRect o) => o.color != color;
}

class _Legend extends StatelessWidget {
  const _Legend({this.color, this.dashed, this.dot, required this.label});
  final Color? color, dashed, dot;
  final String label;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          painter: dashed != null ? _DashedRRect(dashed!) : null,
          child: Container(
            width: 12,
            height: 12,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
            child: dot == null ? null : Container(width: 4, height: 4, margin: const EdgeInsets.only(bottom: 1), decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: c.sub)),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.habit, required this.stats, required this.accent});
  final Habit habit;
  final HabitStats stats;
  final _Accent accent;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final g = habit.goal;
    if (g == null) {
      return AppCard(
        padding: const EdgeInsetsDirectional.fromSTEB(18, 12, 12, 12),
        child: Row(
          children: [
            AppIcon('target', color: c.sub),
            const SizedBox(width: 10),
            Expanded(child: Text(l.noGoal, style: TextStyle(color: c.sub))),
            TextButton(onPressed: () => context.push(Routes.editHabit(habit.id)), child: Text(l.addGoal)),
          ],
        ),
      );
    }
    final x = l.unitCount(g.value, g.unit);
    final title = g.kind == GoalKind.total ? l.goalTitleTotal(x) : (habit.isBad ? l.goalTitleAvoid(x) : l.goalTitleStreak(x));
    final current = stats.goalCurrent.clamp(0, g.value);
    final pct = stats.goalProgress ?? 0;
    final miles = {for (final f in const [.25, .5, .75, 1.0]) (g.value * f).round().clamp(1, g.value)}.toList();
    final remaining = g.value - current;
    return AppCard(
      padding: const EdgeInsetsDirectional.fromSTEB(18, 16, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text('$current / ${g.value}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: accent.text)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(builder: (context, box) {
            final w = box.maxWidth;
            return SizedBox(
              height: 44,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  PositionedDirectional(
                    start: 0,
                    end: 0,
                    top: 6,
                    child: DirectionalBar(value: pct, color: accent.fill, track: c.track),
                  ),
                  for (final m in miles) ...[
                    PositionedDirectional(
                      start: (w * m / g.value - 11).clamp(0, w - 22),
                      top: 0,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: current >= m ? accent.fill : c.track,
                          shape: BoxShape.circle,
                          border: Border.all(color: c.card, width: 3),
                        ),
                        alignment: Alignment.center,
                        child: current >= m ? AppIcon('check', size: 10, color: accent.on, strokeWidth: 3.2) : null,
                      ),
                    ),
                    PositionedDirectional(
                      start: (w * m / g.value - 20).clamp(-4, w - 36),
                      top: 24,
                      child: SizedBox(
                        width: 40,
                        child: Text('$m',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: current >= m ? accent.text : c.sub)),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
          const SizedBox(height: 6),
          Text(remaining <= 0 ? l.goalReachedMsg : l.goalRemaining(l.unitCount(remaining, g.unit)),
              style: TextStyle(fontSize: 14, color: c.sub)),
        ],
      ),
    );
  }
}

class _History extends StatelessWidget {
  const _History({required this.habit, required this.logs, required this.today, required this.start, required this.ws, required this.accent});
  final Habit habit;
  final LogMap logs;
  final DateTime today, start;
  final WeekStart ws;
  final _Accent accent;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final items = <(DateTime, String, String, String, Color, Color)>[]; // date, icon, title, sub, bg, fg
    for (var i = 0; i < 60 && items.length < 7; i++) {
      final d = addDays(today, -i);
      if (d.isBefore(start)) break;
      final log = logs[dateKey(d)];
      if (habit.isBad) {
        if (log?.status == LogStatus.slipped) {
          items.add((d, 'undo', l.legendSlipped, log?.note ?? l.historySlipNote, c.badSoft, c.badText));
        } else if (i > 0) {
          items.add((d, 'check', l.historyClean, '', accent.soft, accent.text));
        }
        continue;
      }
      switch (log?.status) {
        case LogStatus.done:
          items.add((d, 'check', l.legendDone, l.historyLoggedAt(l.timeOf(log!.createdAt)), accent.soft, accent.text));
        case LogStatus.skipped:
          items.add((d, 'skip', l.legendSkipped, '', c.chip, c.sub));
        case LogStatus.slipped:
          break;
        case null:
          final due = habit.frequency == Frequency.daily || habit.weekdays.contains(d.weekday);
          if (i > 0 && due) items.add((d, 'minus', l.legendMissed, l.historyMissNote, c.chip, c.sub));
      }
    }
    if (items.isEmpty) {
      return AppCard(child: Text(l.noHistory, style: TextStyle(color: c.sub)));
    }
    return AppCard(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 2),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            _HistoryRow(item: items[i], last: i == items.length - 1, l: l),
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.item, required this.last, required this.l});
  final (DateTime, String, String, String, Color, Color) item;
  final bool last;
  final AppLocalizations l;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (d, icon, title, sub, bg, fg) = item;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(border: last ? null : Border(bottom: BorderSide(color: c.line))),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: AppIcon(icon, size: 16, color: fg, strokeWidth: 2.4),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                if (sub.isNotEmpty) Text(sub, style: TextStyle(fontSize: 13, color: c.sub)),
              ],
            ),
          ),
          Text(l.shortDate(d), style: TextStyle(fontSize: 13, color: c.sub)),
        ],
      ),
    );
  }
}
