import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

import '../models/meal.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.meal,
    required this.isFavourite,
    required this.onToggleFavourite,
  });

  final Meal meal;
  final bool isFavourite;
  final VoidCallback onToggleFavourite;

  static const placeholder = 'assets/images/meal_placeholder.png';

  Color _kcalColor(int kcal) {
    if (kcal < 200) return const Color(0xFF2E8B57);
    if (kcal < 400) return AppTheme.primaryColor;
    return const Color(0xFFC0392B);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final priceText = meal.priceTl != null
        ? '${meal.priceTl!.toStringAsFixed(0)} TL'
        : (meal.location == DiningLocation.yemekhane ? 'Fiks menü' : null);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onToggleFavourite,
          child: IntrinsicHeight(
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CategoryTile(category: meal.category),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              meal.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700, height: 1.15),
                            ),
                          ),
                          SizedBox(
                            width: 36,
                            height: 32,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              tooltip: isFavourite
                                  ? 'Favorilerden çıkar'
                                  : 'Favorilere ekle',
                              icon: Icon(
                                isFavourite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_outline_rounded,
                                color: isFavourite
                                    ? AppTheme.primaryColor
                                    : cs.outline,
                                size: 24,
                              ),
                              onPressed: onToggleFavourite,
                            ),
                          ),
                        ],
                      ),
                      if (meal.description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          meal.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                if (meal.slot != null)
                                  _Tag(meal.slot!,
                                      icon: meal.slot == 'Öğle'
                                          ? Icons.wb_sunny_outlined
                                          : Icons.nightlight_outlined),
                                if (meal.kcal != null)
                                  _Tag('${meal.kcal} kcal',
                                      color: _kcalColor(meal.kcal!)),
                                if (!meal.servedToday)
                                  const _Tag('Bugün yok', color: AppTheme.textSecondary),
                              ],
                            ),
                          ),
                          if (priceText != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                priceText,
                                style: theme.textTheme.labelLarge?.copyWith(
                                    color: cs.primary,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text, {this.icon, this.color});
  final String text;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final c = color ?? cs.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: c),
            const SizedBox(width: 3),
          ],
          Text(text,
              style: TextStyle(
                  fontSize: 11.5, color: c, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category, this.size = 96});
  final String category;
  final double size;

  static const _icons = {
    'Çorba': Icons.soup_kitchen_outlined,
    'Ana Yemek': Icons.restaurant_outlined,
    'Yan Yemek': Icons.rice_bowl_outlined,
    'Salata': Icons.eco_outlined,
    'Tatlı': Icons.cake_outlined,
    'İçecek': Icons.local_cafe_outlined,
    'Kahvaltı': Icons.egg_alt_outlined,
    'Tost': Icons.breakfast_dining_outlined,
    'Atıştırmalık': Icons.fastfood_outlined,
    'Makarna': Icons.ramen_dining_outlined,
    'Pide': Icons.local_pizza_outlined,
    'Burger': Icons.lunch_dining_outlined,
    'Dürüm': Icons.kebab_dining_outlined,
    'Tavuk': Icons.set_meal_outlined,
    'Et': Icons.outdoor_grill_outlined,
  };

  static const _colors = {
    'Çorba': Color(0xFFE67E22),
    'Ana Yemek': AppTheme.primaryColor,
    'Yan Yemek': Color(0xFF8E6C3A),
    'Salata': Color(0xFF2E8B57),
    'Tatlı': Color(0xFFC2185B),
    'İçecek': Color(0xFF6D4C41),
    'Kahvaltı': Color(0xFFF9A825),
    'Tost': Color(0xFFD08C2E),
    'Atıştırmalık': AppTheme.primaryColor,
    'Makarna': Color(0xFFD4A017),
    'Pide': Color(0xFFB7410E),
    'Burger': Color(0xFF8D4E1E),
    'Dürüm': Color(0xFF7B1FA2),
    'Tavuk': Color(0xFFC0392B),
    'Et': Color(0xFF6D1B1B),
  };

  @override
  Widget build(BuildContext context) {
    final c = _colors[category] ?? AppTheme.primaryColor;
    return Container(
      width: size,
      color: c.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Icon(_icons[category] ?? Icons.restaurant_outlined,
          size: size * 0.4, color: c),
    );
  }
}
