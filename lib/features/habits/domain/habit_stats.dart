import 'dart:math' as math;

import '../../../core/utils/dates.dart';
import 'models.dart';

enum PeriodState { complete, excused, missed, pending }

class PeriodSummary {
  PeriodSummary(this.start, this.done, this.skipped, this.slipped, this.state);
  final DateTime start;
  final int done;
  final int skipped;
  final int slipped;
  final PeriodState state;
}

class HabitStats {
  const HabitStats({
    required this.currentStreak,
    required this.bestStreak,
    required this.successRate,
    required this.totalDone,
    required this.completedPeriods,
    required this.doneThisPeriod,
    required this.target,
    required this.todayStatus,
    required this.daysClean,
    required this.bestClean,
    required this.totalCleanDays,
    required this.goalCurrent,
    required this.goalProgress,
    required this.lastSlip,
  });

  /// Good: consecutive complete periods. Bad: days clean.
  final int currentStreak;

  /// Good: best run of complete periods. Bad: best clean run in days.
  final int bestStreak;

  /// 0..1
  final double successRate;

  /// Number of "done" check-ins (good habits).
  final int totalDone;
  final int completedPeriods;
  final int doneThisPeriod;
  final int target;
  final LogStatus? todayStatus;
  final int daysClean;
  final int bestClean;
  final int totalCleanDays;
  final int goalCurrent;

  /// 0..1, null when the habit has no goal.
  final double? goalProgress;
  final DateTime? lastSlip;

  bool get doneToday => todayStatus == LogStatus.done;
  bool get slippedToday => todayStatus == LogStatus.slipped;
  bool get skippedToday => todayStatus == LogStatus.skipped;
  bool get periodComplete => doneThisPeriod >= target;
}

/// Effective start date: creation date, or the earliest log if older (seeded/imported data).
DateTime habitStart(Habit h, LogMap logs) {
  var start = dayOnly(h.createdAt);
  for (final k in logs.keys) {
    final d = parseDateKey(k);
    if (d.isBefore(start)) start = d;
  }
  return start;
}

/// Splits the habit's lifetime into periods (by its frequency) up to [today].
List<PeriodSummary> summarizePeriods(Habit h, LogMap logs, DateTime today, WeekStart ws) {
  today = dayOnly(today);
  final start = habitStart(h, logs);
  if (start.isAfter(today)) return const [];
  final f = h.frequency;
  final buckets = <String, List<int>>{}; // key → [done, skipped, slipped]
  for (final log in logs.values) {
    final d = parseDateKey(log.date);
    if (d.isAfter(today)) continue;
    final key = dateKey(periodStart(d, f, ws));
    final b = buckets.putIfAbsent(key, () => [0, 0, 0]);
    switch (log.status) {
      case LogStatus.done:
        b[0] += math.max(1, log.count);
      case LogStatus.skipped:
        b[1] += 1;
      case LogStatus.slipped:
        b[2] += 1;
    }
  }
  final target = h.effectiveTarget;
  final current = periodStart(today, f, ws);
  final out = <PeriodSummary>[];
  for (var p = periodStart(start, f, ws); !p.isAfter(current); p = nextPeriodStart(p, f)) {
    final b = buckets[dateKey(p)] ?? const [0, 0, 0];
    final isCurrent = sameDay(p, current);
    PeriodState state;
    if (h.isGood) {
      if (b[0] >= target) {
        state = PeriodState.complete;
      } else if (isCurrent) {
        state = PeriodState.pending;
      } else if (b[0] + b[1] >= target) {
        state = PeriodState.excused;
      } else {
        state = PeriodState.missed;
      }
    } else {
      state = b[2] > 0 ? PeriodState.missed : PeriodState.complete;
    }
    out.add(PeriodSummary(p, b[0], b[1], b[2], state));
  }
  return out;
}

int _periodDays(Frequency f) => switch (f) {
      Frequency.daily => 1,
      Frequency.weekly => 7,
      Frequency.monthly => 30,
    };

int _unitDays(GoalUnit u) => switch (u) {
      GoalUnit.days => 1,
      GoalUnit.weeks => 7,
      GoalUnit.months => 30,
    };

