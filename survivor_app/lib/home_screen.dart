import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/departures.dart';
import '../widgets/wire.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.userName,
    required this.onSeeAllDepartures,
    required this.onSeeFullMenus,
  });

  final String userName;
  final VoidCallback onSeeAllDepartures;
  final VoidCallback onSeeFullMenus;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _Meal {
  const _Meal(this.place, this.items);
  final String place;
  final String items;
}

class _HomeScreenState extends State<HomeScreen> {
  // Sample data until Firestore integration.
  static const _meals = [
    _Meal('Yemekhane', 'Mercimek çorba, Tavuk sote ... 95 TL'),
    _Meal('Küçükev', 'Tost, Ayran ... from 60 TL'),
    _Meal('Piazza', 'Pasta of the day ... 120 TL'),
  ];

  // Sample timetables (weekday) until Firestore integration.
  static const _shuttleCampusToKadikoy = [
    '07:30', '08:30', '10:00', '12:00', '13:30', '15:30', '17:30', '18:30',
    '20:00', '22:00',
  ];
  static const _km18FromSabanci = [
    '06:45', '07:30', '08:15', '09:00', '10:30', '12:00', '13:45', '15:15',
    '16:30', '17:15', '18:00', '19:00', '20:30', '22:15',
  ];

  final Set<String> _starred = {'Yemekhane', 'Piazza'};
  bool _reminderOn = false;
  DateTime _now = DateTime.now();
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // Refresh the countdowns every 20 s so the minute display never lags.
    _ticker = Timer.periodic(const Duration(seconds: 20), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  /// "Next: 17:30 (in 42 min)   then 18:30" for a list of departure times.
  String _nextLine(List<String> times) {
    final next = nextDepartures(times, _now);
    if (next.isEmpty) return 'No more departures today';
    final first = next.first;
    final then = next.length > 1 ? '   then ${next[1].label}' : '';
    return 'Next: ${first.label} (${formatMinutes(first.minutesAway)})$then';
  }

  /// Highlights a countdown that is under 10 minutes away.
  bool _isSoon(List<String> times) {
    final next = nextDepartures(times, _now, count: 1);
    return next.isNotEmpty && next.first.minutesAway < 10;
  }

  String get _greeting {
    final h = _now.hour;
    if (h < 12) return 'Good morning';
    if (h < 18) return 'Good afternoon';
    return 'Good evening';
  }

  void _snack(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const WireHeader(title: 'SuRvivor', trailing: '(offline)'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            children: [
              Text('$_greeting, ${widget.userName}',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Last updated: today 08:10',
                  style: TextStyle(fontSize: 12, color: kWireMuted)),
              const SizedBox(height: 16),
              WireCard(
                onTap: () =>
                    _snack('Route detail is built in the transport branch'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text('FAVOURITE ROUTE',
                              style:
                                  TextStyle(fontSize: 11, color: kWireMuted)),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() => _reminderOn = !_reminderOn);
                            final next = nextDepartures(
                                _shuttleCampusToKadikoy, _now,
                                count: 1);
                            _snack(_reminderOn && next.isNotEmpty
                                ? 'Reminder set for ${next.first.label}'
                                : 'Reminder removed');
                          },
                          child: Icon(
                            _reminderOn
                                ? Icons.notifications_active
                                : Icons.notifications_none,
                            size: 20,
                            color: _reminderOn ? kWireAccent : kWireMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('Campus → Kadıköy',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(_nextLine(_shuttleCampusToKadikoy),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: _isSoon(_shuttleCampusToKadikoy)
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: _isSoon(_shuttleCampusToKadikoy)
                              ? kWireAccent
                              : null,
                        )),
                  ],
                ),
              ),
              WireCard(
                onTap: widget.onSeeAllDepartures,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('KM18 · FROM SABANCI',
                        style: TextStyle(fontSize: 11, color: kWireMuted)),
                    const SizedBox(height: 4),
                    Text(_nextLine(_km18FromSabanci),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: _isSoon(_km18FromSabanci)
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color:
                              _isSoon(_km18FromSabanci) ? kWireAccent : null,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text('Today at campus',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              for (final m in _meals)
                WireCard(
                  onTap: widget.onSeeFullMenus,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.place,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(m.items,
                                style: const TextStyle(
                                    fontSize: 12, color: kWireMuted)),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() {
                          if (!_starred.add(m.place)) _starred.remove(m.place);
                        }),
                        child: Icon(
                          _starred.contains(m.place)
                              ? Icons.star
                              : Icons.star_border,
                          size: 18,
                          color: kWireMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              WireButton(
                  label: 'See all departures',
                  onPressed: widget.onSeeAllDepartures),
              const SizedBox(height: 12),
              WireButton(
                  label: 'See full menus', onPressed: widget.onSeeFullMenus),
            ],
          ),
        ),
      ],
    );
  }
}
