import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../habits/domain/models.dart';

part 'settings_controller.g.dart';

const supportedLanguages = ['ar', 'en', 'fr'];

@immutable
class AppSettings {
  const AppSettings({
    this.locale = 'ar',
    this.themeMode = ThemeMode.system,
    this.weekStart = WeekStart.monday,
    this.notificationsEnabled = true,
    this.streakRiskEnabled = true,
    this.streakRiskTime = '21:30',
    this.quietEnabled = true,
    this.quietStart = '22:00',
    this.quietEnd = '07:00',
  });

  final String locale;
  final ThemeMode themeMode;
  final WeekStart weekStart;
  final bool notificationsEnabled;
  final bool streakRiskEnabled;
  final String streakRiskTime;
  final bool quietEnabled;
  final String quietStart;
  final String quietEnd;

  AppSettings copyWith({
    String? locale,
    ThemeMode? themeMode,
    WeekStart? weekStart,
    bool? notificationsEnabled,
    bool? streakRiskEnabled,
    String? streakRiskTime,
    bool? quietEnabled,
    String? quietStart,
    String? quietEnd,
  }) =>
      AppSettings(
        locale: locale ?? this.locale,
        themeMode: themeMode ?? this.themeMode,
        weekStart: weekStart ?? this.weekStart,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        streakRiskEnabled: streakRiskEnabled ?? this.streakRiskEnabled,
        streakRiskTime: streakRiskTime ?? this.streakRiskTime,
        quietEnabled: quietEnabled ?? this.quietEnabled,
        quietStart: quietStart ?? this.quietStart,
        quietEnd: quietEnd ?? this.quietEnd,
      );

  Map<String, Object> toJson() => {
        'locale': locale,
        'themeMode': themeMode.name,
        'weekStart': weekStart.name,
        'notificationsEnabled': notificationsEnabled,
        'streakRiskEnabled': streakRiskEnabled,
        'streakRiskTime': streakRiskTime,
        'quietEnabled': quietEnabled,
        'quietStart': quietStart,
        'quietEnd': quietEnd,
      };
}

/// Overridden in main() with the real instance.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError('sharedPreferences not overridden');

@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  SharedPreferences get _p => ref.read(sharedPreferencesProvider);

  @override
  AppSettings build() {
    final p = ref.watch(sharedPreferencesProvider);
    const d = AppSettings();
    final loc = p.getString('locale');
    return AppSettings(
      locale: supportedLanguages.contains(loc) ? loc! : d.locale,
      themeMode: ThemeMode.values.firstWhere((m) => m.name == p.getString('themeMode'), orElse: () => d.themeMode),
      weekStart: WeekStart.fromName(p.getString('weekStart')),
      notificationsEnabled: p.getBool('notificationsEnabled') ?? d.notificationsEnabled,
      streakRiskEnabled: p.getBool('streakRiskEnabled') ?? d.streakRiskEnabled,
      streakRiskTime: p.getString('streakRiskTime') ?? d.streakRiskTime,
      quietEnabled: p.getBool('quietEnabled') ?? d.quietEnabled,
      quietStart: p.getString('quietStart') ?? d.quietStart,
      quietEnd: p.getString('quietEnd') ?? d.quietEnd,
    );
  }

  void setLocale(String code) {
    if (!supportedLanguages.contains(code)) return;
    _p.setString('locale', code);
    state = state.copyWith(locale: code);
  }

  void setThemeMode(ThemeMode m) {
    _p.setString('themeMode', m.name);
    state = state.copyWith(themeMode: m);
  }

  void setWeekStart(WeekStart w) {
    _p.setString('weekStart', w.name);
    state = state.copyWith(weekStart: w);
  }

  void setNotifications(bool v) {
    _p.setBool('notificationsEnabled', v);
    state = state.copyWith(notificationsEnabled: v);
  }

  void setStreakRisk(bool v) {
    _p.setBool('streakRiskEnabled', v);
    state = state.copyWith(streakRiskEnabled: v);
  }

  void setStreakRiskTime(String hm) {
    _p.setString('streakRiskTime', hm);
    state = state.copyWith(streakRiskTime: hm);
  }

  void setQuiet({bool? enabled, String? start, String? end}) {
    if (enabled != null) _p.setBool('quietEnabled', enabled);
    if (start != null) _p.setString('quietStart', start);
    if (end != null) _p.setString('quietEnd', end);
    state = state.copyWith(quietEnabled: enabled, quietStart: start, quietEnd: end);
  }

  /// Wipes every preference (used by "delete account").
  Future<void> reset() async {
    final keep = state.locale;
    await _p.clear();
    await _p.setString('locale', keep);
    ref.invalidateSelf();
  }
}
