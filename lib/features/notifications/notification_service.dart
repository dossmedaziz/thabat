import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../core/l10n/gen/app_localizations.dart';
import '../../core/utils/clock.dart';
import '../../core/utils/dates.dart';
import '../habits/application/habits_controller.dart';
import '../habits/domain/models.dart';
import '../settings/application/settings_controller.dart';

part 'notification_service.g.dart';

const _payloadPrefix = 'habit:';

/// Stable notification id base for a habit id (FNV-1a), 0..99_999.
int notificationBase(String habitId) {
  var h = 0x811c9dc5;
  for (final c in habitId.codeUnits) {
    h ^= c;
    h = (h * 0x01000193) & 0xFFFFFFFF;
  }
  return h % 100000;
}

/// Wraps flutter_local_notifications: schedules habit reminders and streak alerts.
class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  String? _pendingHabitId;
  final _taps = StreamController<String>.broadcast();

  /// Habit ids from notification taps while the app is running.
  Stream<String> get taps => _taps.stream;

  /// Habit id of the notification that launched the app (read once).
  String? takeLaunchHabitId() {
    final id = _pendingHabitId;
    _pendingHabitId = null;
    return id;
  }

  Future<void> init() async {
    if (_ready || kIsWeb) return;
    try {
      tzdata.initializeTimeZones();
      try {
        final info = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(info.identifier));
      } catch (_) {
        tz.setLocalLocation(tz.getLocation('Africa/Tunis'));
      }
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('ic_stat_thabat'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: (r) {
          final id = _parse(r.payload);
          if (id != null) _taps.add(id);
        },
      );
      final launch = await _plugin.getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp ?? false) {
        _pendingHabitId = _parse(launch!.notificationResponse?.payload);
      }
      _ready = true;
    } catch (e, st) {
      debugPrint('Thabat: notifications unavailable: $e\n$st');
    }
  }

  String? _parse(String? p) => (p != null && p.startsWith(_payloadPrefix)) ? p.substring(_payloadPrefix.length) : null;

  /// Asks the OS for permission. Called when the user first turns a reminder on.
  Future<bool> requestPermission() async {
    if (!_ready) await init();
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) return await android.requestNotificationsPermission() ?? false;
      final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      if (ios != null) return await ios.requestPermissions(alert: true, badge: true, sound: true) ?? false;
    } catch (e) {
      debugPrint('Thabat: permission request failed: $e');
    }
    return false;
  }

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  IOSFlutterLocalNotificationsPlugin? get _ios =>
      _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

  /// Whether the OS currently lets Thabat show notifications.
  Future<bool> permissionGranted() async {
    if (!_ready) await init();
    try {
      if (_android != null) return await _android!.areNotificationsEnabled() ?? false;
      if (_ios != null) return (await _ios!.checkPermissions())?.isEnabled ?? false;
    } catch (e) {
      debugPrint('Thabat: could not read notification permission: $e');
    }
    return false;
  }

  /// Android 12+: whether reminders can fire at the exact minute.
  Future<bool> exactAlarmsAllowed() async {
    try {
      return await _android?.canScheduleExactNotifications() ?? true;
    } catch (_) {
      return false;
    }
  }

  /// Opens the system screen where the user can allow exact alarms (Android 12+).
  Future<void> requestExactAlarms() async {
    try {
      await _android?.requestExactAlarmsPermission();
    } catch (e) {
      debugPrint('Thabat: exact alarm request failed: $e');
    }
  }

  Future<void> openSystemSettings() async {
    try {
      await _plugin.openAppNotificationSettings();
    } catch (e) {
      debugPrint('Thabat: could not open notification settings: $e');
    }
  }

  /// Shows a notification right now (to check that notifications work at all).
  Future<void> showTest(AppLocalizations l) async {
    if (!_ready) await init();
    await _plugin.show(
      id: 999999,
      title: l.testNotificationTitle,
      body: l.testNotificationBody,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails('reminders', l.channelReminders,
            importance: Importance.high, priority: Priority.high, color: const Color(0xFF14A383)),
        iOS: const DarwinNotificationDetails(presentAlert: true, presentSound: true, presentBanner: true),
      ),
    );
  }

  Future<void> cancelAll() async {
    if (_ready) await _plugin.cancelAll();
  }

  /// Cancels everything and schedules the current set again.
  Future<void> syncAll({
    required List<Habit> habits,
    required AllLogs logs,
    required AppSettings settings,
    required AppLocalizations l,
    required bool signedIn,
  }) async {
    if (!_ready) return;
    lastScheduled = 0;
    try {
      await _plugin.cancelAll();
    } catch (e) {
      debugPrint('Thabat: cancelAll failed: $e');
    }
    if (!signedIn || !settings.notificationsEnabled) return;

    final reminderDetails = NotificationDetails(
      android: AndroidNotificationDetails('reminders', l.channelReminders,
          importance: Importance.high, priority: Priority.high, color: const Color(0xFF14A383)),
      iOS: const DarwinNotificationDetails(presentAlert: true, presentSound: true, presentBanner: true),
    );
    final streakDetails = NotificationDetails(
      android: AndroidNotificationDetails('streak', l.channelStreak, color: const Color(0xFFE8792B)),
      iOS: const DarwinNotificationDetails(presentAlert: true, presentBanner: true),
    );
    bool quiet(String hm) => settings.quietEnabled && inQuietWindow(hm, settings.quietStart, settings.quietEnd);
    final now = tz.TZDateTime.now(tz.local);
    // Exact alarms fire on the minute; inexact ones may arrive many minutes late.
    _mode = await exactAlarmsAllowed() ? AndroidScheduleMode.exactAllowWhileIdle : AndroidScheduleMode.inexactAllowWhileIdle;

    for (final h in habits) {
      final r = h.reminder;
      final base = notificationBase(h.id) * 10;
      if (r != null && r.enabled && !quiet(r.time)) {
        final (hh, mm) = parseHm(r.time);
        final body = (r.message?.trim().isNotEmpty ?? false)
            ? r.message!.trim()
            : (h.isGood ? l.reminderDefaultGood(h.name) : l.reminderDefaultBad(h.name));
        final days = r.weekdays.length == 7 ? const <int>[] : r.weekdays;
        if (days.isEmpty) {
          await _schedule(base, h, body, _nextAt(now, hh, mm), reminderDetails, DateTimeComponents.time);
        } else {
          for (final wd in days) {
            await _schedule(base + wd, h, body, _nextWeekday(now, wd, hh, mm), reminderDetails,
                DateTimeComponents.dayOfWeekAndTime);
          }
        }
      }

      // Streak at risk: good daily habits not yet done today.
      if (settings.streakRiskEnabled && h.isGood && h.frequency == Frequency.daily && !quiet(settings.streakRiskTime)) {
        final (hh, mm) = parseHm(settings.streakRiskTime);
        final doneToday = logs[h.id]?[dateKey(now)]?.status == LogStatus.done;
        var at = tz.TZDateTime(tz.local, now.year, now.month, now.day, hh, mm);
        if (doneToday || !at.isAfter(now)) at = at.add(const Duration(days: 1));
        await _guard('streak ${h.id}', () => _plugin.zonedSchedule(
              id: base + 8,
              title: l.streakRiskNotifTitle,
              body: l.streakRiskNotifBody(h.name),
              scheduledDate: at,
              notificationDetails: streakDetails,
              androidScheduleMode: _mode,
              payload: '$_payloadPrefix${h.id}',
            ));
      }
    }
  }

  AndroidScheduleMode _mode = AndroidScheduleMode.inexactAllowWhileIdle;

  /// Number of notifications scheduled by the last sync (shown on the Reminders screen).
  int lastScheduled = 0;

  /// Runs one scheduling call; a failure is logged instead of aborting the whole sync.
  Future<void> _guard(String what, Future<void> Function() f) async {
    try {
      await f();
      lastScheduled++;
    } catch (e) {
      if (_mode == AndroidScheduleMode.exactAllowWhileIdle) {
        // Exact alarm access can be revoked at any time: fall back to inexact.
        _mode = AndroidScheduleMode.inexactAllowWhileIdle;
        try {
          await f();
          lastScheduled++;
          return;
        } catch (_) {}
      }
      debugPrint('Thabat: could not schedule $what: $e');
    }
  }

  Future<void> _schedule(int id, Habit h, String body, tz.TZDateTime at, NotificationDetails d, DateTimeComponents c) =>
      _guard('reminder ${h.id}', () => _plugin.zonedSchedule(
            id: id,
            title: h.name,
            body: body,
            scheduledDate: at,
            notificationDetails: d,
            androidScheduleMode: _mode,
            matchDateTimeComponents: c,
            payload: '$_payloadPrefix${h.id}',
          ));

  tz.TZDateTime _nextAt(tz.TZDateTime now, int h, int m) {
    var t = tz.TZDateTime(tz.local, now.year, now.month, now.day, h, m);
    if (!t.isAfter(now)) t = t.add(const Duration(days: 1));
    return t;
  }

  tz.TZDateTime _nextWeekday(tz.TZDateTime now, int weekday, int h, int m) {
    var t = _nextAt(now, h, m);
    while (t.weekday != weekday) {
      t = t.add(const Duration(days: 1));
    }
    return t;
  }
}

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) => NotificationService();

