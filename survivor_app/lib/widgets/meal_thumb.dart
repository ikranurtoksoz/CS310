import 'package:flutter/material.dart';

import '../data/meal_wiki_titles.dart';
import '../models/meal.dart';
import '../services/meal_image_service.dart';
import 'meal_card.dart';

/// Left tile of a [MealCard].
///
/// Shows the local placeholder asset while a Wikipedia thumbnail loads
/// (network image). If the dish has no thumbnail, or the request fails,
/// the category icon tile is shown instead.
class MealThumb extends StatelessWidget {
  const MealThumb({super.key, required this.meal, this.size = 96});

  final Meal meal;
  final double size;

  @override
  Widget build(BuildContext context) {
    final title = mealWikiTitles[meal.id];
    final fallback = CategoryTile(category: meal.category, size: size);
    if (title == null) return fallback;

    return SizedBox(
      width: size,
      // Positioned.fill keeps the image from driving the card height.
      child: Stack(
        children: [
          Positioned.fill(
            child: FutureBuilder<String?>(
              future: MealImageService.instance.thumbnailFor(title),
              builder: (context, snap) {
                final url = snap.data;
                if (snap.connectionState != ConnectionState.done) {
                  return const _Placeholder();
                }
                if (url == null) return fallback;
                return Image.network(
                  url,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) =>
                      progress == null ? child : const _Placeholder(),
                  errorBuilder: (context, error, stack) => fallback,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) =>
      Image.asset(MealCard.placeholder, fit: BoxFit.cover);
}
