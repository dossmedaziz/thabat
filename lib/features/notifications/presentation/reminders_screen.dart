import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_x.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/common.dart';
import '../../habits/application/habits_controller.dart';
import '../../habits/domain/models.dart';
import '../../habits/presentation/habit_actions.dart';
import '../../settings/application/settings_controller.dart';
import '../notification_service.dart';

Future<String?> pickTime(BuildContext context, String hm) async {
  final (h, m) = parseHm(hm);
  final t = await showTimePicker(context: context, initialTime: TimeOfDay(hour: h, minute: m));
  return t == null ? null : formatHm(t.hour, t.minute);
}

/// Quiet hours editor (shared with Settings).
Future<void> editQuietHours(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  await showAppBottomSheet<void>(
    context: context,
    builder: (ctx) => Consumer(builder: (ctx, ref, _) {
      final s = ref.watch(settingsControllerProvider);
      final ctrl = ref.read(settingsControllerProvider.notifier);
      Widget timeRow(String label, String hm, ValueChanged<String> set) => Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TimeRow(
              label: label,
              value: l.time(hm),
              onTap: () async {
                final t = await pickTime(ctx, hm);
                if (t != null) set(t);
              },
            ),
          );
      return AppBottomSheet(
        title: l.quietHours,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
                child: SwitchRow(title: l.quietHours, value: s.quietEnabled, onChanged: (v) => ctrl.setQuiet(enabled: v)),
              ),
              if (s.quietEnabled) ...[
                timeRow(l.quietStart, s.quietStart, (t) => ctrl.setQuiet(start: t)),
                timeRow(l.quietEnd, s.quietEnd, (t) => ctrl.setQuiet(end: t)),
              ],
            ],
          ),
        ),
      );
    }),
  );
}

class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l = context.l10n;
    final habits = ref.watch(habitsProvider);
    final s = ref.watch(settingsControllerProvider);
    final ctrl = ref.read(settingsControllerProvider.notifier);
    final withReminder = habits.where((h) => h.reminder != null).toList();
    final on = habits.where((h) => h.reminder?.enabled ?? false).length;

    void toggle(Habit h, bool v) async {
      final r = h.reminder ?? const HabitReminder();
      ref.read(appDataControllerProvider.notifier).upsertHabit(h.copyWith(reminder: r.copyWith(enabled: v)));
      if (v) await ref.read(notificationServiceProvider).requestPermission();
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 32),
          children: [
            Row(children: [
              RoundIconButton(icon: 'back', tooltip: l.back, onTap: () => context.canPop() ? context.pop() : context.go(Routes.profile)),
            ]),
            const SizedBox(height: 12),
            Text(l.remindersTitle, style: context.text.title),
            Text(l.remindersActive('$on', '${habits.length}'), style: TextStyle(fontSize: 14, color: c.sub)),
            if (!s.notificationsEnabled) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: c.badSoft, borderRadius: BorderRadius.circular(14)),
                child: Text(l.notificationsOffBanner, style: TextStyle(color: c.badText, fontWeight: FontWeight.w600)),
              ),
            ],
            const SizedBox(height: 16),
            const _NotificationStatusCard(),
            const SizedBox(height: 12),
            AppCard(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 12, 4),
              child: Column(
                children: [
                  SwitchRow(
                    leading: AppIcon('flame', color: c.flame, fill: c.flameFill, strokeWidth: 2),
                    title: l.streakRiskTitle,
                    subtitle: l.streakRiskSub(l.time(s.streakRiskTime)),
                    value: s.streakRiskEnabled,
                    onChanged: (v) async {
                      ctrl.setStreakRisk(v);
                      if (v) await ref.read(notificationServiceProvider).requestPermission();
                    },
                  ),
                  if (s.streakRiskEnabled)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TimeRow(
                        label: l.streakRiskTime,
                        value: l.time(s.streakRiskTime),
                        onTap: () async {
                          final t = await pickTime(context, s.streakRiskTime);
                          if (t != null) ctrl.setStreakRiskTime(t);
                        },
                      ),
                    ),
                  const Divider(),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => editQuietHours(context, ref),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 60),
                      child: Row(
                        children: [
                          AppIcon('moonQuiet', color: c.text),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(l.quietHours, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                Text(s.quietEnabled ? l.quietSub(l.time(s.quietStart), l.time(s.quietEnd)) : l.quietOff,
                                    style: TextStyle(fontSize: 13, color: c.sub)),
                              ],
                            ),
                          ),
                          AppIcon('forward', size: 20, color: c.sub, strokeWidth: 2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SectionTitle(l.scheduledReminders),
            const SizedBox(height: 10),
            if (withReminder.isEmpty)
              AppCard(child: Text(l.noReminders, style: TextStyle(color: c.sub)))
            else
              for (final h in withReminder)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 10, 12),
                    onTap: () => context.push(Routes.editHabit(h.id)),
                    child: Row(
                      children: [
                        habitTileFor(context, h, size: 44),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(h.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              Text('${l.time(h.reminder!.time)} · ${l.weekdaysList(h.reminder!.weekdays, s.weekStart)}',
                                  style: TextStyle(fontSize: 13, color: c.sub)),
                              Text(
                                '«${(h.reminder!.message?.isNotEmpty ?? false) ? h.reminder!.message : (h.isGood ? l.reminderDefaultGood(h.name) : l.reminderDefaultBad(h.name))}»',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12, color: c.faint),
                              ),
                            ],
                          ),
                        ),
                        Semantics(
                          label: l.toggleReminderA11y(h.name),
                          child: Switch(value: h.reminder!.enabled, onChanged: (v) => toggle(h, v)),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}


