// Renders the app's main screens to PNG files in docs/screenshots/.
//
//   flutter test screenshots/take_screenshots_test.dart
//
// Uses the real IBM Plex fonts and the sample habits, with fake auth / Supabase,
// so it runs offline. Kept outside test/ because the images change every day
// (they show today's date and streaks).
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thabat/app.dart';
import 'package:thabat/core/l10n/gen/app_localizations.dart';
import 'package:thabat/core/router/app_router.dart';
import 'package:thabat/features/auth/data/auth_service.dart';
import 'package:thabat/features/habits/application/habits_controller.dart';
import 'package:thabat/features/habits/data/app_data.dart';
import 'package:thabat/features/habits/data/remote_api.dart';
import 'package:thabat/features/notifications/notification_service.dart';
import 'package:thabat/features/settings/application/settings_controller.dart';

import '../test/support/fakes.dart';

const _out = 'docs/screenshots';
const _size = Size(390, 844);

/// Pretends notifications are allowed so the Reminders screen shows its normal state.
class _FakeNotifications extends NotificationService {
  @override
  Future<bool> permissionGranted() async => true;
  @override
  Future<bool> exactAlarmsAllowed() async => true;
  @override
  int get lastScheduled => 9;
}

Future<void> _loadFonts() async {
  const weights = ['Regular', 'Medium', 'SemiBold', 'Bold'];
  for (final family in ['IBMPlexSansArabic', 'IBMPlexSans']) {
    final loader = FontLoader(family);
    for (final w in weights) {
      loader.addFont(rootBundle.load('assets/fonts/$family-$w.ttf'));
    }
    await loader.load();
  }
}

/// Lets SVG icons and images finish decoding, then settles animations.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 80)));
    await tester.pump(const Duration(milliseconds: 400));
  }
  await tester.pumpAndSettle(const Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, const Duration(seconds: 20));
}

Future<void> _shot(WidgetTester tester, GlobalKey key, String name) async {
  await _settle(tester);
  final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    File('$_out/$name.png').writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}

Future<(ProviderContainer, GlobalKey)> _start(WidgetTester tester, {required String locale, String theme = 'light'}) async {
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({'locale': locale, 'themeMode': theme, 'notifPermissionAsked': true});
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
    dataStoreProvider.overrideWithValue(MemoryDataStore()),
    authServiceProvider.overrideWithValue(FakeAuthService(
      account: AuthUser(
        id: FakeAuthService.demo.id,
        email: 'ahmed@example.com',
        fullName: locale == 'ar' ? 'أحمد بن علي' : 'Ahmed Ben Ali',
        createdAt: DateTime.now().subtract(const Duration(days: 56)),
      ),
    )),
    remoteApiProvider.overrideWithValue(FakeRemoteApi()),
    notificationServiceProvider.overrideWithValue(_FakeNotifications()),
  ]);
  final key = GlobalKey();
  await tester.binding.setSurfaceSize(_size);
  tester.view.physicalSize = _size;
  tester.view.devicePixelRatio = 1;
  await tester.pumpWidget(RepaintBoundary(
    key: key,
    child: UncontrolledProviderScope(container: container, child: const ThabatApp()),
  ));
  await _settle(tester);
  return (container, key);
}

Future<void> _signInWithSamples(WidgetTester tester, ProviderContainer c) async {
  await c.read(authServiceProvider).signInWithGoogle();
  await _settle(tester);
  final l = lookupAppLocalizations(Locale(c.read(settingsControllerProvider).locale));
  c.read(appDataControllerProvider.notifier).addSampleData(l);
  await _settle(tester);
}

Future<void> _go(WidgetTester tester, ProviderContainer c, String location, {bool push = false}) async {
  final router = c.read(routerProvider);
  push ? router.push(location) : router.go(location);
  await _settle(tester);
}

Future<void> _finish(WidgetTester tester, ProviderContainer c) async {
  await tester.pumpWidget(const SizedBox());
  c.dispose();
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await _loadFonts();
    Directory(_out).createSync(recursive: true);
  });

  testWidgets('Arabic, light', (tester) async {
    final (c, key) = await _start(tester, locale: 'ar');
    await _shot(tester, key, 'ar_01_sign_in');
    await _signInWithSamples(tester, c);
    await _shot(tester, key, 'ar_02_today');

    await tester.tap(find.text('أتجنب'));
    await _shot(tester, key, 'ar_03_today_avoid');

    final read = c.read(habitsProvider).firstWhere((h) => h.name == 'قراءة 20 دقيقة');
    await _go(tester, c, '/habit/${read.id}', push: true);
    await _shot(tester, key, 'ar_04_habit_detail');

    await _go(tester, c, '/habit/new', push: true);
    await _shot(tester, key, 'ar_05_new_habit');

    await _go(tester, c, '/progress');
    await _shot(tester, key, 'ar_06_progress');
    await _go(tester, c, '/achievements');
    await _shot(tester, key, 'ar_07_achievements');
    await _go(tester, c, '/profile');
    await _shot(tester, key, 'ar_08_profile');
    await _go(tester, c, '/reminders', push: true);
    await _shot(tester, key, 'ar_09_reminders');
    await _finish(tester, c);
  });

  testWidgets('Arabic, dark', (tester) async {
    final (c, key) = await _start(tester, locale: 'ar', theme: 'dark');
    await _signInWithSamples(tester, c);
    await _shot(tester, key, 'ar_dark_today');
    final smoke = c.read(habitsProvider).firstWhere((h) => h.name == 'التدخين');
    await _go(tester, c, '/habit/${smoke.id}', push: true);
    await _shot(tester, key, 'ar_dark_habit_detail');
    await _finish(tester, c);
  });

  testWidgets('English and French, light', (tester) async {
    final (c, key) = await _start(tester, locale: 'en');
    await _signInWithSamples(tester, c);
    await _shot(tester, key, 'en_today');
    await _go(tester, c, '/progress');
    await _shot(tester, key, 'en_progress');
    c.read(settingsControllerProvider.notifier).setLocale('fr');
    await _go(tester, c, '/today');
    await _shot(tester, key, 'fr_today');
    await _finish(tester, c);
  });
}
