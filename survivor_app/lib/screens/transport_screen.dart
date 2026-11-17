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

  List<String> get locations => mockTransportRoutes
      .where((r) => r.transportType == transportType)
      .expand((r) => [r.origin, r.destination])
      .toSet()
      .toList()..sort();

  String? nextDeparture(List<String> times) {
    final now = TimeOfDay.now();
    final current = now.hour * 60 + now.minute;
    for (final time in [...times]..sort()) {
      final parts = time.split(':');
      final minute = int.parse(parts[0]) * 60 + int.parse(parts[1]);
      if (minute >= current) return time;
    }
    return null;
  }

  Widget dropdown(String label, String selected, List<String> options, ValueChanged<String> change) {
    return DropdownButtonFormField<String>(
      key: ValueKey('$label:$selected'),
      initialValue: selected,
      isExpanded: true,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: options.map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
      onChanged: (x) { if (x != null) setState(() => change(x)); },
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = ['All', ...locations];
    final matches = mockTransportRoutes.where((r) =>
      r.transportType == transportType &&
      r.dayType == dayType &&
      (origin == 'All' || r.origin == origin) &&
      (destination == 'All' || r.destination == destination) &&
      (afterTime == 'All' || r.departureTimes.any((t) => t.compareTo(afterTime) >= 0))
    ).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Transportation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Transport timetable', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [ButtonSegment(value: 'Shuttle', label: Text('Shuttle')), ButtonSegment(value: 'Bus', label: Text('KM18'))],
            selected: {transportType},
            onSelectionChanged: (value) => setState(() { transportType = value.first; origin = 'All'; destination = 'All'; }),
          ),
          const SizedBox(height: 16),
          dropdown('Origin', origin, options, (x) => origin = x),
          const SizedBox(height: 10),
          dropdown('Destination', destination, options, (x) => destination = x),
          const SizedBox(height: 10),
          dropdown('Day type', dayType, const ['Weekday', 'Weekend'], (x) => dayType = x),
          const SizedBox(height: 10),
          dropdown('Departure after', afterTime, const ['All', '06:00', '08:00', '10:00', '12:00', '14:00', '16:00', '18:00', '20:00'], (x) => afterTime = x),
          const SizedBox(height: 20),
          Text('Available routes (${matches.length})', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (matches.isEmpty) const Padding(padding: EdgeInsets.all(20), child: Text('No matching departures.')),
          for (final route in matches) _routeCard(context, route),
          const SizedBox(height: 12),
          const Text('Demo schedules only. Do not rely on these times for travel.', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _routeCard(BuildContext context, TransportRoute route) {
    final visible = route.departureTimes.where((t) => afterTime == 'All' || t.compareTo(afterTime) >= 0).toList();
    final next = nextDeparture(visible);
    return Card(
      child: ListTile(
        leading: Icon(route.transportType == 'Bus' ? Icons.directions_bus : Icons.airport_shuttle),
        title: Text('${route.name} • ${route.origin} → ${route.destination}'),
        subtitle: Text('Departures: ${visible.join(', ')}\nNext today: ${dayType == (DateTime.now().weekday >= 6 ? 'Weekend' : 'Weekday') ? (next ?? 'No more today') : 'Select today to see'}'),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RouteDetailScreen(route: route))),
      ),
    );
  }
}
