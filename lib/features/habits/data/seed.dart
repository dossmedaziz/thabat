import 'package:uuid/uuid.dart';

import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/utils/dates.dart';
import '../domain/models.dart';

/// Sample habits with a realistic history, relative to [today].
({List<Habit> habits, AllLogs logs}) buildSampleData(AppLocalizations l, DateTime today, WeekStart ws) {
  today = dayOnly(today);
  final habits = <Habit>[];
  final logs = <String, LogMap>{};

  Habit make({
    required String key,
    required HabitType type,
    required String name,
    required String icon,
    required String color,
    required int ageDays,
    Frequency f = Frequency.daily,
    int target = 1,
    List<int> weekdays = const [],
    HabitGoal? goal,
    HabitReminder? reminder,
    String? note,
  }) {
    final created = addDays(today, -ageDays).add(const Duration(hours: 8));
    final h = Habit(
      id: const Uuid().v4(),
      type: type,
      name: name,
      emoji: 'icon:$icon',
      colorHex: color,
      note: note,
      frequency: f,
      targetPerPeriod: target,
      weekdays: weekdays,
      goal: goal,
      reminder: reminder,
      createdAt: created,
      updatedAt: created,
    );
    habits.add(h);
    logs[h.id] = {};
    return h;
  }

  void log(Habit h, int daysAgo, LogStatus s, {int hour = 21, int minute = 0, String? note}) {
    if (daysAgo < 0) return;
    final d = addDays(today, -daysAgo);
    if (d.isBefore(dayOnly(h.createdAt))) return;
    logs[h.id]![dateKey(d)] = HabitLog(
      date: dateKey(d),
      status: s,
      note: note,
      createdAt: d.add(Duration(hours: hour, minutes: minute)),
    );
  }

  const good = '#14A383', blue = '#3B7BE8', purple = '#8B5CF6', amber = '#E8A317', coral = '#F0715A', pink = '#E55A96';

  // ---- Good habits ----
  final water = make(
    key: 'water', type: HabitType.good, name: l.seedWater, icon: 'water', color: blue, ageDays: 45,
    goal: const HabitGoal(kind: GoalKind.streak, value: 30, unit: GoalUnit.days),
    reminder: HabitReminder(enabled: true, time: '09:00', message: l.seedWaterMsg),
  );
  for (var i = 0; i <= 45; i++) {
    if (i == 12 || (i > 12 && i % 6 == 2)) continue; // a few misses before the current run
    log(water, i, LogStatus.done, hour: i < 6 ? 7 : 9, minute: 30);
  }

  final read = make(
    key: 'read', type: HabitType.good, name: l.seedRead, icon: 'read', color: good, ageDays: 50,
    goal: const HabitGoal(kind: GoalKind.streak, value: 30, unit: GoalUnit.days),
    reminder: HabitReminder(enabled: true, time: '21:30', message: l.seedReadMsg),
    note: l.seedReadNote,
  );
  for (var i = 1; i <= 50; i++) {
    if (i == 6 || i == 13 || i == 27) continue; // missed
    if (i == 9 || i == 20) {
      log(read, i, LogStatus.skipped);
      continue;
    }
    log(read, i, LogStatus.done, hour: 21, minute: (i * 7) % 60);
  }

  final gym = make(
    key: 'gym', type: HabitType.good, name: l.seedGym, icon: 'gym', color: purple, ageDays: 42,
    f: Frequency.weekly, target: 3,
    goal: const HabitGoal(kind: GoalKind.streak, value: 12, unit: GoalUnit.weeks),
    reminder: HabitReminder(enabled: true, time: '18:30', weekdays: const [6, 1, 3], message: l.seedGymMsg),
  );
  final thisWeek = weekStartOf(today, ws);
  for (var w = 1; w <= 6; w++) {
    final start = addDays(thisWeek, -7 * w);
    final offsets = w == 5 ? const [0, 3] : const [0, 2, 4]; // one incomplete week long ago
    for (final o in offsets) {
      log(gym, daysBetween(addDays(start, o), today), LogStatus.done, hour: 18, minute: 45);
    }
  }
  for (final o in const [0, 2]) {
    final d = addDays(thisWeek, o);
    if (d.isBefore(today)) log(gym, daysBetween(d, today), LogStatus.done, hour: 18, minute: 45);
  }

  final family = make(
    key: 'family', type: HabitType.good, name: l.seedFamily, icon: 'family', color: amber, ageDays: 100,
    f: Frequency.monthly, target: 1,
    goal: const HabitGoal(kind: GoalKind.streak, value: 6, unit: GoalUnit.months),
    reminder: const HabitReminder(enabled: true, time: '11:00', weekdays: [5]),
  );
  for (var m = 0; m <= 3; m++) {
    final d = DateTime(today.year, today.month - m, 3);
    if (!d.isAfter(today)) log(family, daysBetween(d, today), LogStatus.done, hour: 17);
  }

  // ---- Bad habits ----
  final smoke = make(
    key: 'smoke', type: HabitType.bad, name: l.seedSmoke, icon: 'smoke', color: coral, ageDays: 60,
    goal: const HabitGoal(kind: GoalKind.streak, value: 3, unit: GoalUnit.months),
    reminder: const HabitReminder(enabled: true, time: '08:00'),
  );
  log(smoke, 23, LogStatus.slipped, hour: 22);
  log(smoke, 41, LogStatus.slipped, hour: 20);

  final social = make(
    key: 'social', type: HabitType.bad, name: l.seedSocial, icon: 'social', color: pink, ageDays: 40,
    goal: const HabitGoal(kind: GoalKind.streak, value: 30, unit: GoalUnit.days),
    reminder: HabitReminder(enabled: false, time: '22:00', message: l.seedSocialMsg),
  );
  log(social, 6, LogStatus.slipped, hour: 23);
  log(social, 26, LogStatus.slipped, hour: 23);

  final food = make(
    key: 'food', type: HabitType.bad, name: l.seedFastFood, icon: 'food', color: amber, ageDays: 30,
    f: Frequency.weekly,
    reminder: const HabitReminder(enabled: true, time: '19:30', weekdays: [4, 5]),
  );
  log(food, 9, LogStatus.slipped, hour: 20);

  make(
    key: 'soda', type: HabitType.bad, name: l.seedSoda, icon: 'soda', color: coral, ageDays: 12,
    goal: const HabitGoal(kind: GoalKind.streak, value: 30, unit: GoalUnit.days),
    reminder: const HabitReminder(enabled: true, time: '08:00'),
  );

  return (habits: habits, logs: logs);
}