/// Keeps scheduled notifications in sync with habits, logs and settings
/// (create / edit / disable / delete / check-in / sign-out all trigger a reschedule).
@Riverpod(keepAlive: true)
class ReminderSync extends _$ReminderSync {
  Timer? _debounce;

  @override
  int build() {
    final data = ref.watch(appDataControllerProvider).value;
    final settings = ref.watch(settingsControllerProvider);
    ref.watch(todayProvider);
    ref.onDispose(() => _debounce?.cancel());
    if (data == null) return 0;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      final service = ref.read(notificationServiceProvider);
      final active = data.habits.where((h) => !h.archived).toList();
      try {
        await service.syncAll(
          habits: active,
          logs: data.logs,
          settings: settings,
          l: lookupAppLocalizations(Locale(settings.locale)),
          signedIn: data.signedIn,
        );
      } catch (e, st) {
        debugPrint('Thabat: reminder sync failed: $e\n$st');
      }
      // Reminders can arrive already switched on (sample data, another device, the
      // default streak alert) without the user ever touching a switch, so ask once here.
      final wantsAny = settings.notificationsEnabled &&
          (settings.streakRiskEnabled || active.any((h) => h.reminder?.enabled ?? false));
      final prefs = ref.read(sharedPreferencesProvider);
      if (data.signedIn && wantsAny && !(prefs.getBool('notifPermissionAsked') ?? false)) {
        await prefs.setBool('notifPermissionAsked', true);
        if (!await service.permissionGranted()) await service.requestPermission();
      }
    });
    return data.habits.where((h) => h.reminder?.enabled ?? false).length;
  }
}
