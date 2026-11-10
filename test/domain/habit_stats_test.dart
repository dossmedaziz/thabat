import 'package:flutter_test/flutter_test.dart';
import 'package:thabat/core/utils/dates.dart';
import 'package:thabat/features/habits/domain/habit_stats.dart';
import 'package:thabat/features/habits/domain/models.dart';

Habit habit({
  HabitType type = HabitType.good,
  Frequency f = Frequency.daily,
  int target = 1,
  List<int> weekdays = const [],
  DateTime? created,
  HabitGoal? goal,
}) {
  final c = created ?? DateTime(2026, 11, 1);
  return Habit(
    id: 'h',
    type: type,
    name: 'Test',
    frequency: f,
    targetPerPeriod: target,
    weekdays: weekdays,
    goal: goal,
    createdAt: c,
    updatedAt: c,
  );
}

LogMap logs(Map<String, LogStatus> m) => {
      for (final e in m.entries)
        e.key: HabitLog(date: e.key, status: e.value, createdAt: parseDateKey(e.key).add(const Duration(hours: 9))),
    };

LogMap doneDays(DateTime from, int n, {Set<int> skip = const {}}) => {
      for (var i = 0; i < n; i++)
        if (!skip.contains(i))
          dateKey(addDays(from, i)): HabitLog(
            date: dateKey(addDays(from, i)),
            status: LogStatus.done,
            createdAt: addDays(from, i).add(const Duration(hours: 9)),
          ),
    };

