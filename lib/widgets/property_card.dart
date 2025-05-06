// ─── Crafted by Abdullah Student’s QuickStay Squad® ────────────────────────

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_in/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class PropertyCard extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String price;
  final double rating;

  const PropertyCard({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<HotelInTokens>()!;
    return Hero(
      tag: 'property-$id',
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.all(tokens.padM / 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(tokens.radius),
            boxShadow: tokens.cardShadow, // Use theme-defined shadow
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(tokens.radius),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                // 1) Image with shimmer
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (ctx, url) => _buildShimmer(tokens),
                  errorWidget: (ctx, url, error) =>
                      const Center(child: Icon(Icons.error_outline)),
                ),

                // 2) Gradient overlay for readability
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(tokens.padM),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: tokens.padS),

                        // Rating & Price Row
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/starIconFilled.svg',
                              width: 20,
                              color: Color(0xFFB193C3),
                            ),
                            SizedBox(width: tokens.padS),
                            Text(
                              rating.toStringAsFixed(1),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              price,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Color(0xFFB193C3),
                                fontWeight: FontWeight.w700,
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

  Widget _buildShimmer(HotelInTokens tokens) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(color: Colors.white),
    );
  }
}