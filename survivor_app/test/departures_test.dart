import 'package:flutter_test/flutter_test.dart';

import 'package:survivor_app/utils/departures.dart';

void main() {
  const times = ['18:30', '07:30', '17:30', '22:00'];

  test('returns the next two departures in time order', () {
    final r = nextDepartures(times, DateTime(2026, 11, 18, 16, 48));
    expect(r.map((d) => d.label), ['17:30', '18:30']);
    expect(r.first.minutesAway, 42);
  });

  test('departure at the current minute counts as now', () {
    final r = nextDepartures(times, DateTime(2026, 11, 18, 17, 30, 45));
    expect(r.first.label, '17:30');
    expect(r.first.minutesAway, 0);
  });

  test('returns an empty list after the last departure', () {
    expect(nextDepartures(times, DateTime(2026, 11, 18, 23, 0)), isEmpty);
  });

  test('formats minutes', () {
    expect(formatMinutes(0), 'now');
    expect(formatMinutes(42), 'in 42 min');
    expect(formatMinutes(60), 'in 1 h');
    expect(formatMinutes(65), 'in 1 h 5 min');
  });
}
