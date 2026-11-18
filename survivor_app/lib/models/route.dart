class TransportRoute {
  final String id;
  final String name;
  final String origin;
  final String destination;
  final String dayType;
  final List<String> departureTimes;
  final String transportType;
  final double? studentFare;
  final double? fullFare;

  const TransportRoute({
    required this.id,
    required this.name,
    required this.origin,
    required this.destination,
    required this.dayType,
    required this.departureTimes,
    required this.transportType,
    this.studentFare,
    this.fullFare,
  });

  // Weekday/weekend and both directions belong to the same route.
  String get routeKey => '$transportType|$name';
}
