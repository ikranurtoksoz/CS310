enum DiningLocation { yemekhane, kucukev, piazza }

extension DiningLocationLabel on DiningLocation {
  String get label => switch (this) {
    DiningLocation.yemekhane => 'Yemekhane',
    DiningLocation.kucukev => 'Küçükev',
    DiningLocation.piazza => 'Piazza',
  };
}

class Meal {
  const Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    this.priceTl,
    this.kcal,
    this.slot,
    this.description,
    this.servedToday = true,
    this.weekdays,
  });

  final String id;
  final String name;
  final String category;
  final DiningLocation location;
  final double? priceTl;
  final int? kcal;
  final String? slot;
  final String? description;
  final bool servedToday;
  final Set<int>? weekdays;

  bool servedOn(DateTime d) =>
      weekdays == null || weekdays!.contains(d.weekday);
}
