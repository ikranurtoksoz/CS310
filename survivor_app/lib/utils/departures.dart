/// A upcoming departure: its "HH:mm" label and minutes until it leaves.
class Departure {
  const Departure(this.label, this.minutesAway);
  final String label;
  final int minutesAway;
}

/// Returns up to [count] departures from [times] ("HH:mm", any order) that
/// leave at or after [now]. Seconds are ignored so a 17:30 bus still counts
/// as "in 0 min" during 17:30.
List<Departure> nextDepartures(
  List<String> times,
  DateTime now, {
  int count = 2,
}) {
  final nowMinutes = now.hour * 60 + now.minute;
  final upcoming = <Departure>[];
  for (final t in times) {
    final parts = t.split(':');
    final minutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
    if (minutes >= nowMinutes) upcoming.add(Departure(t, minutes - nowMinutes));
  }
  upcoming.sort((a, b) => a.minutesAway.compareTo(b.minutesAway));
  return upcoming.take(count).toList();
}

/// "in 42 min", "in 1 h 5 min", or "now".
String formatMinutes(int minutes) {
  if (minutes <= 0) return 'now';
  if (minutes < 60) return 'in $minutes min';
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m == 0 ? 'in $h h' : 'in $h h $m min';
}
