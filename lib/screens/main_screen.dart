import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Required for SVG icons
import 'package:hotel_in/theme/app_theme.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'trips_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  static const _pages = [
    SearchScreen(),
    FavoritesScreen(),
    TripsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<HotelInTokens>()!;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // Use IndexedStack to preserve each page's state
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),

      // Optimized BottomNavigationBar
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(tokens.radius * 1.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent, // Allows container color to show
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: theme.textTheme.bodySmall,
          unselectedLabelStyle: theme.textTheme.bodySmall,
          showUnselectedLabels: true,
          elevation: 0, // Shadow handled by container
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/homeIcon.svg', width: 24),
              activeIcon: SvgPicture.asset('assets/homeFilledIcon.svg', width: 24),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/heartIcon.svg', width: 24),
              activeIcon: SvgPicture.asset('assets/heartFilledIcon.svg', width: 24),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/tripsIcon.svg', width: 24),
              activeIcon: SvgPicture.asset('assets/tripsFilledIcon.svg', width: 24),
              label: 'Trips',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/profileIcon.svg', width: 24),
              activeIcon: SvgPicture.asset('assets/profileFilledIcon.svg', width: 24),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}