import '../../features/habits/domain/models.dart';

/// Date helpers. All "days" are local calendar dates at midnight; arithmetic is
/// done with calendar fields so DST changes never shift a day.

DateTime dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime addDays(DateTime d, int n) => DateTime(d.year, d.month, d.day + n);

DateTime addMonths(DateTime d, int n) => DateTime(d.year, d.month + n, 1);

/// Whole calendar days from [a] to [b] (b - a).
int daysBetween(DateTime a, DateTime b) =>
    DateTime.utc(b.year, b.month, b.day).difference(DateTime.utc(a.year, a.month, a.day)).inDays;

String two(int n) => n.toString().padLeft(2, '0');

String dateKey(DateTime d) => '${d.year}-${two(d.month)}-${two(d.day)}';

DateTime parseDateKey(String key) {
  final p = key.split('-');
  return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
}

bool sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

DateTime weekStartOf(DateTime d, WeekStart ws) {
  final day = dayOnly(d);
  final diff = (day.weekday - ws.isoWeekday + 7) % 7;
  return addDays(day, -diff);
}

DateTime periodStart(DateTime d, Frequency f, WeekStart ws) {
  switch (f) {
    case Frequency.daily:
      return dayOnly(d);
    case Frequency.weekly:
      return weekStartOf(d, ws);
    case Frequency.monthly:
      return DateTime(d.year, d.month, 1);
  }
}

DateTime nextPeriodStart(DateTime start, Frequency f) {
  switch (f) {
    case Frequency.daily:
      return addDays(start, 1);
    case Frequency.weekly:
      return addDays(start, 7);
    case Frequency.monthly:
      return DateTime(start.year, start.month + 1, 1);
  }
}

int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

/// ISO weekdays ordered from the configured week start.
List<int> orderedWeekdays(WeekStart ws) =>
    List.generate(7, (i) => ((ws.isoWeekday - 1 + i) % 7) + 1);

/// Parses "HH:mm" → (hour, minute).
(int, int) parseHm(String hm) {
  final p = hm.split(':');
  final h = int.tryParse(p.first) ?? 9;
  final m = p.length > 1 ? int.tryParse(p[1]) ?? 0 : 0;
  return (h.clamp(0, 23), m.clamp(0, 59));
}

String formatHm(int h, int m) => '${two(h)}:${two(m)}';

/// Whether [hm] falls inside the [start]–[end] window (which may wrap midnight).
bool inQuietWindow(String hm, String start, String end) {
  final (h, m) = parseHm(hm);
  final (sh, sm) = parseHm(start);
  final (eh, em) = parseHm(end);
  final t = h * 60 + m, s = sh * 60 + sm, e = eh * 60 + em;
  if (s == e) return false;
  return s < e ? (t >= s && t < e) : (t >= s || t < e);
}
