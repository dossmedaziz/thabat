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
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/chips.dart';
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

    final t = context.text;

    Widget group(String? label, List<Widget> rows) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 22),
            if (label != null) FieldLabel(label),
            GroupedCard(children: rows),
          ],
        );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(AppSpacing.gutter, 16, AppSpacing.gutter, 32),
          children: [
            Text(l.profileTitle, style: t.title),
            const SizedBox(height: 18),
            // ---- account card ----
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: c.avatarBg, width: 2)),
                        child: UserAvatar(name: user?.name ?? '', photoUrl: user?.photoUrl, size: 58),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.fullName ?? '', style: t.sheetTitle.copyWith(fontSize: 19)),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(user?.email ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: t.bodyMedium.copyWith(color: c.sub)),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: c.field, borderRadius: AppRadii.pillAll),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                if (user?.provider == 'email')
                                  AppIcon('mail', size: 14, color: c.sub, strokeWidth: 2)
                                else
                                  const GoogleLogo(size: 14),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(user?.provider == 'email' ? l.signedInWithEmail : l.signedInWithGoogle,
                                      style: t.caption.copyWith(fontWeight: FontWeight.w600, color: c.textSecondary, height: 1.2)),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
            // ---- language & appearance: inline segmented controls ----
            const SizedBox(height: 22),
            FieldLabel(l.sectionLanguage),
            Segmented<String>(
              value: s.locale,
              semanticLabel: l.appLanguage,
              items: [('ar', l.langArabic, null), ('fr', l.langFrench, null), ('en', l.langEnglish, null)],
              onChanged: ctrl.setLocale,
            ),
            const SizedBox(height: 22),
            FieldLabel(l.appearance),
            Segmented<ThemeMode>(
              value: s.themeMode,
              semanticLabel: l.appearance,
              items: [
                (ThemeMode.dark, l.themeDark, null),
                (ThemeMode.light, l.themeLight, null),
                (ThemeMode.system, l.themeSystem, null),
              ],
              onChanged: ctrl.setThemeMode,
            ),
            // ---- notifications ----
            group(l.sectionNotifications, [
              Padding(
                padding: const EdgeInsetsDirectional.only(start: AppSpacing.rowHorizontal, end: 8),
                child: SwitchRow(
                  leading: _IconCircle('bell', fg: c.lilac, bg: c.lilacBg),
                  title: l.notifications,
                  value: s.notificationsEnabled,
                  onChanged: (v) async {
                    ctrl.setNotifications(v);
                    if (v) await ref.read(notificationServiceProvider).requestPermission();
                  },
                ),
              ),
              NavRow(
                icon: 'clock',
                iconFg: c.flame,
                iconBg: c.flameFill,
                title: l.remindersTitle,
                value: l.activeCount('$remindersOn'),
                onTap: () => context.push(Routes.reminders),
              ),
              NavRow(
                icon: 'moonQuiet',
                iconFg: c.avatarFg,
                iconBg: c.avatarBg,
                title: l.quietHours,
                value: s.quietEnabled ? '${l.time(s.quietStart)} – ${l.time(s.quietEnd)}' : l.quietOff,
                onTap: () => editQuietHours(context, ref),
              ),
            ]),
            group(l.sectionPreferences, [
              NavRow(
                icon: 'calendar',
                iconFg: c.goodText,
                iconBg: c.goodSoft,
                title: l.weekStart,
                value: _weekStartName(context, s.weekStart),
                onTap: () => _pickWeekStart(context, ref),
              ),
            ]),
            group(l.sectionData, [
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.rowHorizontal, vertical: AppSpacing.rowVertical),
                child: Row(children: [
                  _IconCircle(pending == 0 ? 'check' : 'clock',
                      fg: pending == 0 ? c.goodText : c.flame, bg: pending == 0 ? c.goodSoft : c.flameFill),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(pending == 0 ? l.syncedAll : l.pendingSync('$pending'),
                        style: t.bodyMedium.copyWith(color: pending == 0 ? c.sub : c.text)),
                  ),
                ]),
              ),
              NavRow(icon: 'download', title: l.exportData, onTap: () => _export(context, ref)),
              NavRow(
                icon: 'plus',
                iconFg: c.lilac,
                iconBg: c.lilacBg,
                title: l.seedData,
                onTap: () {
                  ref.read(appDataControllerProvider.notifier).addSampleData(l);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.seedDone)));
                },
              ),
            ]),
            const SizedBox(height: 22),
            AppButton(
              label: l.signOut,
              icon: 'logout',
              variant: AppButtonVariant.danger,
              onPressed: () => ref.read(appDataControllerProvider.notifier).signOut(),
            ),
            const SizedBox(height: 6),
            Center(
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: c.badText),
                onPressed: () => _deleteAccount(context, ref),
                child: Text(l.deleteAccount),
              ),
            ),
            const SizedBox(height: 16),
            Text(l.versionLine(appVersion), textAlign: TextAlign.center, style: t.caption.copyWith(color: c.faint)),
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
    showAppBottomSheet<void>(
      context: context,
      builder: (ctx) => Consumer(builder: (ctx, ref, _) {
        final cur = ref.watch(settingsControllerProvider).weekStart;
        return AppBottomSheet(
          title: context.l10n.weekStart,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final w in WeekStart.values) ...[
                PickerPill(
                  label: _weekStartName(context, w),
                  selected: w == cur,
                  onTap: () {
                    ref.read(settingsControllerProvider.notifier).setWeekStart(w);
                    Navigator.pop(ctx);
                  },
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        );
      }),
    );
  }
}

/// Tinted round icon (44) used at the start of settings rows.
class _IconCircle extends StatelessWidget {
  const _IconCircle(this.icon, {required this.fg, required this.bg});
  final String icon;
  final Color fg, bg;
  @override
  Widget build(BuildContext context) => Container(
        width: AppSizes.rowIcon,
        height: AppSizes.rowIcon,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: AppIcon(icon, size: 20, color: fg, strokeWidth: 1.9),
      );
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
        decoration: BoxDecoration(color: c.field, borderRadius: AppRadii.pillAll),
        child: Text(text, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: context.text.caption.copyWith(fontWeight: FontWeight.w600, color: c.textSecondary, height: 1.3)),
      ),
    );
  }
}