/// Shows whether the OS lets Thabat notify, whether timing is exact, and a test button.
class _NotificationStatusCard extends ConsumerStatefulWidget {
  const _NotificationStatusCard();
  @override
  ConsumerState<_NotificationStatusCard> createState() => _NotificationStatusCardState();
}

class _NotificationStatusCardState extends ConsumerState<_NotificationStatusCard> with WidgetsBindingObserver {
  bool? _granted;
  bool _exact = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Re-check when the user comes back from the system settings screen.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  Future<void> _check() async {
    final n = ref.read(notificationServiceProvider);
    final granted = await n.permissionGranted();
    final exact = await n.exactAlarmsAllowed();
    if (mounted) {
      setState(() {
        _granted = granted;
        _exact = exact;
      });
    }
  }

  Future<void> _allow() async {
    final n = ref.read(notificationServiceProvider);
    final ok = await n.requestPermission();
    // Once denied twice, Android stops showing the prompt: send the user to settings.
    if (!ok) await n.openSystemSettings();
    await _check();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final n = ref.read(notificationServiceProvider);
    final granted = _granted;
    if (granted == null) return const SizedBox.shrink();
    return AppCard(
      color: granted ? null : c.badSoft,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            AppIcon(granted ? 'check' : 'bell', color: granted ? c.goodText : c.badText, strokeWidth: 2.2),
            const SizedBox(width: 10),
            Expanded(
              child: Text(granted ? l.notifAllowed : l.notifBlocked,
                  style: TextStyle(fontWeight: FontWeight.w600, color: granted ? c.text : c.badText)),
            ),
          ]),
          if (granted)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 34, top: 2),
              child: Text(l.scheduledCount('${n.lastScheduled}'), style: TextStyle(fontSize: 13, color: c.sub)),
            ),
          const SizedBox(height: 10),
          if (!granted)
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: c.bad, foregroundColor: c.onBad),
              onPressed: _allow,
              child: Text(l.allowNotifications),
            )
          else ...[
            if (!_exact) ...[
              Text(l.exactAlarmsOff, style: TextStyle(fontSize: 13, color: c.sub)),
              TextButton(
                onPressed: () async {
                  await n.requestExactAlarms();
                  await _check();
                  ref.invalidate(reminderSyncProvider); // reschedule with exact timing
                },
                child: Text(l.exactAlarmsAllow),
              ),
            ],
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(44, 48),
                foregroundColor: c.text,
                side: BorderSide(color: c.line, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => n.showTest(l),
              icon: AppIcon('bell', size: 18, color: c.text, strokeWidth: 2),
              label: Text(l.testNotification),
            ),
          ],
        ],
      ),
    );
  }
}


/// Label with a time pill on a field background (tap to change).
class TimeRow extends StatelessWidget {
  const TimeRow({super.key, required this.label, required this.value, required this.onTap});
  final String label, value;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Pressable(
      onTap: onTap,
      semanticLabel: '$label, $value',
      scale: .98,
      child: Row(
        children: [
          Expanded(child: Text(label, style: context.text.body)),
          Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: c.field, borderRadius: AppRadii.pillAll),
            child: Text(value, style: context.text.body.copyWith(fontWeight: FontWeight.w700, height: 1.2)),
          ),
        ],
      ),
    );
  }
}
