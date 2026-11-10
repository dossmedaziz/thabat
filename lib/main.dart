import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/env.dart';
import 'features/habits/application/habits_controller.dart';
import 'features/habits/data/app_data.dart';
import 'features/notifications/notification_service.dart';
import 'features/settings/application/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Restores the saved session from the device, so the app also opens offline.
  await Supabase.initialize(url: Env.supabaseUrl, publishableKey: Env.supabasePublishableKey);
  final prefs = await SharedPreferences.getInstance();
  await initializeDateFormatting();
  final notifications = NotificationService();
  await notifications.init();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        dataStoreProvider.overrideWithValue(FileDataStore()),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
      child: const ThabatApp(),
    ),
  );
}
