import 'dart:math' as math;

import '../../../core/utils/dates.dart';
import '../../habits/domain/habit_stats.dart';
import '../../habits/domain/models.dart';

/// All badge ids, in display order.
abstract final class AchievementIds {
  static const firstStep = 'first_step';
  static const weekComplete = 'week_complete';
  static const perfectWeek = 'perfect_week';
  static const clean21 = 'clean_21';
  static const comeback = 'comeback';
  static const earlyBird = 'early_bird';
  static const streak30 = 'streak_30';
  static const clean100 = 'clean_100';
  static const goalReached = 'goal_reached';

  static const all = [
    firstStep,
    weekComplete,
    perfectWeek,
    clean21,
    comeback,
    earlyBird,
    streak30,
    clean100,
    goalReached,
  ];
}

class AchievementProgress {
  const AchievementProgress(this.current, this.target, {this.habitName});
  final int current;
  final int target;

  /// Habit that earned / is closest to the badge, if any.
  final String? habitName;
  bool get unlocked => current >= target;
  double get ratio => target == 0 ? 0 : (current / target).clamp(0.0, 1.0);
}

/// Computes progress toward every badge from the full data set (pure, deterministic).
Map<String, AchievementProgress> evaluateAchievements({
  required List<Habit> habits,
  required AllLogs logs,
  required DateTime today,
  required WeekStart weekStart,
}) {
  today = dayOnly(today);
  var totalDone = 0;
  var bestDaily = 0;
  String? bestDailyName;
  var bestClean = 0;
  String? bestCleanName;
  var comeback = 0;
  String? comebackName;
  var early = 0;
  var goalHit = false;
  String? goalName;

  for (final h in habits) {
    final l = logs[h.id] ?? const <String, HabitLog>{};
    final s = computeStats(h, l, today, weekStart);
    if (h.isGood) {
      totalDone += s.totalDone;
      early += l.values.where((x) => x.status == LogStatus.done && x.createdAt.hour < 8).length;
      if (h.frequency == Frequency.daily && s.bestStreak > bestDaily) {
        bestDaily = s.bestStreak;
        bestDailyName = h.name;
      }
    } else {
      if (s.bestClean > bestClean) {
        bestClean = s.bestClean;
        bestCleanName = h.name;
      }
      if (s.lastSlip != null && s.daysClean > comeback) {
        comeback = s.daysClean;
        comebackName = h.name;
      }
    }
    if ((s.goalProgress ?? 0) >= 1) {
      goalHit = true;
      goalName ??= h.name;
    }
  }

  final perfect = hasPerfectWeek(habits, logs, today, weekStart);

  return {
    AchievementIds.firstStep: AchievementProgress(math.min(totalDone, 1), 1),
    AchievementIds.weekComplete: AchievementProgress(math.min(bestDaily, 7), 7, habitName: bestDailyName),
    AchievementIds.perfectWeek: AchievementProgress(perfect ? 1 : 0, 1),
    AchievementIds.clean21: AchievementProgress(math.min(bestClean, 21), 21, habitName: bestCleanName),
    AchievementIds.comeback: AchievementProgress(math.min(comeback, 7), 7, habitName: comebackName),
    AchievementIds.earlyBird: AchievementProgress(math.min(early, 5), 5),
    AchievementIds.streak30: AchievementProgress(math.min(bestDaily, 30), 30, habitName: bestDailyName),
    AchievementIds.clean100: AchievementProgress(math.min(bestClean, 100), 100, habitName: bestCleanName),
    AchievementIds.goalReached: AchievementProgress(goalHit ? 1 : 0, 1, habitName: goalName),
  };
}

/// A finished week (aligned to [ws]) in which every good habit due on each day was done,
/// and every "X times per week" habit reached its target.
bool hasPerfectWeek(List<Habit> habits, AllLogs logs, DateTime today, WeekStart ws) {
  final good = habits.where((h) => h.isGood && !h.archived && h.frequency != Frequency.monthly).toList();
  if (good.isEmpty) return false;
  var earliest = today;
  for (final h in good) {
    final s = habitStart(h, logs[h.id] ?? const {});
    if (s.isBefore(earliest)) earliest = s;
  }
  // A week counts once its last day is today or earlier.
  var weekStart = weekStartOf(earliest, ws);
  var guard = 0;
  while (!addDays(weekStart, 6).isAfter(today) && guard++ < 260) {
    if (_isPerfect(good, logs, weekStart, ws)) return true;
    weekStart = addDays(weekStart, 7);
  }
  return false;
}

bool _isPerfect(List<Habit> good, AllLogs logs, DateTime start, WeekStart ws) {
  var anyDue = false;
  for (final h in good) {
    final l = logs[h.id] ?? const <String, HabitLog>{};
    if (habitStart(h, l).isAfter(start)) continue; // habit didn't exist the whole week
    if (h.frequency == Frequency.weekly && h.weekdays.isEmpty) {
      var done = 0;
      for (var i = 0; i < 7; i++) {
        if (l[dateKey(addDays(start, i))]?.status == LogStatus.done) done++;
      }
      anyDue = true;
      if (done < h.effectiveTarget) return false;
      continue;
    }
    for (var i = 0; i < 7; i++) {
      final d = addDays(start, i);
      final due = h.frequency == Frequency.daily || h.weekdays.contains(d.weekday);
      if (!due) continue;
      anyDue = true;
      if (l[dateKey(d)]?.status != LogStatus.done) return false;
    }
  }
  return anyDue;
}