HabitStats computeStats(Habit h, LogMap logs, DateTime today, WeekStart ws) {
  today = dayOnly(today);
  final periods = summarizePeriods(h, logs, today, ws);
  final todayLog = logs[dateKey(today)];
  final target = h.effectiveTarget;

  final totalDone = logs.values
      .where((l) => l.status == LogStatus.done && !parseDateKey(l.date).isAfter(today))
      .length;

  // ---- Good-habit streaks ----
  var current = 0;
  for (var i = periods.length - 1; i >= 0; i--) {
    final s = periods[i].state;
    if (s == PeriodState.complete) {
      current++;
    } else if (s == PeriodState.excused || s == PeriodState.pending) {
      continue;
    } else {
      break;
    }
  }
  var best = 0, run = 0;
  for (final p in periods) {
    if (p.state == PeriodState.complete) {
      run++;
      best = math.max(best, run);
    } else if (p.state == PeriodState.missed) {
      run = 0;
    }
  }
  final completed = periods.where((p) => p.state == PeriodState.complete).length;
  final counted = periods
      .where((p) => p.state == PeriodState.complete || p.state == PeriodState.missed)
      .length;
  final successRate = counted == 0 ? 0.0 : completed / counted;
  final doneThisPeriod = periods.isEmpty ? 0 : periods.last.done;

  // ---- Bad-habit clean days ----
  final start = habitStart(h, logs);
  final slips = logs.values
      .where((l) => l.status == LogStatus.slipped)
      .map((l) => parseDateKey(l.date))
      .where((d) => !d.isAfter(today))
      .toList()
    ..sort();
  final lastSlip = slips.isEmpty ? null : slips.last;
  final daysClean = start.isAfter(today) ? 0 : daysBetween(lastSlip ?? start, today);
  var bestClean = daysClean;
  var prev = start;
  for (final s in slips) {
    bestClean = math.max(bestClean, daysBetween(prev, s));
    prev = s;
  }
  final totalDays = start.isAfter(today) ? 0 : daysBetween(start, today) + 1;
  final slipDays = slips.map(dateKey).toSet().length;
  final totalCleanDays = math.max(0, totalDays - slipDays);

  // ---- Goal ----
  int goalCurrent = 0;
  double? goalProgress;
  final goal = h.goal;
  if (goal != null && goal.value > 0) {
    final unitDays = _unitDays(goal.unit);
    if (h.isGood) {
      if (goal.kind == GoalKind.streak) {
        goalCurrent = (current * _periodDays(h.frequency)) ~/ unitDays;
      } else {
        goalCurrent = goal.unit == GoalUnit.days && h.frequency != Frequency.daily
            ? totalDone
            : (completed * _periodDays(h.frequency)) ~/ unitDays;
      }
    } else {
      goalCurrent = (goal.kind == GoalKind.streak ? daysClean : totalCleanDays) ~/ unitDays;
    }
    goalProgress = (goalCurrent / goal.value).clamp(0.0, 1.0);
  }

  return HabitStats(
    currentStreak: h.isGood ? current : daysClean,
    bestStreak: h.isGood ? best : bestClean,
    successRate: successRate,
    totalDone: totalDone,
    completedPeriods: completed,
    doneThisPeriod: doneThisPeriod,
    target: target,
    todayStatus: todayLog?.status,
    daysClean: daysClean,
    bestClean: bestClean,
    totalCleanDays: totalCleanDays,
    goalCurrent: goalCurrent,
    goalProgress: goalProgress,
    lastSlip: lastSlip,
  );
}

/// Whether the habit should appear as "due" on [day].
bool isDueOn(Habit h, LogMap logs, DateTime day, WeekStart ws) {
  day = dayOnly(day);
  if (h.archived) return false;
  if (dayOnly(h.createdAt).isAfter(day) && logs.isEmpty) return false;
  if (h.isBad) return true;
  switch (h.frequency) {
    case Frequency.daily:
      return true;
    case Frequency.weekly:
      if (h.weekdays.isNotEmpty) return h.weekdays.contains(day.weekday);
      return _periodOpenOrDoneOn(h, logs, day, ws);
    case Frequency.monthly:
      return _periodOpenOrDoneOn(h, logs, day, ws);
  }
}

bool _periodOpenOrDoneOn(Habit h, LogMap logs, DateTime day, WeekStart ws) {
  if (logs[dateKey(day)]?.status == LogStatus.done) return true;
  final start = periodStart(day, h.frequency, ws);
  final end = nextPeriodStart(start, h.frequency);
  var done = 0;
  for (var d = start; d.isBefore(end) && !d.isAfter(day); d = addDays(d, 1)) {
    if (logs[dateKey(d)]?.status == LogStatus.done) done++;
  }
  return done < h.effectiveTarget;
}

/// Counts as "done" for the daily ring: good = checked in, bad = no slip.
bool isDoneOn(Habit h, LogMap logs, DateTime day) {
  final st = logs[dateKey(day)]?.status;
  return h.isGood ? st == LogStatus.done : st != LogStatus.slipped;
}

class DayProgress {
  const DayProgress(this.done, this.total, {this.goodDone = 0, this.goodTotal = 0, this.badDone = 0, this.badTotal = 0});
  final int done;
  final int total;
  final int goodDone, goodTotal, badDone, badTotal;
  double get ratio => total == 0 ? 0 : done / total;
}

DayProgress dayProgress(List<Habit> habits, AllLogs all, DateTime day, WeekStart ws,
    {HabitType? only}) {
  var gd = 0, gt = 0, bd = 0, bt = 0;
  for (final h in habits) {
    if (only != null && h.type != only) continue;
    final logs = all[h.id] ?? const {};
    if (habitStart(h, logs).isAfter(dayOnly(day))) continue;
    if (!isDueOn(h, logs, day, ws)) continue;
    final ok = isDoneOn(h, logs, day);
    if (h.isGood) {
      gt++;
      if (ok) gd++;
    } else {
      bt++;
      if (ok) bd++;
    }
  }
  return DayProgress(gd + bd, gt + bt, goodDone: gd, goodTotal: gt, badDone: bd, badTotal: bt);
}
