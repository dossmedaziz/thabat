// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HabitGoal {

 GoalKind get kind; int get value; GoalUnit get unit;
/// Create a copy of HabitGoal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitGoalCopyWith<HabitGoal> get copyWith => _$HabitGoalCopyWithImpl<HabitGoal>(this as HabitGoal, _$identity);

  /// Serializes this HabitGoal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HabitGoal;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitGoal&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.value, _this.value) || other.value == _this.value)&&(identical(other.unit, _this.unit) || other.unit == _this.unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HabitGoal;
  return Object.hash(runtimeType,_this.kind,_this.value,_this.unit);
}

@override
String toString() {
  final _this = this as HabitGoal;
  return 'HabitGoal(kind: ${_this.kind}, value: ${_this.value}, unit: ${_this.unit})';
}


}

/// @nodoc
abstract mixin class $HabitGoalCopyWith<$Res>  {
  factory $HabitGoalCopyWith(HabitGoal value, $Res Function(HabitGoal) _then) = _$HabitGoalCopyWithImpl;
@useResult
$Res call({
 GoalKind kind, int value, GoalUnit unit
});




}
/// @nodoc
class _$HabitGoalCopyWithImpl<$Res>
    implements $HabitGoalCopyWith<$Res> {
  _$HabitGoalCopyWithImpl(this._self, this._then);

  final HabitGoal _self;
  final $Res Function(HabitGoal) _then;

/// Create a copy of HabitGoal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? value = null,Object? unit = null,}) {
  return _then(HabitGoal(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as GoalKind,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as GoalUnit,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitGoal].
extension HabitGoalPatterns on HabitGoal {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitGoal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitGoal() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitGoal value)  $default,){
final _that = this;
switch (_that) {
case _HabitGoal():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitGoal value)?  $default,){
final _that = this;
switch (_that) {
case _HabitGoal() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GoalKind kind,  int value,  GoalUnit unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitGoal() when $default != null:
return $default(_that.kind,_that.value,_that.unit);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GoalKind kind,  int value,  GoalUnit unit)  $default,) {final _that = this;
switch (_that) {
case _HabitGoal():
return $default(_that.kind,_that.value,_that.unit);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GoalKind kind,  int value,  GoalUnit unit)?  $default,) {final _that = this;
switch (_that) {
case _HabitGoal() when $default != null:
return $default(_that.kind,_that.value,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitGoal implements HabitGoal {
  const _HabitGoal({required this.kind, required this.value, required this.unit});
  factory _HabitGoal.fromJson(Map<String, dynamic> json) => _$HabitGoalFromJson(json);

@override final  GoalKind kind;
@override final  int value;
@override final  GoalUnit unit;

/// Create a copy of HabitGoal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitGoalCopyWith<_HabitGoal> get copyWith => __$HabitGoalCopyWithImpl<_HabitGoal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitGoalToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitGoal&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.value, value) || other.value == value)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,value,unit);
}

@override
String toString() {
    return 'HabitGoal(kind: $kind, value: $value, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$HabitGoalCopyWith<$Res> implements $HabitGoalCopyWith<$Res> {
  factory _$HabitGoalCopyWith(_HabitGoal value, $Res Function(_HabitGoal) _then) = __$HabitGoalCopyWithImpl;
@override @useResult
$Res call({
 GoalKind kind, int value, GoalUnit unit
});




}
/// @nodoc
class __$HabitGoalCopyWithImpl<$Res>
    implements _$HabitGoalCopyWith<$Res> {
  __$HabitGoalCopyWithImpl(this._self, this._then);

  final _HabitGoal _self;
  final $Res Function(_HabitGoal) _then;

/// Create a copy of HabitGoal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? value = null,Object? unit = null,}) {
  return _then(_HabitGoal(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as GoalKind,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as GoalUnit,
  ));
}


}


/// @nodoc
mixin _$HabitReminder {

 bool get enabled;/// "HH:mm", 24h.
 String get time;/// ISO weekdays (1 = Monday … 7 = Sunday). Empty = every day.
 List<int> get weekdays; String? get message;
/// Create a copy of HabitReminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitReminderCopyWith<HabitReminder> get copyWith => _$HabitReminderCopyWithImpl<HabitReminder>(this as HabitReminder, _$identity);

  /// Serializes this HabitReminder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HabitReminder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitReminder&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.time, _this.time) || other.time == _this.time)&&const DeepCollectionEquality().equals(other.weekdays, _this.weekdays)&&(identical(other.message, _this.message) || other.message == _this.message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HabitReminder;
  return Object.hash(runtimeType,_this.enabled,_this.time,const DeepCollectionEquality().hash(_this.weekdays),_this.message);
}

@override
String toString() {
  final _this = this as HabitReminder;
  return 'HabitReminder(enabled: ${_this.enabled}, time: ${_this.time}, weekdays: ${_this.weekdays}, message: ${_this.message})';
}


}

/// @nodoc
abstract mixin class $HabitReminderCopyWith<$Res>  {
  factory $HabitReminderCopyWith(HabitReminder value, $Res Function(HabitReminder) _then) = _$HabitReminderCopyWithImpl;
@useResult
$Res call({
 bool enabled, String time, List<int> weekdays, String? message
});




}
/// @nodoc
class _$HabitReminderCopyWithImpl<$Res>
    implements $HabitReminderCopyWith<$Res> {
  _$HabitReminderCopyWithImpl(this._self, this._then);

  final HabitReminder _self;
  final $Res Function(HabitReminder) _then;

/// Create a copy of HabitReminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? time = null,Object? weekdays = null,Object? message = freezed,}) {
  return _then(HabitReminder(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,weekdays: null == weekdays ? _self.weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitReminder].
extension HabitReminderPatterns on HabitReminder {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitReminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitReminder() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitReminder value)  $default,){
final _that = this;
switch (_that) {
case _HabitReminder():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitReminder value)?  $default,){
final _that = this;
switch (_that) {
case _HabitReminder() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  String time,  List<int> weekdays,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitReminder() when $default != null:
return $default(_that.enabled,_that.time,_that.weekdays,_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  String time,  List<int> weekdays,  String? message)  $default,) {final _that = this;
switch (_that) {
case _HabitReminder():
return $default(_that.enabled,_that.time,_that.weekdays,_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  String time,  List<int> weekdays,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _HabitReminder() when $default != null:
return $default(_that.enabled,_that.time,_that.weekdays,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitReminder implements HabitReminder {
  const _HabitReminder({this.enabled = false, this.time = '09:00',  List<int> weekdays = const <int>[], this.message}): _weekdays = weekdays;
  factory _HabitReminder.fromJson(Map<String, dynamic> json) => _$HabitReminderFromJson(json);

@override@JsonKey() final  bool enabled;
/// "HH:mm", 24h.
@override@JsonKey() final  String time;
/// ISO weekdays (1 = Monday … 7 = Sunday). Empty = every day.
 final  List<int> _weekdays;
/// ISO weekdays (1 = Monday … 7 = Sunday). Empty = every day.
@override@JsonKey() List<int> get weekdays {
  if (_weekdays is EqualUnmodifiableListView) return _weekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekdays);
}

@override final  String? message;

/// Create a copy of HabitReminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitReminderCopyWith<_HabitReminder> get copyWith => __$HabitReminderCopyWithImpl<_HabitReminder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitReminderToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitReminder&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.time, time) || other.time == time)&&const DeepCollectionEquality().equals(other.weekdays, _weekdays)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,enabled,time,const DeepCollectionEquality().hash(_weekdays),message);
}

@override
String toString() {
    return 'HabitReminder(enabled: $enabled, time: $time, weekdays: $weekdays, message: $message)';
}


}

/// @nodoc
abstract mixin class _$HabitReminderCopyWith<$Res> implements $HabitReminderCopyWith<$Res> {
  factory _$HabitReminderCopyWith(_HabitReminder value, $Res Function(_HabitReminder) _then) = __$HabitReminderCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, String time, List<int> weekdays, String? message
});




}
/// @nodoc
class __$HabitReminderCopyWithImpl<$Res>
    implements _$HabitReminderCopyWith<$Res> {
  __$HabitReminderCopyWithImpl(this._self, this._then);

  final _HabitReminder _self;
  final $Res Function(_HabitReminder) _then;

/// Create a copy of HabitReminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? time = null,Object? weekdays = null,Object? message = freezed,}) {
  return _then(_HabitReminder(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,weekdays: null == weekdays ? _self._weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Habit {

 String get id; HabitType get type; String get name;/// Either an emoji ("💧") or a line-icon key prefixed with "icon:" ("icon:water").
 String get emoji; String get colorHex; String? get note; Frequency get frequency; int get targetPerPeriod;/// ISO weekdays for weekly habits on specific days. Empty = "X times per week".
 List<int> get weekdays; HabitGoal? get goal; HabitReminder? get reminder; DateTime get createdAt; DateTime get updatedAt; bool get archived;
/// Create a copy of Habit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitCopyWith<Habit> get copyWith => _$HabitCopyWithImpl<Habit>(this as Habit, _$identity);

  /// Serializes this Habit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Habit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Habit&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.emoji, _this.emoji) || other.emoji == _this.emoji)&&(identical(other.colorHex, _this.colorHex) || other.colorHex == _this.colorHex)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.frequency, _this.frequency) || other.frequency == _this.frequency)&&(identical(other.targetPerPeriod, _this.targetPerPeriod) || other.targetPerPeriod == _this.targetPerPeriod)&&const DeepCollectionEquality().equals(other.weekdays, _this.weekdays)&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&(identical(other.reminder, _this.reminder) || other.reminder == _this.reminder)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.archived, _this.archived) || other.archived == _this.archived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Habit;
  return Object.hash(runtimeType,_this.id,_this.type,_this.name,_this.emoji,_this.colorHex,_this.note,_this.frequency,_this.targetPerPeriod,const DeepCollectionEquality().hash(_this.weekdays),_this.goal,_this.reminder,_this.createdAt,_this.updatedAt,_this.archived);
}

@override
String toString() {
  final _this = this as Habit;
  return 'Habit(id: ${_this.id}, type: ${_this.type}, name: ${_this.name}, emoji: ${_this.emoji}, colorHex: ${_this.colorHex}, note: ${_this.note}, frequency: ${_this.frequency}, targetPerPeriod: ${_this.targetPerPeriod}, weekdays: ${_this.weekdays}, goal: ${_this.goal}, reminder: ${_this.reminder}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, archived: ${_this.archived})';
}


}

/// @nodoc
abstract mixin class $HabitCopyWith<$Res>  {
  factory $HabitCopyWith(Habit value, $Res Function(Habit) _then) = _$HabitCopyWithImpl;
@useResult
$Res call({
 String id, HabitType type, String name, String emoji, String colorHex, String? note, Frequency frequency, int targetPerPeriod, List<int> weekdays, HabitGoal? goal, HabitReminder? reminder, DateTime createdAt, DateTime updatedAt, bool archived
});


$HabitGoalCopyWith<$Res>? get goal;$HabitReminderCopyWith<$Res>? get reminder;

}
/// @nodoc
class _$HabitCopyWithImpl<$Res>
    implements $HabitCopyWith<$Res> {
  _$HabitCopyWithImpl(this._self, this._then);

  final Habit _self;
  final $Res Function(Habit) _then;

/// Create a copy of Habit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? name = null,Object? emoji = null,Object? colorHex = null,Object? note = freezed,Object? frequency = null,Object? targetPerPeriod = null,Object? weekdays = null,Object? goal = freezed,Object? reminder = freezed,Object? createdAt = null,Object? updatedAt = null,Object? archived = null,}) {
  return _then(Habit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as HabitType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as Frequency,targetPerPeriod: null == targetPerPeriod ? _self.targetPerPeriod : targetPerPeriod // ignore: cast_nullable_to_non_nullable
as int,weekdays: null == weekdays ? _self.weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as HabitGoal?,reminder: freezed == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as HabitReminder?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Habit
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitGoalCopyWith<$Res>? get goal {
    if (_self.goal == null) {
    return null;
  }

  return $HabitGoalCopyWith<$Res>(_self.goal!, (value) {
    return _then(_self.copyWith(goal: value));
  });
}/// Create a copy of Habit
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitReminderCopyWith<$Res>? get reminder {
    if (_self.reminder == null) {
    return null;
  }

  return $HabitReminderCopyWith<$Res>(_self.reminder!, (value) {
    return _then(_self.copyWith(reminder: value));
  });
}
}


/// Adds pattern-matching-related methods to [Habit].
extension HabitPatterns on Habit {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Habit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Habit() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Habit value)  $default,){
final _that = this;
switch (_that) {
case _Habit():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Habit value)?  $default,){
final _that = this;
switch (_that) {
case _Habit() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  HabitType type,  String name,  String emoji,  String colorHex,  String? note,  Frequency frequency,  int targetPerPeriod,  List<int> weekdays,  HabitGoal? goal,  HabitReminder? reminder,  DateTime createdAt,  DateTime updatedAt,  bool archived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Habit() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.emoji,_that.colorHex,_that.note,_that.frequency,_that.targetPerPeriod,_that.weekdays,_that.goal,_that.reminder,_that.createdAt,_that.updatedAt,_that.archived);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  HabitType type,  String name,  String emoji,  String colorHex,  String? note,  Frequency frequency,  int targetPerPeriod,  List<int> weekdays,  HabitGoal? goal,  HabitReminder? reminder,  DateTime createdAt,  DateTime updatedAt,  bool archived)  $default,) {final _that = this;
switch (_that) {
case _Habit():
return $default(_that.id,_that.type,_that.name,_that.emoji,_that.colorHex,_that.note,_that.frequency,_that.targetPerPeriod,_that.weekdays,_that.goal,_that.reminder,_that.createdAt,_that.updatedAt,_that.archived);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  HabitType type,  String name,  String emoji,  String colorHex,  String? note,  Frequency frequency,  int targetPerPeriod,  List<int> weekdays,  HabitGoal? goal,  HabitReminder? reminder,  DateTime createdAt,  DateTime updatedAt,  bool archived)?  $default,) {final _that = this;
switch (_that) {
case _Habit() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.emoji,_that.colorHex,_that.note,_that.frequency,_that.targetPerPeriod,_that.weekdays,_that.goal,_that.reminder,_that.createdAt,_that.updatedAt,_that.archived);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Habit extends Habit {
  const _Habit({required this.id, required this.type, required this.name, this.emoji = 'icon:star', this.colorHex = '#14A383', this.note, this.frequency = Frequency.daily, this.targetPerPeriod = 1,  List<int> weekdays = const <int>[], this.goal, this.reminder, required this.createdAt, required this.updatedAt, this.archived = false}): _weekdays = weekdays,super._();
  factory _Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

@override final  String id;
@override final  HabitType type;
@override final  String name;
/// Either an emoji ("💧") or a line-icon key prefixed with "icon:" ("icon:water").
@override@JsonKey() final  String emoji;
@override@JsonKey() final  String colorHex;
@override final  String? note;
@override@JsonKey() final  Frequency frequency;
@override@JsonKey() final  int targetPerPeriod;
/// ISO weekdays for weekly habits on specific days. Empty = "X times per week".
 final  List<int> _weekdays;
/// ISO weekdays for weekly habits on specific days. Empty = "X times per week".
@override@JsonKey() List<int> get weekdays {
  if (_weekdays is EqualUnmodifiableListView) return _weekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekdays);
}

@override final  HabitGoal? goal;
@override final  HabitReminder? reminder;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  bool archived;

/// Create a copy of Habit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitCopyWith<_Habit> get copyWith => __$HabitCopyWithImpl<_Habit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Habit&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.note, note) || other.note == note)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.targetPerPeriod, targetPerPeriod) || other.targetPerPeriod == targetPerPeriod)&&const DeepCollectionEquality().equals(other.weekdays, _weekdays)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.reminder, reminder) || other.reminder == reminder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.archived, archived) || other.archived == archived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,name,emoji,colorHex,note,frequency,targetPerPeriod,const DeepCollectionEquality().hash(_weekdays),goal,reminder,createdAt,updatedAt,archived);
}

@override
String toString() {
    return 'Habit(id: $id, type: $type, name: $name, emoji: $emoji, colorHex: $colorHex, note: $note, frequency: $frequency, targetPerPeriod: $targetPerPeriod, weekdays: $weekdays, goal: $goal, reminder: $reminder, createdAt: $createdAt, updatedAt: $updatedAt, archived: $archived)';
}


}

/// @nodoc
abstract mixin class _$HabitCopyWith<$Res> implements $HabitCopyWith<$Res> {
  factory _$HabitCopyWith(_Habit value, $Res Function(_Habit) _then) = __$HabitCopyWithImpl;
@override @useResult
$Res call({
 String id, HabitType type, String name, String emoji, String colorHex, String? note, Frequency frequency, int targetPerPeriod, List<int> weekdays, HabitGoal? goal, HabitReminder? reminder, DateTime createdAt, DateTime updatedAt, bool archived
});


@override $HabitGoalCopyWith<$Res>? get goal;@override $HabitReminderCopyWith<$Res>? get reminder;

}
/// @nodoc
class __$HabitCopyWithImpl<$Res>
    implements _$HabitCopyWith<$Res> {
  __$HabitCopyWithImpl(this._self, this._then);

  final _Habit _self;
  final $Res Function(_Habit) _then;

/// Create a copy of Habit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? name = null,Object? emoji = null,Object? colorHex = null,Object? note = freezed,Object? frequency = null,Object? targetPerPeriod = null,Object? weekdays = null,Object? goal = freezed,Object? reminder = freezed,Object? createdAt = null,Object? updatedAt = null,Object? archived = null,}) {
  return _then(_Habit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as HabitType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as Frequency,targetPerPeriod: null == targetPerPeriod ? _self.targetPerPeriod : targetPerPeriod // ignore: cast_nullable_to_non_nullable
as int,weekdays: null == weekdays ? _self._weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as HabitGoal?,reminder: freezed == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as HabitReminder?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,archived: null == archived ? _self.archived : archived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Habit
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitGoalCopyWith<$Res>? get goal {
    if (_self.goal == null) {
    return null;
  }

  return $HabitGoalCopyWith<$Res>(_self.goal!, (value) {
    return _then(_self.copyWith(goal: value));
  });
}/// Create a copy of Habit
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HabitReminderCopyWith<$Res>? get reminder {
    if (_self.reminder == null) {
    return null;
  }

  return $HabitReminderCopyWith<$Res>(_self.reminder!, (value) {
    return _then(_self.copyWith(reminder: value));
  });
}
}


/// @nodoc
mixin _$HabitLog {

/// yyyy-MM-dd, also the Firestore document id.
 String get date; LogStatus get status; int get count; String? get note; DateTime get createdAt;
/// Create a copy of HabitLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HabitLogCopyWith<HabitLog> get copyWith => _$HabitLogCopyWithImpl<HabitLog>(this as HabitLog, _$identity);

  /// Serializes this HabitLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HabitLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HabitLog&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HabitLog;
  return Object.hash(runtimeType,_this.date,_this.status,_this.count,_this.note,_this.createdAt);
}

@override
String toString() {
  final _this = this as HabitLog;
  return 'HabitLog(date: ${_this.date}, status: ${_this.status}, count: ${_this.count}, note: ${_this.note}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $HabitLogCopyWith<$Res>  {
  factory $HabitLogCopyWith(HabitLog value, $Res Function(HabitLog) _then) = _$HabitLogCopyWithImpl;
@useResult
$Res call({
 String date, LogStatus status, int count, String? note, DateTime createdAt
});




}
/// @nodoc
class _$HabitLogCopyWithImpl<$Res>
    implements $HabitLogCopyWith<$Res> {
  _$HabitLogCopyWithImpl(this._self, this._then);

  final HabitLog _self;
  final $Res Function(HabitLog) _then;

/// Create a copy of HabitLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? status = null,Object? count = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(HabitLog(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LogStatus,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HabitLog].
extension HabitLogPatterns on HabitLog {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HabitLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HabitLog() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HabitLog value)  $default,){
final _that = this;
switch (_that) {
case _HabitLog():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HabitLog value)?  $default,){
final _that = this;
switch (_that) {
case _HabitLog() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  LogStatus status,  int count,  String? note,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HabitLog() when $default != null:
return $default(_that.date,_that.status,_that.count,_that.note,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  LogStatus status,  int count,  String? note,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _HabitLog():
return $default(_that.date,_that.status,_that.count,_that.note,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  LogStatus status,  int count,  String? note,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _HabitLog() when $default != null:
return $default(_that.date,_that.status,_that.count,_that.note,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HabitLog implements HabitLog {
  const _HabitLog({required this.date, required this.status, this.count = 1, this.note, required this.createdAt});
  factory _HabitLog.fromJson(Map<String, dynamic> json) => _$HabitLogFromJson(json);

/// yyyy-MM-dd, also the Firestore document id.
@override final  String date;
@override final  LogStatus status;
@override@JsonKey() final  int count;
@override final  String? note;
@override final  DateTime createdAt;

/// Create a copy of HabitLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HabitLogCopyWith<_HabitLog> get copyWith => __$HabitLogCopyWithImpl<_HabitLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HabitLogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HabitLog&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.count, count) || other.count == count)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,status,count,note,createdAt);
}

@override
String toString() {
    return 'HabitLog(date: $date, status: $status, count: $count, note: $note, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$HabitLogCopyWith<$Res> implements $HabitLogCopyWith<$Res> {
  factory _$HabitLogCopyWith(_HabitLog value, $Res Function(_HabitLog) _then) = __$HabitLogCopyWithImpl;
@override @useResult
$Res call({
 String date, LogStatus status, int count, String? note, DateTime createdAt
});




}
/// @nodoc
class __$HabitLogCopyWithImpl<$Res>
    implements _$HabitLogCopyWith<$Res> {
  __$HabitLogCopyWithImpl(this._self, this._then);

  final _HabitLog _self;
  final $Res Function(_HabitLog) _then;

/// Create a copy of HabitLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? status = null,Object? count = null,Object? note = freezed,Object? createdAt = null,}) {
  return _then(_HabitLog(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LogStatus,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
