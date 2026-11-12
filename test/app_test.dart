import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thabat/app.dart';
import 'package:thabat/core/router/app_router.dart';
import 'package:thabat/core/l10n/gen/app_localizations.dart';
import 'package:thabat/core/utils/dates.dart';
import 'package:thabat/features/habits/application/habits_controller.dart';
import 'package:thabat/features/habits/data/app_data.dart';
import 'package:thabat/features/habits/data/seed.dart';
import 'package:thabat/features/habits/domain/habit_stats.dart';
import 'package:thabat/features/habits/domain/models.dart';
import 'package:thabat/features/habits/presentation/widgets/habit_card.dart';
import 'package:thabat/features/auth/data/auth_service.dart';
import 'package:thabat/features/habits/data/remote_api.dart';
import 'package:thabat/features/settings/application/settings_controller.dart';

import 'support/fakes.dart';

Future<ProviderContainer> pumpApp(WidgetTester tester, {String locale = 'ar', FakeRemoteApi? remote}) async {
  SharedPreferences.setMockInitialValues({'locale': locale});
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    dataStoreProvider.overrideWithValue(MemoryDataStore()),
    authServiceProvider.overrideWithValue(FakeAuthService()),
    remoteApiProvider.overrideWithValue(remote ?? FakeRemoteApi()),
  ]);
  await tester.binding.setSurfaceSize(const Size(390, 844));
  await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const ThabatApp()));
  await tester.pumpAndSettle();
  return container;
}

/// Signs in with the fake Google account and loads the sample habits.
Future<void> signInWithSamples(WidgetTester tester, ProviderContainer container, String buttonText) async {
  await tester.tap(find.text(buttonText));
  await tester.pumpAndSettle();
  final l = lookupAppLocalizations(Locale(container.read(settingsControllerProvider).locale));
  container.read(appDataControllerProvider.notifier).addSampleData(l);
  await tester.pumpAndSettle();
}

/// Tears the app down inside the test so provider timers are cancelled.
Future<void> finish(WidgetTester tester, ProviderContainer container) async {
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpWidget(const SizedBox());
  container.dispose();
  await tester.pump();
}

