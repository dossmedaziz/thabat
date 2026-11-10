import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/gen/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/notifications/notification_service.dart';
import 'features/settings/application/settings_controller.dart';

class ThabatApp extends ConsumerWidget {
  const ThabatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final router = ref.watch(routerProvider);
    ref.watch(reminderSyncProvider); // keeps notifications in sync with data + settings
    return MaterialApp.router(
      title: 'Thabat',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      locale: Locale(settings.locale),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: settings.themeMode,
      theme: buildTheme(Brightness.light, settings.locale),
      darkTheme: buildTheme(Brightness.dark, settings.locale),
      onGenerateTitle: (c) => AppLocalizations.of(c).appName,
    );
  }
}
