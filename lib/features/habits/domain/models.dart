import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

enum HabitType { good, bad }

enum Frequency { daily, weekly, monthly }

enum GoalKind { streak, total }

enum GoalUnit { days, weeks, months }

enum LogStatus { done, skipped, slipped }

/// First day of the week. ISO weekday numbers: Monday = 1 … Sunday = 7.
enum WeekStart {
  monday(DateTime.monday),
  saturday(DateTime.saturday),
  sunday(DateTime.sunday);

  const WeekStart(this.isoWeekday);
  final int isoWeekday;

  static WeekStart fromName(String? name) =>
      WeekStart.values.firstWhere((w) => w.name == name, orElse: () => WeekStart.monday);
}

@freezed
abstract class HabitGoal with _$HabitGoal {
  const factory HabitGoal({
    required GoalKind kind,
    required int value,
    required GoalUnit unit,
  }) = _HabitGoal;

  factory HabitGoal.fromJson(Map<String, dynamic> json) => _$HabitGoalFromJson(json);
}

@freezed
abstract class HabitReminder with _$HabitReminder {
  const factory HabitReminder({
    @Default(false) bool enabled,

    /// "HH:mm", 24h.
    @Default('09:00') String time,

    /// ISO weekdays (1 = Monday … 7 = Sunday). Empty = every day.
    @Default(<int>[]) List<int> weekdays,
    String? message,
  }) = _HabitReminder;

  factory HabitReminder.fromJson(Map<String, dynamic> json) => _$HabitReminderFromJson(json);
}

@freezed
abstract class Habit with _$Habit {
  const Habit._();

  const factory Habit({
    required String id,
    required HabitType type,
    required String name,

    /// Either an emoji ("💧") or a line-icon key prefixed with "icon:" ("icon:water").
    @Default('icon:star') String emoji,
    @Default('#14A383') String colorHex,
    String? note,
    @Default(Frequency.daily) Frequency frequency,
    @Default(1) int targetPerPeriod,

    /// ISO weekdays for weekly habits on specific days. Empty = "X times per week".
    @Default(<int>[]) List<int> weekdays,
    HabitGoal? goal,
    HabitReminder? reminder,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool archived,
  }) = _Habit;

  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

  bool get isGood => type == HabitType.good;
  bool get isBad => type == HabitType.bad;

  /// Done-count needed for a period to count as complete.
  int get effectiveTarget {
    switch (frequency) {
      case Frequency.daily:
        return 1;
      case Frequency.weekly:
        return weekdays.isNotEmpty ? weekdays.length : targetPerPeriod.clamp(1, 7);
      case Frequency.monthly:
        return targetPerPeriod.clamp(1, 31);
    }
  }
}

@freezed
abstract class HabitLog with _$HabitLog {
  const factory HabitLog({
    /// yyyy-MM-dd, also the Firestore document id.
    required String date,
    required LogStatus status,
    @Default(1) int count,
    String? note,
    required DateTime createdAt,
  }) = _HabitLog;

  factory HabitLog.fromJson(Map<String, dynamic> json) => _$HabitLogFromJson(json);
}

/// Logs of one habit keyed by yyyy-MM-dd.
typedef LogMap = Map<String, HabitLog>;

/// Logs of all habits keyed by habit id.
typedef AllLogs = Map<String, LogMap>;
