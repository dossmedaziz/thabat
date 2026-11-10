import '../../../core/utils/dates.dart';
import '../../habits/domain/habit_stats.dart';
import '../../habits/domain/models.dart';

/// Completion ratio (0..1) of habits due on [day], or null when nothing was due.
double? dayRatio(List<Habit> habits, AllLogs logs, DateTime day, WeekStart ws, {HabitType? only}) {
  final p = dayProgress(habits, logs, day, ws, only: only);
  return p.total == 0 ? null : p.ratio;
}

/// Average daily ratio over [from]..[to] (inclusive), ignoring days with nothing due.
double? averageRatio(List<Habit> habits, AllLogs logs, DateTime from, DateTime to, WeekStart ws, {HabitType? only}) {
  var sum = 0.0, n = 0;
  for (var d = dayOnly(from); !d.isAfter(to); d = addDays(d, 1)) {
    final r = dayRatio(habits, logs, d, ws, only: only);
    if (r != null) {
      sum += r;
      n++;
    }
  }
  return n == 0 ? null : sum / n;
}

class ProgressSummary {
  ProgressSummary({
    required this.week,
    required this.months,
    required this.habitCount,
    required this.goodCount,
    required this.badCount,
    required this.longest,
    required this.longestName,
    required this.cleanDays,
    required this.checkinsThisMonth,
    required this.completion30,
  });

  /// Last 7 days, oldest first. Null = nothing due.
  final List<(DateTime, double?)> week;

  /// Last 6 months, oldest first.
  final List<(DateTime, double?)> months;
  final int habitCount, goodCount, badCount;
  final int longest;
  final String? longestName;
  final int cleanDays;
  final int checkinsThisMonth;
  final double? completion30;
}

ProgressSummary summarize(List<Habit> all, AllLogs logs, DateTime today, WeekStart ws, {HabitType? only}) {
  today = dayOnly(today);
  final habits = only == null ? all : all.where((h) => h.type == only).toList();
  final week = [
    for (var i = 6; i >= 0; i--) (addDays(today, -i), dayRatio(habits, logs, addDays(today, -i), ws)),
  ];
  final months = <(DateTime, double?)>[];
  for (var i = 5; i >= 0; i--) {
    final m = DateTime(today.year, today.month - i, 1);
    final end = DateTime(m.year, m.month + 1, 0);
    months.add((m, averageRatio(habits, logs, m, end.isAfter(today) ? today : end, ws)));
  }
  var longest = 0;
  String? longestName;
  var clean = 0;
  var checkins = 0;
  final monthStart = DateTime(today.year, today.month, 1);
  for (final h in habits) {
    final l = logs[h.id] ?? const <String, HabitLog>{};
    final s = computeStats(h, l, today, ws);
    final days = h.isBad ? s.daysClean : (h.frequency == Frequency.daily ? s.currentStreak : 0);
    if (days > longest) {
      longest = days;
      longestName = h.name;
    }
    if (h.isBad) clean += s.daysClean;
    if (h.isGood) {
      checkins += l.values.where((x) => x.status == LogStatus.done && !parseDateKey(x.date).isBefore(monthStart)).length;
    }
  }
  return ProgressSummary(
    week: week,
    months: months,
    habitCount: habits.length,
    goodCount: habits.where((h) => h.isGood).length,
    badCount: habits.where((h) => h.isBad).length,
    longest: longest,
    longestName: longestName,
    cleanDays: clean,
    checkinsThisMonth: checkins,
    completion30: averageRatio(habits, logs, addDays(today, -29), today, ws),
  );
}
