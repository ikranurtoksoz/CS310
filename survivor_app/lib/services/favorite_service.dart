import 'package:flutter/foundation.dart';

// In-memory demo service. Not persisted after the app is fully restarted.
class FavoriteService {
  FavoriteService._();

  static final ValueNotifier<Set<String>> favorites = ValueNotifier(<String>{});

  static bool isFavorite(String routeKey) => favorites.value.contains(routeKey);

  static void toggleFavorite(String routeKey) {
    final updated = Set<String>.from(favorites.value);
    if (!updated.add(routeKey)) updated.remove(routeKey);
    favorites.value = updated;
  }

  static List<String> getFavoriteRouteIds() => favorites.value.toList();
}
