import 'dart:async';

import 'package:flutter/material.dart';

import '../data/mock_meals.dart';
import '../data/mock_transport_data.dart';
import '../models/meal.dart';
import '../models/route.dart';
import '../services/favorite_service.dart';
import '../theme/app_theme.dart';
import '../utils/departures.dart';
import '../widgets/app_widgets.dart';
import 'route_detail_screen.dart';

/// Landing tab: next departures for the favourite route and KM18, plus
/// today's menus. Data comes from the shared mock data until Firestore.
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

class _HomeScreenState extends State<HomeScreen> {
  static const _campus = 'Sabanci University';
  static const _defaultFavouriteKey = 'Shuttle|Campus Shuttle';
  static const _km18Key = 'Bus|KM18';

  final Set<DiningLocation> _starred = {};
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

  String get _dayType =>
      _now.weekday >= DateTime.saturday ? 'Weekend' : 'Weekday';

  /// Today's route leaving the campus for [routeKey], if any.
  TransportRoute? _fromCampus(String routeKey) {
    for (final r in mockTransportRoutes) {
      if (r.routeKey == routeKey &&
          r.origin == _campus &&
          r.dayType == _dayType) {
        return r;
      }
    }
    return null;
  }

  /// First route the user starred in Transport, else the campus shuttle.
  TransportRoute? get _favouriteRoute {
    for (final key in FavoriteService.favorites.value) {
      final r = _fromCampus(key);
      if (r != null) return r;
    }
    return _fromCampus(_defaultFavouriteKey);
  }

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

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  void _openRoute(TransportRoute r) =>
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => RouteDetailScreen(route: r)));

  Widget _countdown(List<String> times) => Text(
    _nextLine(times),
    style: TextStyle(
      fontSize: 14,
      fontWeight: _isSoon(times) ? FontWeight.w700 : FontWeight.normal,
      color: _isSoon(times) ? AppTheme.accentStrong : null,
    ),
  );

  /// "Tost, Ayran · from 60 TL" for one dining location today.
  String _mealSummary(List<Meal> meals) {
    final names = meals.take(2).map((m) => m.name).join(', ');
    final prices = meals.map((m) => m.priceTl).whereType<double>();
    final from = prices.isEmpty
        ? ''
        : ' · from ${prices.reduce((a, b) => a < b ? a : b).round()} TL';
    return '$names$from';
  }

  @override
  Widget build(BuildContext context) {
    final fav = _favouriteRoute;
    final km18 = _fromCampus(_km18Key);

    final todays = mockMeals.where((m) => m.servedOn(_now)).toList();
    final byLocation = {
      for (final loc in DiningLocation.values)
        loc: todays.where((m) => m.location == loc).toList(),
    }..removeWhere((_, meals) => meals.isEmpty);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('SUrvivor'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        children: [
          Text(
            '$_greeting, ${widget.userName}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          if (fav != null)
            InfoCard(
              onTap: () => _openRoute(fav),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'FAVOURITE ROUTE',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() => _reminderOn = !_reminderOn);
                          final next = nextDepartures(
                            fav.departureTimes,
                            _now,
                            count: 1,
                          );
                          _snack(
                            _reminderOn && next.isNotEmpty
                                ? 'Reminder set for ${next.first.label}'
                                : 'Reminder removed',
                          );
                        },
                        child: Icon(
                          _reminderOn
                              ? Icons.notifications_active
                              : Icons.notifications_none,
                          size: 20,
                          color: _reminderOn
                              ? AppTheme.accentStrong
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${fav.name} → ${fav.destination}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _countdown(fav.departureTimes),
                ],
              ),
            ),
          if (km18 != null)
            InfoCard(
              onTap: widget.onSeeAllDepartures,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'KM18 · FROM SABANCI',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _countdown(km18.departureTimes),
                ],
              ),
            ),
          const SizedBox(height: 8),
          const Text(
            'Today at campus',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          if (byLocation.isEmpty)
            const InfoCard(child: Text('No menus published for today')),
          for (final e in byLocation.entries)
            InfoCard(
              onTap: widget.onSeeFullMenus,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.key.label,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _mealSummary(e.value),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() {
                      if (!_starred.add(e.key)) _starred.remove(e.key);
                    }),
                    child: Icon(
                      _starred.contains(e.key) ? Icons.star : Icons.star_border,
                      size: 20,
                      color: _starred.contains(e.key)
                          ? AppTheme.accentStrong
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ActionButton(
            label: 'See all departures',
            onPressed: widget.onSeeAllDepartures,
          ),
          const SizedBox(height: 12),
          ActionButton(
            label: 'See full menus',
            onPressed: widget.onSeeFullMenus,
          ),
        ],
      ),
    );
  }
}
