import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/l10n_x.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/clock.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../habits/application/habits_controller.dart';
import '../../habits/domain/models.dart';
import '../../habits/presentation/habit_actions.dart';
import '../../notifications/notification_service.dart';
import '../../notifications/presentation/reminders_screen.dart';
import '../application/settings_controller.dart';

const appVersion = '1.0';

String languageName(BuildContext context, String code) {
  final l = context.l10n;
  return switch (code) {
    'en' => l.langEnglish,
    'fr' => l.langFrench,
    _ => l.langArabic,
  };
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final data = ref.read(appDataControllerProvider).value!;
      final json = const JsonEncoder.withIndent('  ').convert({
        ...data.toJson(),
        'settings': ref.read(settingsControllerProvider).toJson(),
        'exportedAt': DateTime.now().toIso8601String(),
      });
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/thabat-export-${dateKey(DateTime.now())}.json');
      await file.writeAsString(json);
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path, mimeType: 'application/json')],
        subject: l.exportSubject,
      ));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.exportFailed)));
    }
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await confirmDialog(context, title: l.deleteAccountTitle, body: l.deleteAccountBody, confirm: l.deleteAccountConfirm);
    if (!ok) return;
    try {
      await ref.read(appDataControllerProvider.notifier).deleteAccount();
    } catch (e) {
      debugPrint('Thabat: delete account failed: $e');
      messenger.showSnackBar(SnackBar(content: Text(l.deleteAccountFailed)));
      return;
    }
    await ref.read(notificationServiceProvider).cancelAll();
    await ref.read(settingsControllerProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l = context.l10n;
    final data = ref.watch(appDataControllerProvider).value;
    final s = ref.watch(settingsControllerProvider);
    final ctrl = ref.read(settingsControllerProvider.notifier);
    final user = data?.user;
    final today = ref.watch(todayProvider);
    final habits = ref.watch(habitsProvider);
    final badges = ref.watch(unlockedAchievementsProvider).length;
    final remindersOn = habits.where((h) => h.reminder?.enabled ?? false).length;
    final pending = ref.watch(pendingSyncCountProvider);

    Widget section(String title, List<Widget> rows) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 4, bottom: 8),
              child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: c.sub)),
            ),
            AppCard(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 2),
              child: Column(children: [
                for (var i = 0; i < rows.length; i++) ...[if (i > 0) const Divider(), rows[i]],
              ]),
            ),
          ],
        );

    Widget navRow(String title, String? value, VoidCallback onTap, {String? icon}) => InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Row(
              children: [
                if (icon != null) ...[AppIcon(icon, color: c.text), const SizedBox(width: 12)],
                Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                if (value != null) Text(value, style: TextStyle(fontSize: 14, color: c.sub)),
                const SizedBox(width: 6),
                AppIcon('forward', size: 20, color: c.sub, strokeWidth: 2),
              ],
            ),
          ),
        );

    Widget actionRow(String title, String icon, Color color, VoidCallback onTap) => InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Row(children: [
              AppIcon(icon, color: color),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color))),
            ]),
          ),
        );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 32),
          children: [
            Text(l.profileTitle, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 1.4)),
            const SizedBox(height: 14),
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      UserAvatar(name: user?.name ?? '', photoUrl: user?.photoUrl, size: 60),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.fullName ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(user?.email ?? '', style: TextStyle(fontSize: 13, color: c.sub)),
                            ),
                            const SizedBox(height: 4),
                            Row(children: [
                              const GoogleLogo(size: 14),
                              const SizedBox(width: 6),
                              Flexible(child: Text(l.signedInWithGoogle, style: TextStyle(fontSize: 12, color: c.sub))),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _Pill(l.daysWithUs(l.daysCount(user == null ? 0 : daysBetween(user.joinedAt, today) + 1))),
                      const SizedBox(width: 8),
                      _Pill(l.habitsCount(habits.length)),
                      const SizedBox(width: 8),
                      _Pill(l.badgesCount(badges)),
                    ],
                  ),
                ],
              ),
            ),
            section(l.sectionLanguage, [
              navRow(l.appLanguage, languageName(context, s.locale), () => context.push(Routes.language), icon: 'globe'),
            ]),
            section(l.sectionNotifications, [
              SwitchRow(
                leading: AppIcon('bell', color: c.text),
                title: l.notifications,
                value: s.notificationsEnabled,
                onChanged: (v) async {
                  ctrl.setNotifications(v);
                  if (v) await ref.read(notificationServiceProvider).requestPermission();
                },
              ),
              navRow(l.remindersTitle, l.activeCount('$remindersOn'), () => context.push(Routes.reminders)),
              navRow(l.quietHours, s.quietEnabled ? '${l.time(s.quietStart)} – ${l.time(s.quietEnd)}' : l.quietOff,
                  () => editQuietHours(context, ref)),
            ]),
            section(l.sectionPreferences, [
              navRow(l.weekStart, _weekStartName(context, s.weekStart), () => _pickWeekStart(context, ref)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(child: Text(l.appearance, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                    SizedBox(
                      width: 210,
                      child: Segmented<ThemeMode>(
                        value: s.themeMode,
                        height: 36,
                        items: [
                          (ThemeMode.light, l.themeLight, null),
                          (ThemeMode.dark, l.themeDark, null),
                          (ThemeMode.system, l.themeSystem, null),
                        ],
                        onChanged: ctrl.setThemeMode,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            section(l.sectionData, [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(children: [
                  AppIcon(pending == 0 ? 'check' : 'clock', color: pending == 0 ? c.goodText : c.flame, strokeWidth: 2),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(pending == 0 ? l.syncedAll : l.pendingSync('$pending'),
                        style: TextStyle(fontSize: 14, color: pending == 0 ? c.sub : c.text)),
                  ),
                ]),
              ),
              actionRow(l.exportData, 'download', c.text, () => _export(context, ref)),
              actionRow(l.seedData, 'plus', c.goodText, () {
                ref.read(appDataControllerProvider.notifier).addSampleData(l);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.seedDone)));
              }),
              actionRow(l.signOut, 'logout', c.text, () => ref.read(appDataControllerProvider.notifier).signOut()),
              actionRow(l.deleteAccount, 'trash', c.badText, () => _deleteAccount(context, ref)),
            ]),
            const SizedBox(height: 20),
            Text(l.versionLine(appVersion), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: c.faint)),
          ],
        ),
      ),
    );
  }

  String _weekStartName(BuildContext context, WeekStart w) {
    final l = context.l10n;
    return switch (w) {
      WeekStart.monday => l.monday,
      WeekStart.saturday => l.saturday,
      WeekStart.sunday => l.sunday,
    };
  }

  void _pickWeekStart(BuildContext context, WidgetRef ref) {
    final cur = ref.read(settingsControllerProvider).weekStart;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: RadioGroup<WeekStart>(
          groupValue: cur,
          onChanged: (v) {
            if (v != null) ref.read(settingsControllerProvider.notifier).setWeekStart(v);
            Navigator.pop(ctx);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final w in WeekStart.values) RadioListTile<WeekStart>(value: w, title: Text(_weekStartName(context, w))),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(color: c.chip, borderRadius: BorderRadius.circular(12)),
        child: Text(text, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
