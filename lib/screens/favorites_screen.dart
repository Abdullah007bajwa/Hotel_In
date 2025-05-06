// ── ©HotelIn by Abdullah Student™ ── FavoritesScreen ──

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/property_card.dart';
import '../widgets/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<_Favorite>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _loadFavorites();
  }

  Future<List<_Favorite>> _loadFavorites() async {
    // Simulate network/database fetch
    await Future.delayed(const Duration(milliseconds: 800));
    // TODO: replace with real data source
    return [
      _Favorite(id: '1', title: 'Seaside Retreat', image: 'assets/roomImg1.png', price: 135, rating: 4.8),
      _Favorite(id: '2', title: 'Mountain Cabin', image: 'assets/roomImg2.png', price: 110, rating: 4.5),
      _Favorite(id: '3', title: 'Urban Loft',    image: 'assets/roomImg3.png', price: 155, rating: 4.7),
      _Favorite(id: '4', title: 'Cozy Bungalow', image: 'assets/roomImg4.png', price: 125, rating: 4.6),
    ];
  }

  Future<void> _refresh() async {
    setState(() => _favoritesFuture = _loadFavorites());
    await _favoritesFuture;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<HotelInTokens>()!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Favorites', style: theme.textTheme.headlineSmall),
        elevation: 0,
      ),
      body: FutureBuilder<List<_Favorite>>(
        future: _favoritesFuture,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(tokens.padM),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset('assets/closeIcon.svg', width: 48, height: 48, color: theme.colorScheme.error),
                    SizedBox(height: tokens.padM),
                    Text('Failed to load favorites.', style: theme.textTheme.bodyMedium),
                    SizedBox(height: tokens.padM),
                    CustomButton(
                      label: 'Retry',
                      onPressed: _refresh,
                      padding: EdgeInsets.symmetric(horizontal: tokens.padM, vertical: tokens.padS),
                    ),
                  ],
                ),
              ),
            );
          }
          final favs = snap.data!;
          if (favs.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.padM),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset('assets/heartIcon.svg', width: 72, height: 72, color: Colors.grey.shade400),
                    SizedBox(height: tokens.padM),
                    Text('No favorites yet', style: theme.textTheme.titleMedium),
                    SizedBox(height: tokens.padS),
                    Text(
                      'Tap the heart on any property to save it here.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: tokens.padL),
                    CustomButton(
                      label: 'Browse Properties',
                      leadingIcon: const Icon(Icons.search),
                      onPressed: () => GoRouter.of(context).go('/'),
                      padding: EdgeInsets.symmetric(horizontal: tokens.padM, vertical: tokens.padS),
                    ),
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            color: theme.colorScheme.primary,
            child: Padding(
              padding: EdgeInsets.all(tokens.padM),
              child: GridView.builder(
                itemCount: favs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: tokens.padM,
                  mainAxisSpacing: tokens.padM,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (ctx, i) {
                  final f = favs[i];
                  return GestureDetector(
                    onTap: () => GoRouter.of(context).go('/details/${f.id}'),
                    child: PropertyCard(
                      id: f.id,
                      title: f.title,
                      imageUrl: f.image,
                      price: '\$${f.price}',
                      rating: f.rating,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Simple model for favorite items
class _Favorite {
  final String id;
  final String title;
  final String image;
  final int price;
  final double rating;

  const _Favorite({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.rating,
  });
}
