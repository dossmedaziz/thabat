import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../features/habits/domain/models.dart';
import '../utils/dates.dart';
import 'gen/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  String get lang => Localizations.localeOf(this).languageCode;
}

/// Formatting helpers. Digits are always Western (0-9) in every language.
extension AppFormat on AppLocalizations {
  String get _lang => localeName.split('_').first;

  DateFormat _df(String pattern) => DateFormat(pattern, _lang)..useNativeDigits = false;

  /// "الثلاثاء، 10 نوفمبر" / "Tuesday, November 10" / "mardi 10 novembre"
  String longDate(DateTime d) => switch (_lang) {
        'ar' => _df('EEEE، d MMMM').format(d),
        'fr' => _capitalize(_df('EEEE d MMMM').format(d)),
        _ => _df('EEEE, MMMM d').format(d),
      };

  /// "9 نوفمبر" / "Nov 9" / "9 nov."
  String shortDate(DateTime d) => switch (_lang) {
        'en' => _df('MMM d').format(d),
        'fr' => _df('d MMM').format(d),
        _ => _df('d MMMM').format(d),
      };

  String fullDate(DateTime d) => switch (_lang) {
        'en' => _df('MMM d, y').format(d),
        _ => _df('d MMMM y').format(d),
      };

  String monthYear(DateTime d) => _capitalize(_df('MMMM y').format(d));
  String monthName(DateTime d) => _capitalize(_df('MMMM').format(d));
  String monthShort(DateTime d) => _lang == 'ar' ? monthName(d) : _capitalize(_df('MMM').format(d));

  /// "9:30 م" / "9:30 PM" / "21:30"
  String time(String hm) {
    final (h, m) = parseHm(hm);
    if (_lang == 'fr') return formatHm(h, m);
    final h12 = h % 12 == 0 ? 12 : h % 12;
    return '$h12:${two(m)} ${h < 12 ? am : pm}';
  }

  String timeOf(DateTime d) => time(formatHm(d.hour, d.minute));

  String weekdayShort(int iso) => switch (iso) {
        1 => wd1,
        2 => wd2,
        3 => wd3,
        4 => wd4,
        5 => wd5,
        6 => wd6,
        _ => wd7,
      };

  String weekdayFull(int iso) => _capitalize(_df('EEEE').format(DateTime(2024, 1, iso))); // 2024-01-01 = Monday

  String weekdaysList(List<int> days, WeekStart ws) {
    if (days.isEmpty || days.length == 7) return everyDay;
    final order = orderedWeekdays(ws);
    final sorted = [...days]..sort((a, b) => order.indexOf(a).compareTo(order.indexOf(b)));
    return sorted.map(weekdayFull).join(_lang == 'ar' ? '، ' : ', ');
  }

  String freq(Frequency f) => switch (f) {
        Frequency.daily => freqDaily,
        Frequency.weekly => freqWeekly,
        Frequency.monthly => freqMonthly,
      };

  /// Streak count in the habit's own period unit ("12 يوم", "4 أسابيع", "3 أشهر").
  String periodCount(int n, Frequency f) => switch (f) {
        Frequency.daily => daysCount(n),
        Frequency.weekly => weeksCount(n),
        Frequency.monthly => monthsCount(n),
      };

  String unitCount(int n, GoalUnit u) => switch (u) {
        GoalUnit.days => daysCount(n),
        GoalUnit.weeks => weeksCount(n),
        GoalUnit.months => monthsCount(n),
      };

  String percent(double ratio) => '${(ratio * 100).round()}%';

  String _capitalize(String s) => s.isEmpty || _lang == 'ar' ? s : s[0].toUpperCase() + s.substring(1);
}
