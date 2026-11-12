import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n_x.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/clock.dart';
import '../../../core/utils/dates.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common.dart';
import '../../habits/application/habits_controller.dart';
import '../../habits/domain/models.dart';
import '../../settings/application/settings_controller.dart';
import '../domain/progress_stats.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});
  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  HabitType? _filter;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    if (!ref.watch(appDataControllerProvider).hasValue) return const Scaffold(body: LoadingView());
    final habits = ref.watch(habitsProvider);
    final logs = ref.watch(allLogsProvider);
    final today = ref.watch(todayProvider);
    final ws = ref.watch(settingsControllerProvider).weekStart;
    final s = summarize(habits, logs, today, ws, only: _filter);
    final avoid = _filter == HabitType.bad;
    final acc = avoid ? c.bad : c.good;
    final accText = avoid ? c.badText : c.goodText;
    final accSoft = avoid ? (context.isDark ? const Color(0xFF5A3027) : const Color(0xFFF9CFC5)) : (context.isDark ? const Color(0xFF1C4A3F) : const Color(0xFFBFE9DC));
    final pct = s.completion30 == null ? '–' : '${(s.completion30! * 100).round()}';

    final cards = switch (_filter) {
      null => [
          (l.cardTotalHabits, '${s.habitCount}', '', l.noteSplit('${s.goodCount}', '${s.badCount}'), false),
          (l.cardLongestStreak, l.daysCount(s.longest), '', s.longestName ?? '', true),
          (l.cardDaysClean, '${s.cleanDays}', '', l.noteCurrentRuns, true),
          (l.cardCompletion, pct, '%', l.noteLast30, false),
        ],
      HabitType.good => [
          (l.cardGoodHabits, '${s.habitCount}', '', '', false),
          (l.cardLongestStreak, l.daysCount(s.longest), '', s.longestName ?? '', true),
          (l.cardCheckins, '${s.checkinsThisMonth}', '', l.noteThisMonth, true),
          (l.cardCompletion, pct, '%', l.noteLast30, false),
        ],
      HabitType.bad => [
          (l.cardBadHabits, '${s.habitCount}', '', '', false),
          (l.cardLongestClean, l.daysCount(s.longest), '', s.longestName ?? '', true),
          (l.cardDaysClean, '${s.cleanDays}', '', l.noteCurrentRuns, true),
          (l.cardCommitment, pct, '%', l.noteLast30, false),
        ],
    };

    final weekVals = s.week.where((e) => e.$2 != null).map((e) => e.$2!).toList();
    final weekAvg = weekVals.isEmpty ? 0 : (weekVals.reduce((a, b) => a + b) / weekVals.length * 100).round();
    final firstM = s.months.firstWhere((m) => m.$2 != null, orElse: () => s.months.first);
    final lastM = s.months.last;
    final delta = ((lastM.$2 ?? 0) - (firstM.$2 ?? 0)) * 100;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 32),
          children: [
            Text(l.tabProgress, style: context.text.title),
            const SizedBox(height: 14),
            Segmented<HabitType?>(
              value: _filter,
              semanticLabel: l.filterLabel,
              height: 42,
              items: [(null, l.filterAll, null), (HabitType.good, l.filterGood, null), (HabitType.bad, l.filterBad, null)],
              onChanged: (f) => setState(() => _filter = f),
            ),
            const SizedBox(height: 14),
            if (habits.isEmpty)
              AppCard(child: Text(l.noData, style: TextStyle(color: c.sub)))
            else ...[
              // Two cards per row; each row is as tall as its tallest card, so long
              // Arabic/French text or a large system font size never overflows.
              for (var i = 0; i < cards.length; i += 2) ...[
                if (i > 0) const SizedBox(height: 12),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final (j, (label, value, unit, note, accent)) in cards.sublist(i, i + 2).indexed) ...[
                        if (j > 0) const SizedBox(width: 12),
                        Expanded(
                          child: AppCard(
                            padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.sub)),
                                const SizedBox(height: 4),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text.rich(TextSpan(children: [
                                    TextSpan(text: value, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: accent ? accText : c.text)),
                                    TextSpan(text: unit, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: c.sub)),
                                  ])),
                                ),
                                const Spacer(),
                                Text(note, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, height: 1.4, color: c.sub)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 14),
              AppCard(
                padding: const EdgeInsetsDirectional.fromSTEB(18, 16, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(l.last7Days, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                        Text.rich(TextSpan(style: TextStyle(fontSize: 13, color: c.sub), children: [
                          TextSpan(text: '${l.average} '),
                          TextSpan(text: '$weekAvg%', style: TextStyle(fontWeight: FontWeight.w700, color: c.text)),
                        ])),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(height: 190, child: _WeekChart(week: s.week, today: today, acc: acc, accSoft: accSoft, accText: accText)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              AppCard(
                padding: const EdgeInsetsDirectional.fromSTEB(18, 16, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(l.monthlyCompletion, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                        if (firstM != lastM)
                          Text(l.trendPoints('${delta >= 0 ? '+' : '−'}${delta.abs().round()}', l.monthName(firstM.$1)),
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: accText)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    for (final (i, (m, v)) in s.months.indexed)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            SizedBox(width: 60, child: Text(l.monthShort(m), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.sub))),
                            Expanded(child: DirectionalBar(value: v ?? 0, color: i == 5 ? acc : accSoft, track: c.track, height: 14)),
                            SizedBox(
                              width: 44,
                              child: Text(v == null ? '–' : '${(v * 100).round()}%',
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(fontFamily: kLatinFont, fontSize: 13, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _WeekChart extends StatelessWidget {
  const _WeekChart({required this.week, required this.today, required this.acc, required this.accSoft, required this.accText});
  final List<(DateTime, double?)> week;
  final DateTime today;
  final Color acc, accSoft, accText;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    // Time flows with the reading direction: in Arabic, today is the leftmost bar.
    final data = rtl ? week.reversed.toList() : week;
    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        alignment: BarChartAlignment.spaceAround,
        barTouchData: const BarTouchData(enabled: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 50,
          getDrawingHorizontalLine: (_) => FlLine(color: c.line, strokeWidth: 1, dashArray: [4, 4]),
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              getTitlesWidget: (x, meta) {
                final v = data[x.toInt()].$2;
                final isToday = sameDay(data[x.toInt()].$1, today);
                return Text(v == null ? '' : '${(v * 100).round()}%',
                    style: TextStyle(fontFamily: kLatinFont, fontSize: 11, fontWeight: FontWeight.w700, color: isToday ? accText : c.sub));
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 26,
              getTitlesWidget: (x, meta) {
                final d = data[x.toInt()].$1;
                final isToday = sameDay(d, today);
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(isToday ? l.todayLabel : l.weekdayShort(d.weekday),
                      style: TextStyle(fontSize: 12, fontWeight: isToday ? FontWeight.w700 : FontWeight.w500, color: isToday ? c.text : c.sub)),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (final (i, (d, v)) in data.indexed)
            BarChartGroupData(x: i, barRods: [
              BarChartRodData(
                toY: ((v ?? 0) * 100).clamp(2, 100),
                width: 28,
                color: sameDay(d, today) ? accSoft : (v == null ? c.track : acc),
                borderRadius: BorderRadius.circular(8),
                borderSide: sameDay(d, today) ? BorderSide(color: acc, width: 2) : BorderSide.none,
              ),
            ]),
        ],
      ),
      duration: const Duration(milliseconds: 350),
    );
  }
}
