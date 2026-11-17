import 'package:flutter/material.dart';

import '../models/favourite_item.dart';
import '../services/favourites_store.dart';
import '../widgets/meal_card.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = FavouritesStore.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final routes = store.routes;
          final meals = store.meals;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _SectionHeader('Routes', routes.length),
              if (routes.isEmpty) const _EmptyHint('No favourite routes yet.'),
              for (final r in routes) _FavouriteCard(item: r),
              const SizedBox(height: 16),
              _SectionHeader('Meals', meals.length),
              if (meals.isEmpty)
                const _EmptyHint('Star a dish on the Menus screen to save it.'),
              for (final m in meals) _FavouriteCard(item: m),
              const SizedBox(height: 24),
              const _OfflineNote(),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title, this.count);
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text('$title ($count)',
            style: Theme.of(context).textTheme.titleMedium),
      );
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(text, style: Theme.of(context).textTheme.bodySmall),
      );
}

class _FavouriteCard extends StatelessWidget {
  const _FavouriteCard({required this.item});
  final FavouriteItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = FavouritesStore.instance;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: item.kind == FavouriteKind.route
            ? CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(Icons.directions_bus_rounded,
                    color: theme.colorScheme.onPrimaryContainer))
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CategoryTile(category: item.category ?? 'Main', size: 48)),
        title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          item.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: item.highlight
              ? TextStyle(color: theme.colorScheme.primary)
              : null,
        ),
        trailing: IconButton(
          tooltip: 'Remove',
          icon: const Icon(Icons.close),
          onPressed: () {
            store.remove(item.id);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text('${item.title} removed'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () => store.add(item),
                ),
              ));
          },
        ),
      ),
    );
  }
}

class _OfflineNote extends StatelessWidget {
  const _OfflineNote();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Stored locally – works offline;\nsynced to your account when logged in.',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}
