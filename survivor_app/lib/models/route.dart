class TransportRoute {
  final String id;
  final String name;
  final String origin;
  final String destination;
  final String dayType;
  final List<String> departureTimes;
  final String transportType;
  final double? fare;

  const TransportRoute({
    required this.id,
    required this.name,
    required this.origin,
    required this.destination,
    required this.dayType,
    required this.departureTimes,
    required this.transportType,
    this.fare,
  });

  String get routeKey => '$transportType|$name';
}