void main() {
  setUpAll(() async => initializeDateFormatting());

  test('ARB files have identical keys in ar / en / fr', () {
    Set<String> keys(String f) =>
        (jsonDecode(File('lib/core/l10n/$f').readAsStringSync()) as Map<String, dynamic>).keys.where((k) => !k.startsWith('@')).toSet();
    final ar = keys('app_ar.arb');
    expect(keys('app_en.arb'), ar);
    expect(keys('app_fr.arb'), ar);
  });

  test('Lottie assets parse', () async {
    for (final f in ['check_pop', 'badge_burst']) {
      final comp = await LottieComposition.fromBytes(File('assets/lottie/$f.json').readAsBytesSync());
      expect(comp.duration.inMilliseconds, greaterThan(0));
    }
  });

  test('sample data matches the brief and has sane streaks', () {
    final l = lookupAppLocalizations(const Locale('ar'));
    final today = DateTime(2026, 11, 10);
    final s = buildSampleData(l, today, WeekStart.monday);
    expect(s.habits.where((h) => h.isGood).map((h) => h.name), ['شرب الماء', 'قراءة 20 دقيقة', 'الرياضة', 'زيارة العائلة']);
    expect(s.habits.where((h) => h.isBad).length, 4);
    final water = s.habits.first;
    final st = computeStats(water, s.logs[water.id]!, today, WeekStart.monday);
    expect(st.currentStreak, 12);
    final smoke = s.habits.firstWhere((h) => h.name == 'التدخين');
    expect(computeStats(smoke, s.logs[smoke.id]!, today, WeekStart.monday).daysClean, 23);
    for (final logs in s.logs.values) {
      for (final k in logs.keys) {
        expect(parseDateKey(k).isAfter(today), isFalse);
      }
    }
  });

  testWidgets('Arabic: RTL sign-in → Today with sample data, check-in works', (tester) async {
    final semantics = tester.ensureSemantics();
    final container = await pumpApp(tester);
    expect(find.text('المتابعة باستخدام Google'), findsOneWidget);
    final dir = tester.widget<Directionality>(find.byType(Directionality).first);
    expect(dir.textDirection, TextDirection.rtl);

    await signInWithSamples(tester, container, 'المتابعة باستخدام Google');
    expect(find.text('عادات أبنيها'), findsOneWidget);
    expect(find.text('قراءة 20 دقيقة'), findsOneWidget);

    final read = container.read(habitsProvider).firstWhere((h) => h.name == 'قراءة 20 دقيقة');
    expect(container.read(habitStatsProvider(read.id))!.doneToday, isFalse);
    await tester.tap(find.byWidgetPredicate((w) => w is CheckButton && w.label == 'تسجيل: قراءة 20 دقيقة'));
    await tester.pumpAndSettle();
    expect(container.read(habitStatsProvider(read.id))!.doneToday, isTrue);

    // Avoid tab shows bad habits with the slip button.
    await tester.tap(find.text('أتجنب'));
    await tester.pumpAndSettle();
    expect(find.text('التدخين'), findsOneWidget);
    expect(find.text('تعثرت'), findsWidgets);
    semantics.dispose();
    await finish(tester, container);
  });

  testWidgets('English: LTR and every tab renders', (tester) async {
    final container = await pumpApp(tester, locale: 'en');
    expect(tester.widget<Directionality>(find.byType(Directionality).first).textDirection, TextDirection.ltr);
    await signInWithSamples(tester, container, 'Continue with Google');
    expect(find.text('Habits I’m building'), findsOneWidget);

    for (final tab in ['Progress', 'Awards', 'Profile']) {
      await tester.tap(find.text(tab).last);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
    expect(find.text('Last 7 days'), findsNothing); // on Profile now
    await tester.tap(find.text('Progress').last);
    await tester.pumpAndSettle();
    expect(find.text('Last 7 days'), findsOneWidget);
    await finish(tester, container);
  });

  testWidgets('habit detail and editor open without errors', (tester) async {
    final container = await pumpApp(tester, locale: 'fr');
    await signInWithSamples(tester, container, 'Continuer avec Google');
    final h = container.read(habitsProvider).first;
    container.read(routerProvider).push('/habit/${h.id}');
    await tester.pumpAndSettle();
    expect(find.text(h.name), findsWidgets);
    container.read(routerProvider).push('/habit/${h.id}/edit');
    await tester.pumpAndSettle();
    expect(find.text("Modifier l'habitude"), findsOneWidget);
    container.read(routerProvider).push('/habit/new');
    await tester.pumpAndSettle();
    expect(find.text('Nouvelle habitude'), findsOneWidget);
    await finish(tester, container);
  });

  testWidgets('sign-in with an empty account shows the empty state, check-ins reach the server', (tester) async {
    final remote = FakeRemoteApi();
    final container = await pumpApp(tester, locale: 'en', remote: remote);
    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();
    expect(find.text('Your first step starts here'), findsOneWidget);
    expect(remote.profile?['locale'], 'en'); // profile row created on first sign-in

    final l = lookupAppLocalizations(const Locale('en'));
    container.read(appDataControllerProvider.notifier).addSampleData(l);
    await tester.pumpAndSettle();
    expect(remote.habits.length, 8);
    expect(remote.logs, isNotEmpty);
    final read = container.read(habitsProvider).firstWhere((h) => h.name == 'Read 20 min');
    container.read(appDataControllerProvider.notifier).setLog(read.id, LogStatus.done);
    await tester.pumpAndSettle();
    expect(remote.logs.keys.where((k) => k.startsWith('${read.id}|')).length,
        container.read(allLogsProvider)[read.id]!.length);
    expect(container.read(pendingSyncCountProvider), 0);
    await finish(tester, container);
  });

  testWidgets('offline changes are queued and sent when back online', (tester) async {
    final remote = FakeRemoteApi();
    final container = await pumpApp(tester, locale: 'en', remote: remote);
    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();
    remote.offline = true;
    final now = DateTime.now();
    final h = Habit(id: '11111111-1111-4111-8111-111111111111', type: HabitType.good, name: 'Walk', createdAt: now, updatedAt: now);
    final ctrl = container.read(appDataControllerProvider.notifier);
    ctrl.upsertHabit(h);
    ctrl.setLog(h.id, LogStatus.done);
    await tester.pumpAndSettle();
    expect(container.read(habitsProvider).map((x) => x.name), contains('Walk')); // visible immediately
    expect(container.read(pendingSyncCountProvider), greaterThanOrEqualTo(2));
    expect(remote.habits, isEmpty);

    remote.offline = false;
    await ctrl.refresh();
    await tester.pumpAndSettle();
    expect(container.read(pendingSyncCountProvider), 0);
    expect(remote.habits.keys, contains(h.id));
    expect(remote.logs.keys, contains('${h.id}|${dateKey(now)}'));
    await finish(tester, container);
  });

  test('habit and log rows round-trip through the Supabase column mapping', () {
    final now = DateTime(2026, 11, 10, 21, 30);
    final h = Habit(
      id: '22222222-2222-4222-8222-222222222222',
      type: HabitType.bad,
      name: 'التدخين',
      emoji: 'icon:smoke',
      frequency: Frequency.weekly,
      targetPerPeriod: 2,
      weekdays: const [1, 3],
      goal: const HabitGoal(kind: GoalKind.streak, value: 3, unit: GoalUnit.months),
      reminder: const HabitReminder(enabled: true, time: '08:00', weekdays: [1, 2]),
      createdAt: now,
      updatedAt: now,
    );
    final row = habitToRow(h, 'uid');
    expect(row['color_hex'], '#14A383');
    expect(row['user_id'], 'uid');
    expect(habitFromRow(jsonDecode(jsonEncode(row)) as Map<String, dynamic>), h);
    final log = HabitLog(date: '2026-11-10', status: LogStatus.slipped, note: 'x', createdAt: now);
    expect(logFromRow(jsonDecode(jsonEncode(logToRow(h.id, log, 'uid'))) as Map<String, dynamic>), log);
  });

  testWidgets('email sign-in: code is emailed, wrong code rejected, right code signs in', (tester) async {
    final container = await pumpApp(tester, locale: 'en');
    await tester.tap(find.text('Continue with email'));
    await tester.pumpAndSettle();
    expect(find.text('Sign in with email'), findsOneWidget);

    // Invalid address is caught before anything is sent.
    await tester.enterText(find.byType(TextFormField), 'not-an-email');
    await tester.tap(find.text('Send code'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email address'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'sara@example.com');
    await tester.tap(find.text('Send code'));
    await tester.pumpAndSettle();
    expect(find.text('Enter the code'), findsOneWidget);
    expect(find.textContaining('sara@example.com'), findsOneWidget);
    expect(find.textContaining('Resend in'), findsOneWidget); // cooldown running

    // Typing the 6th digit submits on its own.
    await tester.enterText(find.byType(TextFormField), '12345');
    await tester.pumpAndSettle();
    expect(find.text('Enter the code'), findsOneWidget); // 5 digits: nothing sent yet
    await tester.enterText(find.byType(TextFormField), '000000');
    await tester.pumpAndSettle();
    expect(find.text('That code is wrong or has expired.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), '9999999'); // a 7th digit is ignored
    expect(tester.widget<EditableText>(find.byType(EditableText)).controller.text.length, 6);

    await tester.enterText(find.byType(TextFormField), FakeAuthService.emailCode);
    await tester.pumpAndSettle();
    expect(find.text('Your first step starts here'), findsOneWidget); // new account → empty Today
    expect(container.read(appDataControllerProvider).value!.user!.provider, 'email');
    expect(container.read(appDataControllerProvider).value!.user!.name, 'sara');
    await finish(tester, container);
  });
}
