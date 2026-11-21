import '../theme/app_theme.dart';

import 'package:flutter/material.dart';

import '../models/favourite_item.dart';
import '../models/route.dart';
import '../data/mock_transport_data.dart';
import '../services/favorite_service.dart';
import '../services/favourites_store.dart';
import 'route_detail_screen.dart';
import '../widgets/meal_card.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = FavouritesStore.instance;
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Favoriler'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
        ),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([store, FavoriteService.favorites]),
        builder: (context, _) {
          final routeKeys = FavoriteService.favorites.value;
          final byKey = <String, TransportRoute>{};
          for (final r in mockTransportRoutes) {
            if (routeKeys.contains(r.routeKey))
              byKey.putIfAbsent(r.routeKey, () => r);
          }
          final routes = byKey.values.toList();
          final meals = store.meals;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _SectionHeader('Rotalar', routes.length),
              if (routes.isEmpty)
                const _EmptyHint('Bir rotada kalbe dokunarak kaydet.'),
              for (final r in routes) _RouteCard(route: r),
              const SizedBox(height: 16),
              _SectionHeader('Yemekler', meals.length),
              if (meals.isEmpty)
                const _EmptyHint('Menüler ekranında bir yemeği favorile.'),
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
    child: Text(
      '$title ($count)',
      style: Theme.of(context).textTheme.titleMedium,
    ),
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
                child: Icon(
                  Icons.directions_bus_rounded,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CategoryTile(
                  category: item.category ?? 'Main',
                  size: 48,
                ),
              ),
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
          tooltip: 'Kaldır',
          icon: const Icon(Icons.close),
          onPressed: () {
            store.remove(item.id);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('${item.title} kaldırıldı'),
                  action: SnackBarAction(
                    label: 'Geri al',
                    onPressed: () => store.add(item),
                  ),
                ),
              );
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
        'Cihazda saklanır – çevrimdışı çalışır;\ngiriş yapınca hesabınla eşitlenir.',
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.route});
  final TransportRoute route;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.directions_bus_rounded,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(route.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${route.origin} → ${route.destination}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RouteDetailScreen(route: route)),
        ),
        trailing: IconButton(
          tooltip: 'Kaldır',
          icon: const Icon(Icons.close),
          onPressed: () {
            FavoriteService.toggleFavorite(route.routeKey);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('${route.name} kaldırıldı'),
                  action: SnackBarAction(
                    label: 'Geri al',
                    onPressed: () =>
                        FavoriteService.toggleFavorite(route.routeKey),
                  ),
                ),
              );
          },
        ),
      ),
    );
  }
}
