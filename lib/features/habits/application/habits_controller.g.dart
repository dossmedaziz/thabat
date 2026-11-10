// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habits_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Overridden in main() (file store) and tests (memory store).

@ProviderFor(dataStore)
final dataStoreProvider = DataStoreProvider._();

/// Overridden in main() (file store) and tests (memory store).

final class DataStoreProvider
    extends $FunctionalProvider<DataStore, DataStore, DataStore>
    with $Provider<DataStore> {
  /// Overridden in main() (file store) and tests (memory store).
  DataStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataStoreHash();

  @$internal
  @override
  $ProviderElement<DataStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DataStore create(Ref ref) {
    return dataStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DataStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DataStore>(value),
    );
  }
}

String _$dataStoreHash() => r'7a6f211ce7a0b9555ddeec843b65ececef836e51';

/// Pending celebration overlays (shown one after another by the app shell).

@ProviderFor(Celebrations)
final celebrationsProvider = CelebrationsProvider._();

/// Pending celebration overlays (shown one after another by the app shell).
final class CelebrationsProvider
    extends $NotifierProvider<Celebrations, List<Celebration>> {
  /// Pending celebration overlays (shown one after another by the app shell).
  CelebrationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'celebrationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$celebrationsHash();

  @$internal
  @override
  Celebrations create() => Celebrations();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Celebration> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Celebration>>(value),
    );
  }
}

String _$celebrationsHash() => r'e13685713f71e4220f884bdfa70d981d88f58d1e';

/// Pending celebration overlays (shown one after another by the app shell).

