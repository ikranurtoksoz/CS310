import 'package:flutter/material.dart';
import '../data/mock_transport_data.dart';
import '../models/route.dart';
import '../services/favorite_service.dart';

class RouteDetailScreen extends StatefulWidget {
  final TransportRoute route;
  const RouteDetailScreen({super.key, required this.route});

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  late String selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.route.dayType;
  }

  void _reminderSheet(String departureTime, String from) {
    int selectedMinutes = 5;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (innerContext, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reminder for $departureTime', style: Theme.of(context).textTheme.titleLarge),
                Text('From: $from'),
                const SizedBox(height: 12),
                for (final minutes in [5, 10, 15])
                  ListTile(
                    title: Text('$minutes minutes before'),
                    leading: Icon(selectedMinutes == minutes ? Icons.radio_button_checked : Icons.radio_button_unchecked),
                    onTap: () => setSheetState(() => selectedMinutes = minutes),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Reminder preference: $selectedMinutes minutes before $departureTime (demo only; no notification scheduled)'),
                      ));
                    },
                    child: const Text('Set reminder'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sameRoute = mockTransportRoutes.where((r) => r.routeKey == widget.route.routeKey && r.dayType == selectedDay).toList();
    final origins = sameRoute.map((r) => r.origin).toSet().toList()..sort();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.route.name),
        actions: [
          ValueListenableBuilder<Set<String>>(
            valueListenable: FavoriteService.favorites,
            builder: (context, favorites, _) {
              final saved = favorites.contains(widget.route.routeKey);
              return IconButton(
                tooltip: saved ? 'Remove favorite' : 'Add favorite',
                icon: Icon(saved ? Icons.favorite : Icons.favorite_border, color: saved ? Colors.red : null),
                onPressed: () {
                  FavoriteService.toggleFavorite(widget.route.routeKey);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(saved ? 'Removed from favorites' : 'Added to favorites')));
                },
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Route details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text('Route: ${widget.route.name}'),
          Text('Fare: ${widget.route.fare == null ? 'Not available in demo data' : '${widget.route.fare!.toStringAsFixed(2)} TL'}'),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: const [ButtonSegment(value: 'Weekday', label: Text('Weekday')), ButtonSegment(value: 'Weekend', label: Text('Weekend'))],
            selected: {selectedDay},
            onSelectionChanged: (values) => setState(() => selectedDay = values.first),
          ),
          const SizedBox(height: 20),
          // Two direction columns, as specified in the Step 2.1 wireframe.
          LayoutBuilder(builder: (context, constraints) {
            final columns = [for (final origin in origins) _directionColumn(origin, sameRoute.where((r) => r.origin == origin).toList())];
            if (constraints.maxWidth < 540) {
              return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [for (final column in columns) Padding(padding: const EdgeInsets.only(bottom: 12), child: column)]);
            }
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [for (final column in columns) Expanded(child: Padding(padding: const EdgeInsets.only(right: 12), child: column))]);
          }),
          const SizedBox(height: 16),
          const Text('Sample times only; reminder confirmation does not schedule a real notification.', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _directionColumn(String from, List<TransportRoute> routes) {
    final times = routes.expand((r) => r.departureTimes).toSet().toList()..sort();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From: $from', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (times.isEmpty) const Text('No departures'),
            for (final time in times)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(time),
                trailing: IconButton(
                  tooltip: 'Set reminder',
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () => _reminderSheet(time, from),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
