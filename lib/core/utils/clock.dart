import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dates.dart';

part 'clock.g.dart';

/// Today's local date; rolls over at midnight and when [refresh] is called (app resume).
@Riverpod(keepAlive: true)
class Today extends _$Today {
  Timer? _timer;

  @override
  DateTime build() {
    ref.onDispose(() => _timer?.cancel());
    _schedule();
    return dayOnly(DateTime.now());
  }

  void _schedule() {
    _timer?.cancel();
    final now = DateTime.now();
    final next = addDays(dayOnly(now), 1).add(const Duration(seconds: 2));
    _timer = Timer(next.difference(now), refresh);
  }

  void refresh() {
    final d = dayOnly(DateTime.now());
    if (d != state) state = d;
    _schedule();
  }
}
