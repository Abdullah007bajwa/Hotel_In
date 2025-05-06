import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hotel_in/theme/app_theme.dart';
import '../widgets/custom_button.dart';

class DetailScreen extends StatelessWidget {
  final String propertyId;
  final List<String> imageUrls;
  final int pricePerNight;
  final double rating;
  final int reviewsCount;
  final List<IconData> amenities;
  final List<String> amenitiesLabels;

  const DetailScreen({
    super.key,
    required this.propertyId,
    this.imageUrls = const [
      'https://via.placeholder.com/600x400',
      'https://via.placeholder.com/600x400/CCCCCC',
      'https://via.placeholder.com/600x400/AAAAAA',
    ],
    this.pricePerNight = 120,
    this.rating = 4.6,
    this.reviewsCount = 128,
    this.amenities = const [
      Icons.wifi,
      Icons.pool,
      Icons.ac_unit,
      Icons.local_parking,
      Icons.pets,
    ],
    this.amenitiesLabels = const [
      'Wi-Fi',
      'Pool',
      'AC',
      'Parking',
      'Pet-friendly',
    ],
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<HotelInTokens>()!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Parallax Image Carousel in SliverAppBar
          SliverAppBar(
            expandedHeight: 400,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: _ParallaxImageCarousel(
                    imageUrls: imageUrls,
                    scrollOffset: constraints.biggest.height,
                  ),
                );
              },
            ),
          ),

          // Sticky Price and Rating Header
          SliverPersistentHeader(
            delegate: _StickyHeaderDelegate(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                padding: EdgeInsets.all(tokens.padM),
                child: _buildPriceRating(context, tokens),
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(tokens.padM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDescription(context),
                  SizedBox(height: tokens.padL),
                  Text('Amenities', style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: tokens.padS),
                  _buildAmenitiesGrid(context, tokens),
                  SizedBox(height: tokens.padL),
                  _buildBookingSection(tokens),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRating(BuildContext context, HotelInTokens tokens) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            '\$$pricePerNight / night',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Row(
          children: [
            Icon(Icons.star, size: 20, color: Colors.amber),
            SizedBox(width: tokens.padS / 2),
            Text(rating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(width: tokens.padS / 2),
            Text('($reviewsCount)', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      'Enjoy a luxurious experience at our premium property. Spacious rooms, '
      'modern amenities, and breathtaking views await you.',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
    );
  }

  Widget _buildAmenitiesGrid(BuildContext context, HotelInTokens tokens) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: tokens.padM,
      ),
      itemCount: amenities.length,
      itemBuilder: (ctx, i) => _AmenityCircle(
        icon: amenities[i],
        label: amenitiesLabels[i],
      ),
    );
  }

  Widget _buildBookingSection(HotelInTokens tokens) {
    return Center(
      child: CustomButton(
        label: 'Book Now',
        leadingIcon: const Icon(Icons.payment),
        padding:
            EdgeInsets.symmetric(vertical: tokens.padM, horizontal: tokens.padL),
        onPressed: () {
          // TODO: implement booking flow
        },
      ),
    );
  }
}

// Parallax Image Carousel Widget
class _ParallaxImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final double scrollOffset;

  const _ParallaxImageCarousel({
    required this.imageUrls,
    required this.scrollOffset,
  });

  @override
  _ParallaxImageCarouselState createState() => _ParallaxImageCarouselState();
}

class _ParallaxImageCarouselState extends State<_ParallaxImageCarousel> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.imageUrls.length,
      itemBuilder: (ctx, i) => ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
        child: CachedNetworkImage(
          imageUrl: widget.imageUrls[i],
          fit: BoxFit.cover,
          placeholder: (_, __) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(color: Colors.white),
          ),
          errorWidget: (_, __, ___) => const Center(child: Icon(Icons.error_outline)),
        ),
      ),
    );
  }
}

// Sticky Header Delegate
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

// Circular Amenity Widget
class _AmenityCircle extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AmenityCircle({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}