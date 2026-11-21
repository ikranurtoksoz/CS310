import 'dart:async';

import 'package:flutter/material.dart';
import '../data/mock_transport_data.dart';
import '../models/route.dart';
import 'route_detail_screen.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  String transportType = 'Shuttle';
  String dayType = 'Weekday';
  String origin = 'All';
  String destination = 'All';
  String afterTime = 'All';
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    // Refresh the countdown once per minute.
    _clockTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  List<String> get locations => mockTransportRoutes
      .where((r) => r.transportType == transportType)
      .expand((r) => [r.origin, r.destination])
      .toSet()
      .toList()
    ..sort();

  int _minutesOfDay(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  int? _minutesUntil(String time) {
    final now = TimeOfDay.now();
    final difference = _minutesOfDay(time) - (now.hour * 60 + now.minute);
    return difference >= 0 ? difference : null;
  }

  String? _nextDeparture(List<String> times) {
    final future = times.where((time) => _minutesUntil(time) != null).toList()
      ..sort();
    return future.isEmpty ? null : future.first;
  }

  Widget _dropdown(
    String label,
    String selected,
    List<String> options,
    ValueChanged<String> change,
  ) {
    return DropdownButtonFormField<String>(
      key: ValueKey('$label:$selected'),
      initialValue: selected,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: options
          .map((x) => DropdownMenuItem(value: x, child: Text(x)))
          .toList(),
      onChanged: (x) {
        if (x != null) setState(() => change(x));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = ['All', ...locations];
    final matches = mockTransportRoutes.where((r) {
      return r.transportType == transportType &&
          r.dayType == dayType &&
          (origin == 'All' || r.origin == origin) &&
          (destination == 'All' || r.destination == destination) &&
          (afterTime == 'All' ||
              r.departureTimes.any((t) => t.compareTo(afterTime) >= 0));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Transportation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Transport timetable',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Shuttle', label: Text('Shuttle')),
              ButtonSegment(value: 'Bus', label: Text('KM18')),
            ],
            selected: {transportType},
            onSelectionChanged: (value) => setState(() {
              transportType = value.first;
              origin = 'All';
              destination = 'All';
            }),
          ),
          const SizedBox(height: 16),
          _dropdown('Origin', origin, options, (x) => origin = x),
          const SizedBox(height: 10),
          _dropdown('Destination', destination, options, (x) => destination = x),
          const SizedBox(height: 10),
          _dropdown('Day type', dayType, const ['Weekday', 'Weekend'],
              (x) => dayType = x),
          const SizedBox(height: 10),
          _dropdown(
            'Departure after',
            afterTime,
            const [
              'All', '06:00', '08:00', '10:00', '12:00',
              '14:00', '16:00', '18:00', '20:00'
            ],
            (x) => afterTime = x,
          ),
          const SizedBox(height: 20),
          Text(
            'Available routes (${matches.length})',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (matches.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('No matching departures.'),
            ),
          for (final route in matches) _routeCard(context, route),
          const SizedBox(height: 12),
          const Text(
            'DEMO DATA: routes, times and fares are illustrative only. '
            'Please do not rely on them for actual travel.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _routeCard(BuildContext context, TransportRoute route) {
    final visibleTimes = route.departureTimes
        .where((t) => afterTime == 'All' || t.compareTo(afterTime) >= 0)
        .toList()
      ..sort();
    final todayType =
        DateTime.now().weekday >= 6 ? 'Weekend' : 'Weekday';
    final isToday = route.dayType == todayType;
    final next = isToday ? _nextDeparture(visibleTimes) : null;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RouteDetailScreen(route: route),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    route.transportType == 'Bus'
                        ? Icons.directions_bus
                        : Icons.airport_shuttle,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      route.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    route.studentFare == null || route.fullFare == null
                        ? 'Fare: N/A'
                        : 'SUCard ${route.studentFare!.toStringAsFixed(0)} TL | ${route.fullFare!.toStringAsFixed(0)} TL',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('${route.origin}  →  ${route.destination}'),
              const SizedBox(height: 12),
              const Text('Departure times',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: visibleTimes.map((time) {
                  final remaining = isToday ? _minutesUntil(time) : null;
                  final isPast = isToday && remaining == null;
                  final isNext = isToday && next == time;
                  return _DepartureChip(
                    time: time,
                    isPast: isPast,
                    isNext: isNext,
                    remaining: remaining,
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              if (isToday)
                Text(
                  next == null
                      ? 'No more departures today'
                      : 'Next departure: $next'
                          '${_minutesUntil(next) == 0 ? ' · leaving now' : ' · ${_minutesUntil(next)} min left'}',
                  style: TextStyle(
                    color: next == null ? Colors.grey : Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                Text(
                  '${route.dayType} schedule',
                  style: const TextStyle(color: Colors.grey),
                ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DepartureChip extends StatelessWidget {
  final String time;
  final bool isPast;
  final bool isNext;
  final int? remaining;

  const _DepartureChip({
    required this.time,
    required this.isPast,
    required this.isNext,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final color = isNext
        ? Colors.red
        : isPast
            ? Colors.grey
            : Theme.of(context).colorScheme.primary;

    return Opacity(
      opacity: isPast ? 0.35 : 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(
          color: isNext ? Colors.red.withValues(alpha: 0.09) : null,
          border: Border.all(
            color: isNext ? Colors.red : Colors.grey.shade400,
            width: isNext ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              time,
              style: TextStyle(
                color: color,
                fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isNext && remaining != null)
              Text(
                remaining == 0 ? 'Now' : '$remaining min',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
