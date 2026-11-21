import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

import '../data/mock_meals.dart';
import '../models/meal.dart';
import '../services/favourites_store.dart';
import '../widgets/meal_card.dart';

class MenusScreen extends StatefulWidget {
  const MenusScreen({super.key});

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs =
      TabController(length: DiningLocation.values.length, vsync: this);
  DateTime _date = DateUtils.dateOnly(DateTime.now());
  String _slot = 'Tümü';
  String _query = '';

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Yemek Menüleri'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Yemek ara',
            onPressed: () async {
              final r = await showSearch<String?>(
                  context: context, delegate: _MealSearchDelegate());
              if (r != null) setState(() => _query = r);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: [for (final l in DiningLocation.values) Tab(text: l.label)],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          for (final loc in DiningLocation.values)
            _LocationMenu(
              location: loc,
              date: _date,
              query: _query,
              onClearQuery: () => setState(() => _query = ''),
              slot: _slot,
              onDate: (d) => setState(() => _date = d),
              onSlot: (v) => setState(() => _slot = v),
            ),
        ],
      ),
    );
  }
}

class _LocationMenu extends StatelessWidget {
  const _LocationMenu({
    required this.location,
    required this.date,
    required this.query,
    required this.slot,
    required this.onDate,
    required this.onSlot,
    required this.onClearQuery,
  });

  final DiningLocation location;
  final DateTime date;
  final String query;
  final String slot;
  final ValueChanged<DateTime> onDate;
  final ValueChanged<String> onSlot;
  final VoidCallback onClearQuery;

  static const _order = [
    'Çorba', 'Kahvaltı', 'Ana Yemek', 'Pide', 'Makarna', 'Burger', 'Dürüm',
    'Tavuk', 'Et', 'Atıştırmalık', 'Tost', 'Yan Yemek', 'Salata', 'Tatlı', 'İçecek',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final store = FavouritesStore.instance;
    final q = query.trim().toLowerCase();
    final meals = mockMeals
        .where((m) => m.location == location && m.servedOn(date))
        .where((m) => q.isEmpty || m.name.toLowerCase().contains(q))
        .where((m) => slot == 'Tümü' || m.slot == null || m.slot == slot)
        .toList();

    final categories = <String>[];
    for (final m in meals) {
      if (!categories.contains(m.category)) categories.add(m.category);
    }
    categories.sort((a, b) {
      final ia = _order.indexOf(a), ib = _order.indexOf(b);
      return (ia < 0 ? 99 : ia).compareTo(ib < 0 ? 99 : ib);
    });

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _DateStrip(date: date, onDate: onDate),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.schedule, size: 14, color: cs.onSurfaceVariant),
              const SizedBox(width: 4),
              Expanded(
                child: Text(serviceHours[location]!,
                    style: theme.textTheme.bodySmall),
              ),
              Text('${meals.length} ürün',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: cs.onSurfaceVariant)),
            ],
          ),
          if (location == DiningLocation.yemekhane) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                for (final v in ['Tümü', 'Öğle', 'Akşam'])
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(v),
                      selected: slot == v,
                      visualDensity: VisualDensity.compact,
                      onSelected: (_) => onSlot(v),
                    ),
                  ),
              ],
            ),
          ],
          if (q.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InputChip(
                  label: Text('Arama: $query'),
                  onDeleted: onClearQuery,
                ),
              ),
            ),
          const SizedBox(height: 4),
          if (meals.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 48),
              child: Column(
                children: [
                  Icon(Icons.no_meals, size: 48, color: cs.outline),
                  const SizedBox(height: 8),
                  Text('Yemek bulunamadı', style: theme.textTheme.titleMedium),
                  Text('Başka bir gün seç veya aramayı temizle.',
                      style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          for (final cat in categories) ...[
            Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 4, left: 2),
              child: Text(cat.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurfaceVariant)),
            ),
            for (final meal in meals.where((m) => m.category == cat))
              MealCard(
                meal: meal,
                isFavourite: store.isMealFavourite(meal),
                onToggleFavourite: () {
                  final added = store.toggleMeal(meal);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(added
                          ? '${meal.name} favorilere eklendi'
                          : '${meal.name} favorilerden çıkarıldı'),
                      duration: const Duration(seconds: 2),
                    ));
                },
              ),
          ],
          const SizedBox(height: 16),
          Center(
            child: Text('Son güncelleme (admin) · 08:10',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: cs.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }
}

class _DateStrip extends StatelessWidget {
  const _DateStrip({required this.date, required this.onDate});
  final DateTime date;
  final ValueChanged<DateTime> onDate;

  static const _days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
  static const _months = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz',
    'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final today = DateUtils.dateOnly(DateTime.now());
    final monday = date.subtract(Duration(days: date.weekday - 1));
    final week = [for (var i = 0; i < 7; i++) monday.add(Duration(days: i))];

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () =>
                    onDate(date.subtract(const Duration(days: 7))),
              ),
              Expanded(
                child: Text(
                  '${_months[date.month - 1]} ${date.year}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (!DateUtils.isSameDay(date, today))
                TextButton(
                    onPressed: () => onDate(today), child: const Text('Bugün')),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => onDate(date.add(const Duration(days: 7))),
              ),
            ],
          ),
          Row(
            children: [
              for (final d in week)
                Expanded(
                  child: _DayChip(
                    label: _days[d.weekday - 1],
                    day: d.day,
                    selected: DateUtils.isSameDay(d, date),
                    isToday: DateUtils.isSameDay(d, today),
                    onTap: () => onDate(d),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.day,
    required this.selected,
    required this.isToday,
    required this.onTap,
  });
  final String label;
  final int day;
  final bool selected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? cs.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isToday && !selected
                ? Border.all(color: cs.primary, width: 1.2)
                : null,
          ),
          child: Column(
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      color: selected ? cs.onPrimary : cs.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text('$day',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: selected ? cs.onPrimary : cs.onSurface)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealSearchDelegate extends SearchDelegate<String?> {
  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _list(context);

  @override
  Widget buildSuggestions(BuildContext context) => _list(context);

  Widget _list(BuildContext context) {
    final q = query.toLowerCase();
    final matches =
        mockMeals.where((m) => m.name.toLowerCase().contains(q)).toList();
    return ListView(
      children: [
        for (final m in matches)
          ListTile(
            leading: SizedBox(
              width: 44,
              height: 44,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CategoryTile(category: m.category, size: 44),
              ),
            ),
            title: Text(m.name),
            subtitle: Text(m.location.label),
            onTap: () => close(context, m.name),
          ),
      ],
    );
  }
}
