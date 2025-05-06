// ── ©HotelIn by Abdullah Student™ ── SearchScreen ──

// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';
import '../widgets/date_chips.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _destinationController = TextEditingController();
  int _selectedDateIndex = 0;
  late final List<DateTime> _dates;
  late final List<String> _dateLabels;

  @override
  void initState() {
    super.initState();
    // Prepare next 4 days
    final today = DateTime.now();
    _dates = List.generate(4, (i) => today.add(Duration(days: i + 1)));
    _dateLabels = _dates
        .map((d) => DateFormat('EEE, MMM d').format(d))
        .toList(growable: false);
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  void _goToResults() {
    final dest = _destinationController.text.trim();
    if (dest.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a destination.')),
      );
      return;
    }
    GoRouter.of(context).go(
      '/results?destination=${Uri.encodeComponent(dest)}&date=${_dates[_selectedDateIndex].toIso8601String()}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<HotelInTokens>()!;
    return Scaffold(
      body: Stack(
        children: [
          // 1) Hero banner
          SizedBox(
            height: 280,
            width: double.infinity,
            child: Image.asset(
              'assets/regImage.png',
              fit: BoxFit.cover,
            ),
          ),

          // 2) Glassmorphic overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),

          // 3) Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.padM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: tokens.padL),
                  Text(
                    'Plan Your Next Trip',
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black87,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: tokens.padL),

                  // 4) Glass Search Bar
                  _GlassSearchBar(
                    controller: _destinationController,
                    onTapFilter: () {
                      // TODO: open filters
                    },
                  ),

                  SizedBox(height: tokens.padL),

                  // 5) Date Chips
                  DateChips(
                    dates: _dateLabels,
                    selectedIndex: _selectedDateIndex,
                    onSelected: (i) => setState(() => _selectedDateIndex = i),
                  ),

                  const Spacer(),

                  // 6) Show Results Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _goToResults,
                      icon: SvgPicture.asset(
                        'assets/arrowIcon.svg',
                        width: 20,
                        height: 20,
                        color: theme.colorScheme.onPrimary,
                      ),
                      label: const Text('Show Results'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(tokens.radius),
                        ),
                        backgroundColor: Color(0xFFD4AF37), // gold accent
                        textStyle: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: tokens.padL),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Glassmorphism search bar with assets
class _GlassSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTapFilter;

  const _GlassSearchBar({
    required this.controller,
    required this.onTapFilter,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<HotelInTokens>()!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radius * 1.5),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: tokens.padM),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(tokens.radius * 1.5),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/locationIcon.svg',
                width: 24,
                height: 24,
                color: Colors.white,
              ),
              SizedBox(width: tokens.padM),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Where to?',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: onTapFilter,
                icon: SvgPicture.asset(
                  'assets/filterIcon.svg',
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
