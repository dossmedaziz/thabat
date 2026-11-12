import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/l10n/l10n_x.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/chips.dart';
import '../../../core/widgets/common.dart';
import '../../notifications/notification_service.dart';
import '../../notifications/presentation/reminders_screen.dart';
import '../../settings/application/settings_controller.dart';
import '../application/habits_controller.dart';
import '../domain/models.dart';
import 'habit_actions.dart';

const _emojis = [
  '💧', '📚', '🏃', '🧘', '💪', '🥗', '🍎', '😴', '🙏', '✍️', '🎯', '🌱',
  '🚭', '📱', '🍔', '🥤', '🍬', '☕', '🎮', '💸', '🍺', '🛌', '⏰', '❤️',
];

class EditHabitScreen extends ConsumerStatefulWidget {
  const EditHabitScreen({super.key, this.habitId, this.initialType = HabitType.good, this.preset});
  final String? habitId;
  final HabitType initialType;
  final String? preset;

  @override
  ConsumerState<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends ConsumerState<EditHabitScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _note = TextEditingController();
  final _message = TextEditingController();

  Habit? _original;
  HabitType _type = HabitType.good;
  String _glyph = 'icon:target';
  String _color = HabitPalette.goodDefault;
  Frequency _freq = Frequency.daily;
  bool _weeklyDays = false;
  int _times = 3;
  Set<int> _days = {6, 1, 3};
  HabitGoal? _goal;
  bool _remOn = false;
  String _remTime = '09:00';
  Set<int> _remDays = {1, 2, 3, 4, 5, 6, 7};
  bool _emojiTab = false;
  bool _showErrors = false;
  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    final l = context.l10n;
    final h = widget.habitId == null ? null : ref.read(habitByIdProvider(widget.habitId!));
    if (h != null) {
      _original = h;
      _type = h.type;
      _name.text = h.name;
      _note.text = h.note ?? '';
      _glyph = h.emoji;
      _color = h.colorHex;
      _freq = h.frequency;
      _weeklyDays = h.frequency == Frequency.weekly && h.weekdays.isNotEmpty;
      _times = h.frequency == Frequency.daily ? 3 : h.targetPerPeriod;
      if (h.weekdays.isNotEmpty) _days = h.weekdays.toSet();
      _goal = h.goal;
      final r = h.reminder;
      if (r != null) {
        _remOn = r.enabled;
        _remTime = r.time;
        _remDays = r.weekdays.isEmpty ? {1, 2, 3, 4, 5, 6, 7} : r.weekdays.toSet();
        _message.text = r.message ?? '';
      }
    } else {
      _type = widget.initialType;
      _applyTypeDefaults();
      switch (widget.preset) {
        case 'water':
          _name.text = l.seedWater;
          _glyph = 'icon:water';
          _color = '#93C5FD';
        case 'read':
          _name.text = l.seedRead;
          _glyph = 'icon:read';
        case 'soda':
          _type = HabitType.bad;
          _name.text = l.seedSoda;
          _glyph = 'icon:soda';
          _color = HabitPalette.badDefault;
      }
    }
  }

  void _applyTypeDefaults() {
    final good = _type == HabitType.good;
    _glyph = good ? 'icon:target' : 'icon:ban';
    _color = good ? HabitPalette.goodDefault : HabitPalette.badDefault;
    _goal = null;
  }

  @override
  void dispose() {
    _name.dispose();
    _note.dispose();
    _message.dispose();
    super.dispose();
  }

  bool get _good => _type == HabitType.good;

  List<HabitGoal> _goalOptions() {
    HabitGoal g(int v, GoalUnit u) => HabitGoal(kind: GoalKind.streak, value: v, unit: u);
    final opts = !_good
        ? [g(1, GoalUnit.weeks), g(1, GoalUnit.months), g(3, GoalUnit.months), g(12, GoalUnit.months)]
        : switch (_freq) {
            Frequency.daily => [g(7, GoalUnit.days), g(21, GoalUnit.days), g(30, GoalUnit.days), g(66, GoalUnit.days)],
            Frequency.weekly => [g(4, GoalUnit.weeks), g(8, GoalUnit.weeks), g(12, GoalUnit.weeks), g(26, GoalUnit.weeks)],
            Frequency.monthly => [g(3, GoalUnit.months), g(6, GoalUnit.months), g(9, GoalUnit.months), g(12, GoalUnit.months)],
          };
    if (_goal != null && !opts.contains(_goal)) opts.add(_goal!);
    return opts;
  }

  Future<void> _toggleReminder(bool v) async {
    setState(() => _remOn = v);
    if (!v) return;
    final ok = await ref.read(notificationServiceProvider).requestPermission();
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.permissionDenied)));
    }
  }

  Future<void> _pickTime() async {
    final (h, m) = parseHm(_remTime);
    final t = await showTimePicker(context: context, initialTime: TimeOfDay(hour: h, minute: m));
    if (t != null) setState(() => _remTime = formatHm(t.hour, t.minute));
  }

  void _save() {
    setState(() => _showErrors = true);
    final okForm = _form.currentState?.validate() ?? false;
    final daysOk = !(_freq == Frequency.weekly && _weeklyDays && _days.isEmpty) && !(_remOn && _remDays.isEmpty);
    if (!okForm || !daysOk) return;

    final now = DateTime.now();
    final weekdays = _freq == Frequency.weekly && _weeklyDays ? (_days.toList()..sort()) : <int>[];
    final target = switch (_freq) {
      Frequency.daily => 1,
      Frequency.weekly => _weeklyDays ? weekdays.length : _times,
      Frequency.monthly => _times,
    };
    final base = _original ??
        Habit(
          id: const Uuid().v4(),
          type: _type,
          name: '',
          createdAt: now,
          updatedAt: now,
        );
    final h = base.copyWith(
      type: _type,
      name: _name.text.trim(),
      emoji: _glyph,
      colorHex: _color,
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      frequency: _freq,
      targetPerPeriod: target,
      weekdays: weekdays,
      goal: _goal,
      reminder: HabitReminder(
        enabled: _remOn,
        time: _remTime,
        weekdays: _remDays.length == 7 ? const [] : (_remDays.toList()..sort()),
        message: _message.text.trim().isEmpty ? null : _message.text.trim(),
      ),
      updatedAt: now,
    );
    ref.read(appDataControllerProvider.notifier).upsertHabit(h);
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.today);
    }
  }

  Future<void> _delete() async {
    final h = _original!;
    final l = context.l10n;
    final ok = await confirmDialog(context, title: l.deleteConfirmTitle(h.name), body: l.deleteConfirmBody, confirm: l.delete);
    if (!ok || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final ctrl = ref.read(appDataControllerProvider.notifier);
    final removed = ctrl.deleteHabit(h.id);
    context.go(Routes.today);
    if (removed != null) {
      messenger.showSnackBar(SnackBar(
        content: Text(l.deletedSnack(h.name)),
        action: SnackBarAction(label: l.undo, onPressed: () => ctrl.restoreHabit(removed)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final ws = ref.watch(settingsControllerProvider).weekStart;
    final settings = ref.watch(settingsControllerProvider);
    final accent = _good ? c.good : c.bad;
    final onAccent = _good ? c.onGood : c.onBad;
    final palette = HabitPalette.fromHex(_color);
    final (tileBg, tileFg) = palette.tile(context.isDark);
    final order = orderedWeekdays(ws);

    Widget label(String t, {String? extra}) => Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 8, start: 2),
          child: Text.rich(TextSpan(children: [
            TextSpan(text: t, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            if (extra != null) TextSpan(text: ' $extra', style: TextStyle(fontSize: 13, color: c.sub)),
          ])),
        );

    Widget dayChips(Set<int> sel, ValueChanged<Set<int>> onChange) => Row(
          children: [
            for (final d in order)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Semantics(
                    button: true,
                    selected: sel.contains(d),
                    label: l.weekdayFull(d),
                    excludeSemantics: true,
                    child: GestureDetector(
                      onTap: () => onChange(sel.contains(d) ? ({...sel}..remove(d)) : {...sel, d}),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: sel.contains(d) ? accent : c.field, borderRadius: BorderRadius.circular(12)),
                        child: Text(l.weekdayShort(d),
                            style: TextStyle(fontWeight: FontWeight.w700, color: sel.contains(d) ? onAccent : c.sub)),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );

    Widget stepper(String text) => Container(
          decoration: BoxDecoration(color: c.field, borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              _StepBtn(icon: 'minus', label: l.less, onTap: _times > 1 ? () => setState(() => _times--) : null),
              Expanded(
                child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              _StepBtn(
                icon: 'plus',
                label: l.more,
                onTap: _times < (_freq == Frequency.weekly ? 7 : 31) ? () => setState(() => _times++) : null,
              ),
            ],
          ),
        );

    final previewBody = _message.text.trim().isNotEmpty
        ? _message.text.trim()
        : (_good ? l.reminderDefaultGood(_name.text.trim()) : l.reminderDefaultBad(_name.text.trim()));
    final quiet = settings.quietEnabled && inQuietWindow(_remTime, settings.quietStart, settings.quietEnd);

    return Scaffold(
      backgroundColor: c.card,
      body: SafeArea(
        child: Column(
          children: [
            // Sheet-style header (Cashflow): close · title · delete.
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 8),
              child: SheetHeader(
                title: _original == null ? l.newHabit : l.editHabit,
                onClose: () => context.canPop() ? context.pop() : context.go(Routes.today),
                trailing: _original == null
                    ? null
                    : CircleIconButton(icon: 'trash', style: CircleButtonStyle.danger, iconSize: 18, semanticLabel: l.deleteHabit, onPressed: _delete),
              ),
            ),
            Expanded(
              child: Form(
        key: _form,
        autovalidateMode: _showErrors ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 24),
          children: [
            // ---- type ----
            Segmented<HabitType>(
              value: _type,
              trackColor: c.field,
              items: [(HabitType.good, l.typeGoodTitle, c.good), (HabitType.bad, l.typeBadTitle, c.bad)],
              onChanged: (t) => setState(() {
                _type = t;
                _applyTypeDefaults();
              }),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 8, start: 6),
              child: Text(_good ? l.typeGoodSub : l.typeBadSub, style: context.text.subtitle),
            ),
            const SizedBox(height: 20),
            // ---- name ----
            label(l.nameLabel),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HabitTile(glyph: _glyph, bg: tileBg, fg: tileFg, size: 52),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _name,
                    maxLength: 40,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(hintText: _good ? l.nameHintGood : l.nameHintBad, counterText: ''),
                    validator: (v) {
                      final t = v?.trim() ?? '';
                      if (t.isEmpty) return l.nameRequired;
                      if (t.length > 40) return l.nameTooLong;
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // ---- icon ----
            Row(
              children: [
                Expanded(child: label(l.iconLabel)),
                SizedBox(
                  width: 200,
                  child: Segmented<bool>(
                    value: _emojiTab,
                    height: 34,
                    trackColor: c.field,
                    items: [(false, l.iconsTab, null), (true, l.emojiTab, null)],
                    onChanged: (v) => setState(() => _emojiTab = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final g in _emojiTab ? _emojis : AppIcons.habitIcons.map((e) => 'icon:$e'))
                  Semantics(
                    button: true,
                    selected: g == _glyph,
                    label: g.startsWith('icon:') ? g.substring(5) : g,
                    excludeSemantics: true,
                    child: GestureDetector(
                      onTap: () => setState(() => _glyph = g),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: g == _glyph ? tileBg : c.field,
                          shape: BoxShape.circle,
                          border: Border.all(color: g == _glyph ? tileFg : Colors.transparent, width: 1.5),
                        ),
                        child: HabitGlyph(g, size: 22, color: g == _glyph ? tileFg : c.sub),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            // ---- color ----
            label(l.colorLabel),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final p in HabitPalette.all)
                  Padding(
                    padding: EdgeInsetsDirectional.zero,
                    child: Semantics(
                      button: true,
                      selected: p.hex == palette.hex,
                      label: _colorName(context, p.id),
                      excludeSemantics: true,
                      child: GestureDetector(
                        onTap: () => setState(() => _color = p.hex),
                        child: Container(
                          width: 44,
                          height: 44,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: p.hex == palette.hex ? c.text : Colors.transparent, width: 2),
                          ),
                          child: DecoratedBox(decoration: BoxDecoration(color: p.dot, shape: BoxShape.circle)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            // ---- frequency ----
            label(l.frequencyLabel),
            Segmented<Frequency>(
              value: _freq,
              trackColor: c.field,
              items: [
                (Frequency.daily, l.freqDaily, null),
                (Frequency.weekly, l.freqWeekly, null),
                (Frequency.monthly, l.freqMonthly, null),
              ],
              onChanged: (f) => setState(() {
                _freq = f;
                if (_good) _goal = null;
                if (f == Frequency.monthly && _times > 4) _times = 1;
              }),
            ),
            if (_freq == Frequency.weekly) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _ChoicePill(label: l.weeklyTimes, on: !_weeklyDays, onTap: () => setState(() => _weeklyDays = false))),
                  const SizedBox(width: 8),
                  Expanded(child: _ChoicePill(label: l.weeklyDays, on: _weeklyDays, onTap: () => setState(() => _weeklyDays = true))),
                ],
              ),
              const SizedBox(height: 12),
              if (_weeklyDays) ...[
                dayChips(_days, (s) => setState(() => _days = s)),
                if (_showErrors && _days.isEmpty) _ErrorText(l.pickDaysError),
              ] else
                stepper('${l.timesCount(_times)} ${l.perWeek}'),
            ],
            if (_freq == Frequency.monthly) ...[
              const SizedBox(height: 12),
              stepper('${l.timesCount(_times)} ${l.perMonth}'),
            ],
            const SizedBox(height: 20),
            // ---- goal ----
            label(l.goalLabel, extra: _good ? l.goalHelpGood : l.goalHelpBad),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ChoicePill(label: l.goalNone, on: _goal == null, onTap: () => setState(() => _goal = null), expand: false),
                for (final g in _goalOptions())
                  _ChoicePill(
                    label: l.unitCount(g.value, g.unit),
                    on: _goal == g,
                    onTap: () => setState(() => _goal = g),
                    expand: false,
                    accent: accent,
                    onAccent: onAccent,
                  ),
              ],
            ),
            const SizedBox(height: 20),
            // ---- reminder ----
            AppCard(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 12, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SwitchRow(
                    leading: AppIcon('bell', color: c.text, size: 22),
                    title: l.reminderLabel,
                    value: _remOn,
                    onChanged: _toggleReminder,
                  ),
                  if (_remOn) ...[
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: TimeRow(label: l.reminderTime, value: l.time(_remTime), onTap: _pickTime),
                    ),
                    if (quiet) _ErrorText(l.reminderQuietWarning, color: c.sub),
                    const SizedBox(height: 8),
                    Text(l.reminderDays, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    dayChips(_remDays, (s) => setState(() => _remDays = s)),
                    if (_showErrors && _remDays.isEmpty) _ErrorText(l.pickDaysError),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _message,
                      maxLength: 120,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(labelText: l.reminderMessage, counterText: ''),
                    ),
                    const SizedBox(height: 12),
                    Text(l.reminderPreview, style: TextStyle(fontSize: 13, color: c.sub, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    _NotificationPreview(title: _name.text.trim().isEmpty ? l.appName : _name.text.trim(), body: previewBody, time: l.time(_remTime)),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            // ---- note ----
            label(l.noteLabel, extra: l.optional),
            TextField(controller: _note, minLines: 3, maxLines: 5, maxLength: 300, decoration: const InputDecoration(counterText: '')),
            const SizedBox(height: 24),
            AppButton(
              label: _original == null ? l.createHabit : l.saveChanges,
              icon: _original == null ? 'plus' : 'check',
              onPressed: _save,
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

String _colorName(BuildContext context, String id) {
  final l = context.l10n;
  return switch (id) {
    'green' => l.colorGreen,
    'teal' => l.colorTeal,
    'blue' => l.colorBlue,
    'violet' => l.colorPurple,
    'pink' => l.colorPink,
    'red' => l.colorRed,
    'orange' => l.colorOrange,
    _ => l.colorYellow,
  };
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({required this.label, required this.on, required this.onTap, this.expand = true, this.accent, this.onAccent});
  final String label;
  final bool on, expand;
  final VoidCallback onTap;
  final Color? accent, onAccent;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final a = accent ?? c.primary;
    return PickerPill(
      label: label,
      selected: on,
      onTap: onTap,
      expand: expand,
      tone: HabitTone(fg: a, bg: a.withValues(alpha: .14), selectedBg: a.withValues(alpha: context.isDark ? .18 : .12)),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.label, required this.onTap});
  final String icon, label;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: c.card,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Center(child: AppIcon(icon, size: 20, color: onTap == null ? c.faint : c.text, strokeWidth: 2.4)),
          ),
        ),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.text, {this.color});
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(top: 6, start: 4),
        child: Text(text, style: TextStyle(fontSize: 12, color: color ?? context.colors.badText)),
      );
}

class _NotificationPreview extends StatelessWidget {
  const _NotificationPreview({required this.title, required this.body, required this.time});
  final String title, body, time;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: c.field, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: c.goodBtn, borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: AppIcon('logo', size: 24, color: c.onGood),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700))),
                    Text(time, style: TextStyle(fontSize: 12, color: c.sub)),
                  ],
                ),
                Text(body, style: TextStyle(fontSize: 14, color: c.sub)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
