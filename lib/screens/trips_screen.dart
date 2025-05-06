// ── ©HotelIn by Abdullah Student™ ── TripsScreen ──

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  late Future<List<_Trip>> _tripsFuture;

  @override
  void initState() {
    super.initState();
    _tripsFuture = _loadTrips();
  }

  Future<List<_Trip>> _loadTrips() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      _Trip(
        id: '101',
        city: 'Paris',
        dates: 'Jun 5–10',
        image: 'assets/roomImg1.png',
      ),
      _Trip(
        id: '102',
        city: 'Tokyo',
        dates: 'Jul 1–7',
        image: 'assets/roomImg2.png',
      ),
      _Trip(
        id: '201',
        city: 'New York',
        dates: 'Apr 12–15',
        image: 'assets/roomImg3.png',
        past: true,
      ),
    ];
  }

  Future<void> _refresh() async {
    setState(() => _tripsFuture = _loadTrips());
    await _tripsFuture;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<HotelInTokens>()!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Trips', style: theme.textTheme.headlineSmall),
        elevation: 0,
      ),
      body: FutureBuilder<List<_Trip>>(
        future: _tripsFuture,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/closeIcon.svg', width: 48, height: 48, color: theme.colorScheme.error),
                  SizedBox(height: tokens.padM),
                  Text('Failed to load trips.', style: theme.textTheme.bodyMedium),
                  SizedBox(height: tokens.padM),
                  ElevatedButton(onPressed: _refresh, child: const Text('Retry')),
                ],
              ),
            );
          }
          final trips = snap.data!;
          final upcoming = trips.where((t) => !t.past).toList();
          final past = trips.where((t) => t.past).toList();

          if (upcoming.isEmpty && past.isEmpty) {
            return Center(
              child: Text(
                'No trips found.\nStart planning your next adventure!',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            );
          }

          Widget buildSection(String title, List<_Trip> list) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.headlineSmall),
                SizedBox(height: tokens.padS),
                SizedBox(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    separatorBuilder: (_, __) => SizedBox(width: tokens.padM),
                    itemBuilder: (ctx, i) {
                      final trip = list[i];
                      return GestureDetector(
                        onTap: () => GoRouter.of(context).go('/trips/${trip.id}'),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(tokens.radius),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                trip.image,
                                fit: BoxFit.cover,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [Colors.black54, Colors.transparent],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(tokens.padS),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trip.city,
                                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        trip.dates,
                                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: tokens.padL),
              ],
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            color: theme.colorScheme.primary,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: tokens.padM, vertical: tokens.padS),
              child: Column(
                children: [
                  if (upcoming.isNotEmpty) buildSection('Upcoming Trips', upcoming),
                  if (past.isNotEmpty)     buildSection('Past Trips', past),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Trip {
  final String id;
  final String city;
  final String dates;
  final String image;
  final bool past;
  const _Trip({
    required this.id,
    required this.city,
    required this.dates,
    required this.image,
    this.past = false,
  });
}
