// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HabitGoal _$HabitGoalFromJson(Map<String, dynamic> json) => _HabitGoal(
  kind: $enumDecode(_$GoalKindEnumMap, json['kind']),
  value: (json['value'] as num).toInt(),
  unit: $enumDecode(_$GoalUnitEnumMap, json['unit']),
);

Map<String, dynamic> _$HabitGoalToJson(_HabitGoal instance) =>
    <String, dynamic>{
      'kind': _$GoalKindEnumMap[instance.kind]!,
      'value': instance.value,
      'unit': _$GoalUnitEnumMap[instance.unit]!,
    };

const _$GoalKindEnumMap = {GoalKind.streak: 'streak', GoalKind.total: 'total'};

const _$GoalUnitEnumMap = {
  GoalUnit.days: 'days',
  GoalUnit.weeks: 'weeks',
  GoalUnit.months: 'months',
};

_HabitReminder _$HabitReminderFromJson(Map<String, dynamic> json) =>
    _HabitReminder(
      enabled: json['enabled'] as bool? ?? false,
      time: json['time'] as String? ?? '09:00',
      weekdays:
          (json['weekdays'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const <int>[],
      message: json['message'] as String?,
    );

Map<String, dynamic> _$HabitReminderToJson(_HabitReminder instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'time': instance.time,
      'weekdays': instance.weekdays,
      'message': ?instance.message,
    };

_Habit _$HabitFromJson(Map<String, dynamic> json) => _Habit(
  id: json['id'] as String,
  type: $enumDecode(_$HabitTypeEnumMap, json['type']),
  name: json['name'] as String,
  emoji: json['emoji'] as String? ?? 'icon:star',
  colorHex: json['colorHex'] as String? ?? '#14A383',
  note: json['note'] as String?,
  frequency:
      $enumDecodeNullable(_$FrequencyEnumMap, json['frequency']) ??
      Frequency.daily,
  targetPerPeriod: (json['targetPerPeriod'] as num?)?.toInt() ?? 1,
  weekdays:
      (json['weekdays'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  goal: json['goal'] == null
      ? null
      : HabitGoal.fromJson(json['goal'] as Map<String, dynamic>),
  reminder: json['reminder'] == null
      ? null
      : HabitReminder.fromJson(json['reminder'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  archived: json['archived'] as bool? ?? false,
);

Map<String, dynamic> _$HabitToJson(_Habit instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$HabitTypeEnumMap[instance.type]!,
  'name': instance.name,
  'emoji': instance.emoji,
  'colorHex': instance.colorHex,
  'note': ?instance.note,
  'frequency': _$FrequencyEnumMap[instance.frequency]!,
  'targetPerPeriod': instance.targetPerPeriod,
  'weekdays': instance.weekdays,
  'goal': ?instance.goal?.toJson(),
  'reminder': ?instance.reminder?.toJson(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'archived': instance.archived,
};

const _$HabitTypeEnumMap = {HabitType.good: 'good', HabitType.bad: 'bad'};

const _$FrequencyEnumMap = {
  Frequency.daily: 'daily',
  Frequency.weekly: 'weekly',
  Frequency.monthly: 'monthly',
};

_HabitLog _$HabitLogFromJson(Map<String, dynamic> json) => _HabitLog(
  date: json['date'] as String,
  status: $enumDecode(_$LogStatusEnumMap, json['status']),
  count: (json['count'] as num?)?.toInt() ?? 1,
  note: json['note'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$HabitLogToJson(_HabitLog instance) => <String, dynamic>{
  'date': instance.date,
  'status': _$LogStatusEnumMap[instance.status]!,
  'count': instance.count,
  'note': ?instance.note,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$LogStatusEnumMap = {
  LogStatus.done: 'done',
  LogStatus.skipped: 'skipped',
  LogStatus.slipped: 'slipped',
};
