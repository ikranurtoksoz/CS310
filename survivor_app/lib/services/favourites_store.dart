import 'package:flutter/foundation.dart';

import '../models/favourite_item.dart';
import '../models/meal.dart';

class FavouritesStore extends ChangeNotifier {
  FavouritesStore._();

  static final FavouritesStore instance = FavouritesStore._();

  final List<FavouriteItem> _items = [];

  List<FavouriteItem> get all => List.unmodifiable(_items);
  List<FavouriteItem> get routes =>
      _items.where((i) => i.kind == FavouriteKind.route).toList();
  List<FavouriteItem> get meals =>
      _items.where((i) => i.kind == FavouriteKind.meal).toList();

  bool contains(String id) => _items.any((i) => i.id == id);

  static String mealId(Meal m) => 'meal:${m.id}';

  bool isMealFavourite(Meal m) => contains(mealId(m));

  void add(FavouriteItem item) {
    if (contains(item.id)) return;
    _items.add(item);
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  bool toggleMeal(Meal m) {
    final id = mealId(m);
    if (contains(id)) {
      remove(id);
      return false;
    }
    add(
      FavouriteItem(
        id: id,
        kind: FavouriteKind.meal,
        title: '${m.name} · ${m.location.label}',
        subtitle: m.servedToday ? 'Bugün var!' : 'Bugün yok',
        highlight: m.servedToday,
        category: m.category,
      ),
    );
    return true;
  }
}
