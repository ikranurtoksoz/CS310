enum FavouriteKind { route, meal }

class FavouriteItem {
  const FavouriteItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    this.highlight = false,
    this.category,
  });

  final String id;
  final FavouriteKind kind;
  final String title;
  final String subtitle;

  final bool highlight;
  final String? category;
}