void main() {
  const ws = WeekStart.monday;

  group('dates', () {
    test('dateKey round-trips', () {
      final d = DateTime(2026, 3, 9);
      expect(dateKey(d), '2026-03-09');
      expect(parseDateKey('2026-03-09'), d);
    });

    test('week start respects setting', () {
      final tue = DateTime(2026, 11, 10); // Tuesday
      expect(weekStartOf(tue, WeekStart.monday), DateTime(2026, 11, 9));
      expect(weekStartOf(tue, WeekStart.sunday), DateTime(2026, 11, 8));
      expect(weekStartOf(tue, WeekStart.saturday), DateTime(2026, 11, 7));
      expect(weekStartOf(DateTime(2026, 11, 7), WeekStart.saturday), DateTime(2026, 11, 7));
    });

    test('daysBetween ignores DST', () {
      expect(daysBetween(DateTime(2026, 3, 28), DateTime(2026, 3, 30)), 2);
      expect(daysBetween(DateTime(2026, 10, 24), DateTime(2026, 10, 26)), 2);
    });

    test('quiet window wraps midnight', () {
      expect(inQuietWindow('23:00', '22:00', '07:00'), isTrue);
      expect(inQuietWindow('06:59', '22:00', '07:00'), isTrue);
      expect(inQuietWindow('07:00', '22:00', '07:00'), isFalse);
      expect(inQuietWindow('12:00', '13:00', '14:00'), isFalse);
      expect(inQuietWindow('13:30', '13:00', '14:00'), isTrue);
    });
  });

  group('good daily streak', () {
    test('consecutive done days', () {
      final h = habit();
      final s = computeStats(h, doneDays(DateTime(2026, 11, 1), 10), DateTime(2026, 11, 10), ws);
      expect(s.currentStreak, 10);
      expect(s.bestStreak, 10);
      expect(s.doneToday, isTrue);
    });

    test('today not yet done does not break the streak', () {
      final h = habit();
      final s = computeStats(h, doneDays(DateTime(2026, 11, 1), 9), DateTime(2026, 11, 10), ws);
      expect(s.currentStreak, 9);
      expect(s.doneToday, isFalse);
    });

    test('a missed day resets the streak but keeps best', () {
      final h = habit();
      final l = doneDays(DateTime(2026, 11, 1), 10, skip: {3});
      final s = computeStats(h, l, DateTime(2026, 11, 10), ws);
      expect(s.currentStreak, 6);
      expect(s.bestStreak, 6);
      final l2 = doneDays(DateTime(2026, 11, 1), 10, skip: {7});
      expect(computeStats(h, l2, DateTime(2026, 11, 10), ws).bestStreak, 7);
    });

    test('skipped does not break and does not count', () {
      final h = habit();
      final l = doneDays(DateTime(2026, 11, 1), 10, skip: {4})
        ..['2026-11-05'] = HabitLog(date: '2026-11-05', status: LogStatus.skipped, createdAt: DateTime(2026, 11, 5));
      final s = computeStats(h, l, DateTime(2026, 11, 10), ws);
      expect(s.currentStreak, 9);
      expect(s.totalDone, 9);
      expect(s.successRate, 1.0);
    });

    test('yesterday missed → streak 0', () {
      final h = habit();
      final s = computeStats(h, doneDays(DateTime(2026, 11, 1), 8), DateTime(2026, 11, 10), ws);
      expect(s.currentStreak, 0);
      expect(s.bestStreak, 8);
    });

    test('success rate excludes the pending current day', () {
      final h = habit();
      final l = doneDays(DateTime(2026, 11, 1), 9, skip: {0, 1});
      final s = computeStats(h, l, DateTime(2026, 11, 10), ws);
      // 9 finished days, 7 done → 7/9
      expect(s.successRate, closeTo(7 / 9, 1e-9));
    });
  });

  group('good weekly streak', () {
    test('3 times per week, monday start', () {
      final h = habit(f: Frequency.weekly, target: 3, created: DateTime(2026, 10, 19));
      final l = logs({
        // week of Oct 19
        '2026-10-19': LogStatus.done, '2026-10-21': LogStatus.done, '2026-10-23': LogStatus.done,
        // week of Oct 26
        '2026-10-26': LogStatus.done, '2026-10-28': LogStatus.done, '2026-11-01': LogStatus.done,
        // week of Nov 2
        '2026-11-03': LogStatus.done, '2026-11-05': LogStatus.done, '2026-11-07': LogStatus.done,
        // current week Nov 9 — 1 done so far
        '2026-11-09': LogStatus.done,
      });
      final s = computeStats(h, l, DateTime(2026, 11, 10), ws);
      expect(s.currentStreak, 3);
      expect(s.doneThisPeriod, 1);
      expect(s.target, 3);
      expect(s.periodComplete, isFalse);
    });

    test('week boundary depends on weekStart', () {
      final h = habit(f: Frequency.weekly, target: 2, created: DateTime(2026, 11, 1));
      // Sun Nov 8 + Mon Nov 9
      final l = logs({'2026-11-08': LogStatus.done, '2026-11-09': LogStatus.done});
      final monday = computeStats(h, l, DateTime(2026, 11, 10), WeekStart.monday);
      final sunday = computeStats(h, l, DateTime(2026, 11, 10), WeekStart.sunday);
      expect(monday.doneThisPeriod, 1);
      expect(sunday.doneThisPeriod, 2);
      expect(sunday.currentStreak, 1);
    });

    test('incomplete past week breaks the streak', () {
      final h = habit(f: Frequency.weekly, target: 2, created: DateTime(2026, 10, 26));
      final l = logs({
        '2026-10-26': LogStatus.done, '2026-10-27': LogStatus.done,
        '2026-11-02': LogStatus.done, // only 1 of 2
        '2026-11-09': LogStatus.done, '2026-11-10': LogStatus.done,
      });
      final s = computeStats(h, l, DateTime(2026, 11, 10), ws);
      expect(s.currentStreak, 1);
      expect(s.bestStreak, 1);
    });

    test('specific weekdays use the number of days as target', () {
      final h = habit(f: Frequency.weekly, weekdays: [1, 3, 5]);
      expect(h.effectiveTarget, 3);
      expect(isDueOn(h, const {}, DateTime(2026, 11, 9), ws), isTrue); // Monday
      expect(isDueOn(h, const {}, DateTime(2026, 11, 10), ws), isFalse); // Tuesday
    });

    test('X-times weekly habit is not due once the week is complete', () {
      final h = habit(f: Frequency.weekly, target: 2, created: DateTime(2026, 11, 1));
      final l = logs({'2026-11-09': LogStatus.done, '2026-11-10': LogStatus.done});
      expect(isDueOn(h, l, DateTime(2026, 11, 10), ws), isTrue); // done today → still shown
      expect(isDueOn(h, l, DateTime(2026, 11, 11), ws), isFalse);
    });
  });

  group('good monthly streak', () {
    test('per calendar month', () {
      final h = habit(f: Frequency.monthly, target: 1, created: DateTime(2026, 8, 15));
      final l = logs({'2026-08-20': LogStatus.done, '2026-09-02': LogStatus.done, '2026-10-30': LogStatus.done});
      final s = computeStats(h, l, DateTime(2026, 11, 10), ws);
      expect(s.currentStreak, 3); // Nov pending
      expect(s.successRate, 1.0);
      final l2 = Map.of(l)..remove('2026-09-02');
      expect(computeStats(h, l2, DateTime(2026, 11, 10), ws).currentStreak, 1);
    });
  });

  group('bad habits', () {
    test('days clean since creation', () {
      final h = habit(type: HabitType.bad, created: DateTime(2026, 10, 18));
      final s = computeStats(h, const {}, DateTime(2026, 11, 10), ws);
      expect(s.daysClean, 23);
      expect(s.currentStreak, 23);
      expect(s.successRate, 1.0);
    });

    test('days clean since last slip, best clean kept', () {
      final h = habit(type: HabitType.bad, created: DateTime(2026, 9, 1));
      final l = logs({'2026-10-01': LogStatus.slipped, '2026-11-04': LogStatus.slipped});
      final s = computeStats(h, l, DateTime(2026, 11, 10), ws);
      expect(s.daysClean, 6);
      expect(s.bestClean, 34); // Oct 1 → Nov 4
      expect(s.lastSlip, DateTime(2026, 11, 4));
    });

    test('slipped today → 0 days clean', () {
      final h = habit(type: HabitType.bad, created: DateTime(2026, 11, 1));
      final s = computeStats(h, logs({'2026-11-10': LogStatus.slipped}), DateTime(2026, 11, 10), ws);
      expect(s.daysClean, 0);
      expect(s.slippedToday, isTrue);
      expect(s.bestClean, 9);
    });
  });

  group('goals', () {
    test('streak goal in days', () {
      final h = habit(goal: const HabitGoal(kind: GoalKind.streak, value: 30, unit: GoalUnit.days));
      final s = computeStats(h, doneDays(DateTime(2026, 11, 1), 10), DateTime(2026, 11, 10), ws);
      expect(s.goalCurrent, 10);
      expect(s.goalProgress, closeTo(1 / 3, 1e-9));
    });

    test('progress caps at 100%', () {
      final h = habit(goal: const HabitGoal(kind: GoalKind.total, value: 5, unit: GoalUnit.days));
      final s = computeStats(h, doneDays(DateTime(2026, 11, 1), 10), DateTime(2026, 11, 10), ws);
      expect(s.goalProgress, 1.0);
    });

    test('bad habit streak goal in weeks', () {
      final h = habit(
        type: HabitType.bad,
        created: DateTime(2026, 10, 18),
        goal: const HabitGoal(kind: GoalKind.streak, value: 4, unit: GoalUnit.weeks),
      );
      final s = computeStats(h, const {}, DateTime(2026, 11, 10), ws);
      expect(s.goalCurrent, 3); // 23 days → 3 full weeks
      expect(s.goalProgress, 0.75);
    });

    test('weekly habit streak goal in weeks', () {
      final h = habit(
        f: Frequency.weekly,
        target: 1,
        created: DateTime(2026, 10, 26),
        goal: const HabitGoal(kind: GoalKind.streak, value: 4, unit: GoalUnit.weeks),
      );
      final l = logs({'2026-10-27': LogStatus.done, '2026-11-03': LogStatus.done, '2026-11-10': LogStatus.done});
      expect(computeStats(h, l, DateTime(2026, 11, 10), ws).goalCurrent, 3);
    });

    test('no goal → null progress', () {
      expect(computeStats(habit(), const {}, DateTime(2026, 11, 10), ws).goalProgress, isNull);
    });
  });

  group('today progress ring', () {
    test('counts due good habits done + bad habits without slip', () {
      final good = habit().copyWith(id: 'g');
      final weekly = habit(f: Frequency.weekly, weekdays: [3]).copyWith(id: 'w'); // Wednesday only
      final bad = habit(type: HabitType.bad).copyWith(id: 'b');
      final bad2 = habit(type: HabitType.bad).copyWith(id: 'b2');
      final all = <String, LogMap>{
        'g': logs({'2026-11-10': LogStatus.done}),
        'b2': logs({'2026-11-10': LogStatus.slipped}),
      };
      final p = dayProgress([good, weekly, bad, bad2], all, DateTime(2026, 11, 10), ws);
      expect(p.total, 3);
      expect(p.done, 2);
      expect(p.goodTotal, 1);
      expect(p.badDone, 1);
    });
  });
}
