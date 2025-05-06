// ── ©HotelIn by Abdullah Student™ ── ResultsScreen ──

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';
import '../widgets/property_card.dart';

class Property {
  final String id;
  final String title;
  final String imageAsset;
  final int price;
  final double rating;

  const Property({
    required this.id,
    required this.title,
    required this.imageAsset,
    required this.price,
    required this.rating,
  });
}

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late Future<List<Property>> _propertiesFuture;

  @override
  void initState() {
    super.initState();
    _propertiesFuture = _loadProperties();
  }

  Future<List<Property>> _loadProperties() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // Using local assets for premium look
    final assets = [
      'assets/roomImg1.png',
      'assets/roomImg2.png',
      'assets/roomImg3.png',
      'assets/roomImg4.png',
    ];
    return List.generate(8, (i) {
      final idx = i % assets.length;
      return Property(
        id: '${i + 1}',
        title: 'Room Deluxe #${i + 1}',
        imageAsset: assets[idx],
        price: 100 + idx * 25,
        rating: 4.0 + (idx * 0.2),
      );
    });
  }

  Future<void> _refresh() async {
    setState(() => _propertiesFuture = _loadProperties());
    await _propertiesFuture;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<HotelInTokens>()!;
    final width = MediaQuery.of(context).size.width;
    final crossCount = width > 600 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: Text('Results', style: theme.textTheme.headlineSmall),
        elevation: 0,
      ),
      body: FutureBuilder<List<Property>>(
        future: _propertiesFuture,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return _buildShimmerGrid(tokens, crossCount);
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(tokens.padM),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                    SizedBox(height: tokens.padS),
                    Text('Failed to load properties.', style: theme.textTheme.bodyMedium),
                    SizedBox(height: tokens.padM),
                    ElevatedButton(onPressed: _refresh, child: const Text('Retry')),
                  ],
                ),
              ),
            );
          }
          final props = snap.data!;
          return RefreshIndicator(
            onRefresh: _refresh,
            color: theme.colorScheme.primary,
            child: Padding(
              padding: EdgeInsets.all(tokens.padM),
              child: GridView.builder(
                itemCount: props.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossCount,
                  crossAxisSpacing: tokens.padM,
                  mainAxisSpacing: tokens.padM,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (ctx, i) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: _PropertyCardWrapper(
                      key: ValueKey(props[i].id),
                      property: props[i],
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

  Widget _buildShimmerGrid(HotelInTokens tokens, int crossCount) {
    return Padding(
      padding: EdgeInsets.all(tokens.padM),
      child: GridView.builder(
        itemCount: crossCount * 3,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossCount,
          crossAxisSpacing: tokens.padM,
          mainAxisSpacing: tokens.padM,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(tokens.radius),
            ),
          ),
        ),
      ),
    );
  }
}

class _PropertyCardWrapper extends StatefulWidget {
  final Property property;

  const _PropertyCardWrapper({Key? key, required this.property}) : super(key: key);

  @override
  State<_PropertyCardWrapper> createState() => _PropertyCardWrapperState();
}

class _PropertyCardWrapperState extends State<_PropertyCardWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: () => GoRouter.of(context).go('/details/${widget.property.id}'),
        child: PropertyCard(
          id: widget.property.id,
          title: widget.property.title,
          imageUrl: widget.property.imageAsset,
          price: '\$${widget.property.price}',
          rating: widget.property.rating,
        ),
      ),
    );
  }
}