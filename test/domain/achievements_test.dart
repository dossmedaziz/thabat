import 'package:flutter_test/flutter_test.dart';
import 'package:thabat/core/utils/dates.dart';
import 'package:thabat/features/achievements/domain/achievements.dart';
import 'package:thabat/features/habits/domain/models.dart';

Habit h(String id, {HabitType type = HabitType.good, Frequency f = Frequency.daily, DateTime? created, HabitGoal? goal}) {
  final c = created ?? DateTime(2026, 9, 1);
  return Habit(id: id, type: type, name: id, frequency: f, goal: goal, createdAt: c, updatedAt: c);
}

LogMap done(DateTime from, int n, {int hour = 9}) => {
      for (var i = 0; i < n; i++)
        dateKey(addDays(from, i)): HabitLog(
          date: dateKey(addDays(from, i)),
          status: LogStatus.done,
          createdAt: addDays(from, i).add(Duration(hours: hour)),
        ),
    };

void main() {
  const ws = WeekStart.monday;
  final today = DateTime(2026, 11, 10);

  Map<String, AchievementProgress> eval(List<Habit> habits, AllLogs logs) =>
      evaluateAchievements(habits: habits, logs: logs, today: today, weekStart: ws);

  test('nothing unlocked without data', () {
    final r = eval([h('a', created: today)], {});
    expect(r.values.where((p) => p.unlocked), isEmpty);
  });

  test('first_step after one check-in', () {
    final r = eval([h('a', created: today)], {'a': done(today, 1)});
    expect(r[AchievementIds.firstStep]!.unlocked, isTrue);
    expect(r[AchievementIds.weekComplete]!.unlocked, isFalse);
  });

  test('week_complete and streak_30 from daily streaks', () {
    final r7 = eval([h('a')], {'a': done(addDays(today, -6), 7)});
    expect(r7[AchievementIds.weekComplete]!.unlocked, isTrue);
    expect(r7[AchievementIds.streak30]!.current, 7);
    final r30 = eval([h('a')], {'a': done(addDays(today, -29), 30)});
    expect(r30[AchievementIds.streak30]!.unlocked, isTrue);
  });

  test('clean_100 for a bad habit', () {
    final r = eval([h('b', type: HabitType.bad, created: addDays(today, -100))], {});
    expect(r[AchievementIds.clean100]!.unlocked, isTrue);
    expect(r[AchievementIds.clean21]!.unlocked, isTrue);
    final r2 = eval([h('b', type: HabitType.bad, created: addDays(today, -50))], {});
    expect(r2[AchievementIds.clean100]!.unlocked, isFalse);
    expect(r2[AchievementIds.clean100]!.current, 50);
  });

  test('perfect_week needs a full aligned week of all due habits', () {
    // Week Mon Nov 2 – Sun Nov 8 fully done for both habits.
    final logs = {'a': done(DateTime(2026, 11, 2), 7), 'b': done(DateTime(2026, 11, 2), 7)};
    expect(eval([h('a'), h('b')], logs)[AchievementIds.perfectWeek]!.unlocked, isTrue);
    final partial = {'a': done(DateTime(2026, 11, 2), 7), 'b': done(DateTime(2026, 11, 2), 6)};
    expect(eval([h('a'), h('b')], partial)[AchievementIds.perfectWeek]!.unlocked, isFalse);
  });

  test('comeback after a slip', () {
    final b = h('b', type: HabitType.bad);
    final logs = {
      'b': {
        '2026-11-01': HabitLog(date: '2026-11-01', status: LogStatus.slipped, createdAt: DateTime(2026, 11, 1)),
      },
    };
    expect(eval([b], logs)[AchievementIds.comeback]!.unlocked, isTrue); // 9 days after slip
  });

  test('early_bird counts check-ins before 8am', () {
    final r = eval([h('a')], {'a': done(addDays(today, -4), 5, hour: 7)});
    expect(r[AchievementIds.earlyBird]!.unlocked, isTrue);
  });

  test('goal_reached when any goal hits 100%', () {
    final g = h('a', goal: const HabitGoal(kind: GoalKind.streak, value: 3, unit: GoalUnit.days));
    expect(eval([g], {'a': done(addDays(today, -2), 3)})[AchievementIds.goalReached]!.unlocked, isTrue);
    expect(eval([g], {'a': done(addDays(today, -1), 2)})[AchievementIds.goalReached]!.unlocked, isFalse);
  });
}
