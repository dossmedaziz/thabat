import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/achievements/presentation/achievements_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/habits/application/habits_controller.dart';
import '../../features/habits/domain/models.dart';
import '../../features/habits/presentation/edit_habit_screen.dart';
import '../../features/habits/presentation/habit_detail_screen.dart';
import '../../features/habits/presentation/today_screen.dart';
import '../../features/notifications/presentation/reminders_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../features/settings/presentation/language_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../widgets/app_shell.dart';

part 'app_router.g.dart';

abstract final class Routes {
  static const splash = '/splash';
  static const signIn = '/sign-in';
  static const today = '/today';
  static const progress = '/progress';
  static const achievements = '/achievements';
  static const profile = '/profile';
  static const reminders = '/reminders';
  static const language = '/language';
  static String newHabit({HabitType? type, String? preset}) => Uri(
        path: '/habit/new',
        queryParameters: {
          'type': ?type?.name,
          'preset': ?preset,
        },
      ).toString();
  static String habit(String id) => '/habit/$id';
  static String editHabit(String id) => '/habit/$id/edit';
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final refresh = ValueNotifier(0);
  (bool, bool)? last;
  ref.listen(appDataControllerProvider, (_, a) {
    final key = (a.hasValue, a.value?.signedIn ?? false);
    if (key != last) {
      last = key;
      refresh.value++;
    }
  });
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: Routes.today,
    refreshListenable: refresh,
    redirect: (context, state) {
      final data = ref.read(appDataControllerProvider);
      final loc = state.matchedLocation;
      if (!data.hasValue) return loc == Routes.splash ? null : Routes.splash;
      final signedIn = data.value!.signedIn;
      if (!signedIn) return loc == Routes.signIn ? null : Routes.signIn;
      if (loc == Routes.signIn || loc == Routes.splash) return Routes.today;
      return null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.signIn, builder: (_, _) => const SignInScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: Routes.today, builder: (_, _) => const TodayScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: Routes.progress, builder: (_, _) => const ProgressScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: Routes.achievements, builder: (_, _) => const AchievementsScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: Routes.profile, builder: (_, _) => const SettingsScreen())]),
        ],
      ),
      GoRoute(
        path: '/habit/new',
        builder: (_, s) => EditHabitScreen(
          initialType: s.uri.queryParameters['type'] == 'bad' ? HabitType.bad : HabitType.good,
          preset: s.uri.queryParameters['preset'],
        ),
      ),
      GoRoute(path: '/habit/:id', builder: (_, s) => HabitDetailScreen(habitId: s.pathParameters['id']!)),
      GoRoute(path: '/habit/:id/edit', builder: (_, s) => EditHabitScreen(habitId: s.pathParameters['id'])),
      GoRoute(path: Routes.reminders, builder: (_, _) => const RemindersScreen()),
      GoRoute(path: Routes.language, builder: (_, _) => const LanguageScreen()),
    ],
  );
}