abstract class _$Celebrations extends $Notifier<List<Celebration>> {
  List<Celebration> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<Celebration>, List<Celebration>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Celebration>, List<Celebration>>,
              List<Celebration>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Single source of truth for the signed-in user's data.
///
/// Every change is applied locally first (instant UI, works offline), saved to the
/// device cache, queued, and then written to Supabase. Failed writes stay queued
/// and are retried on the next change, on app resume and every 30 seconds.

@ProviderFor(AppDataController)
final appDataControllerProvider = AppDataControllerProvider._();

/// Single source of truth for the signed-in user's data.
///
/// Every change is applied locally first (instant UI, works offline), saved to the
/// device cache, queued, and then written to Supabase. Failed writes stay queued
/// and are retried on the next change, on app resume and every 30 seconds.
final class AppDataControllerProvider
    extends $AsyncNotifierProvider<AppDataController, AppData> {
  /// Single source of truth for the signed-in user's data.
  ///
  /// Every change is applied locally first (instant UI, works offline), saved to the
  /// device cache, queued, and then written to Supabase. Failed writes stay queued
  /// and are retried on the next change, on app resume and every 30 seconds.
  AppDataControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDataControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDataControllerHash();

  @$internal
  @override
  AppDataController create() => AppDataController();
}

String _$appDataControllerHash() => r'f1875808a4579e1e77f6ac869bc6fa28ea68349b';

/// Single source of truth for the signed-in user's data.
///
/// Every change is applied locally first (instant UI, works offline), saved to the
/// device cache, queued, and then written to Supabase. Failed writes stay queued
/// and are retried on the next change, on app resume and every 30 seconds.

abstract class _$AppDataController extends $AsyncNotifier<AppData> {
  FutureOr<AppData> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppData>, AppData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppData>, AppData>,
              AsyncValue<AppData>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(habits)
final habitsProvider = HabitsProvider._();

final class HabitsProvider
    extends $FunctionalProvider<List<Habit>, List<Habit>, List<Habit>>
    with $Provider<List<Habit>> {
  HabitsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'habitsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$habitsHash();

  @$internal
  @override
  $ProviderElement<List<Habit>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Habit> create(Ref ref) {
    return habits(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Habit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Habit>>(value),
    );
  }
}

String _$habitsHash() => r'3b71029f24eea7012b7388bd89cf1a51712cc0db';

@ProviderFor(allLogs)
final allLogsProvider = AllLogsProvider._();

final class AllLogsProvider
    extends $FunctionalProvider<AllLogs, AllLogs, AllLogs>
    with $Provider<AllLogs> {
  AllLogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allLogsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allLogsHash();

  @$internal
  @override
  $ProviderElement<AllLogs> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AllLogs create(Ref ref) {
    return allLogs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AllLogs value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AllLogs>(value),
    );
  }
}

String _$allLogsHash() => r'b6bf02d7304c68d7b6d5933e373dba7753501067';

@ProviderFor(habitById)
final habitByIdProvider = HabitByIdFamily._();

final class HabitByIdProvider
    extends $FunctionalProvider<Habit?, Habit?, Habit?>
    with $Provider<Habit?> {
  HabitByIdProvider._({
    required HabitByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'habitByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$habitByIdHash();

  @override
  String toString() {
    return r'habitByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Habit?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Habit? create(Ref ref) {
    final argument = this.argument as String;
    return habitById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Habit? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Habit?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HabitByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$habitByIdHash() => r'b3be0675c5f69d3bae8ad2c3a32ad7713eec2a32';

final class HabitByIdFamily extends $Family
    with $FunctionalFamilyOverride<Habit?, String> {
  HabitByIdFamily._()
    : super(
        retry: null,
        name: r'habitByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HabitByIdProvider call(String id) =>
      HabitByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'habitByIdProvider';
}

@ProviderFor(habitStats)
final habitStatsProvider = HabitStatsFamily._();

final class HabitStatsProvider
    extends $FunctionalProvider<HabitStats?, HabitStats?, HabitStats?>
    with $Provider<HabitStats?> {
  HabitStatsProvider._({
    required HabitStatsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'habitStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$habitStatsHash();

  @override
  String toString() {
    return r'habitStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<HabitStats?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HabitStats? create(Ref ref) {
    final argument = this.argument as String;
    return habitStats(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HabitStats? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HabitStats?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HabitStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$habitStatsHash() => r'8257ad1f8b7d95d0f1657731e497c80b4303a670';

final class HabitStatsFamily extends $Family
    with $FunctionalFamilyOverride<HabitStats?, String> {
  HabitStatsFamily._()
    : super(
        retry: null,
        name: r'habitStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HabitStatsProvider call(String id) =>
      HabitStatsProvider._(argument: id, from: this);

  @override
  String toString() => r'habitStatsProvider';
}

@ProviderFor(achievementProgress)
final achievementProgressProvider = AchievementProgressProvider._();

final class AchievementProgressProvider
    extends
        $FunctionalProvider<
          Map<String, AchievementProgress>,
          Map<String, AchievementProgress>,
          Map<String, AchievementProgress>
        >
    with $Provider<Map<String, AchievementProgress>> {
  AchievementProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'achievementProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$achievementProgressHash();

  @$internal
  @override
  $ProviderElement<Map<String, AchievementProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, AchievementProgress> create(Ref ref) {
    return achievementProgress(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, AchievementProgress> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, AchievementProgress>>(
        value,
      ),
    );
  }
}

String _$achievementProgressHash() =>
    r'e49b55c14d77081e8c66afe51e401741c55a9f64';

@ProviderFor(unlockedAchievements)
final unlockedAchievementsProvider = UnlockedAchievementsProvider._();

final class UnlockedAchievementsProvider
    extends
        $FunctionalProvider<
          Map<String, DateTime>,
          Map<String, DateTime>,
          Map<String, DateTime>
        >
    with $Provider<Map<String, DateTime>> {
  UnlockedAchievementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unlockedAchievementsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unlockedAchievementsHash();

  @$internal
  @override
  $ProviderElement<Map<String, DateTime>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, DateTime> create(Ref ref) {
    return unlockedAchievements(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, DateTime> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, DateTime>>(value),
    );
  }
}

String _$unlockedAchievementsHash() =>
    r'fcee4896ffb98e1aabea7f6b6b66ade940bf3d6c';

/// Number of local changes not yet saved to the server.

@ProviderFor(pendingSyncCount)
final pendingSyncCountProvider = PendingSyncCountProvider._();

/// Number of local changes not yet saved to the server.

final class PendingSyncCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Number of local changes not yet saved to the server.
  PendingSyncCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingSyncCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingSyncCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return pendingSyncCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$pendingSyncCountHash() => r'c5e9dd157fc70864981bbbda2b1133235a0594bf';
