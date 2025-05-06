// ─── Crafted by Abdullah Student’s QuickStay Squad® ────────────────────────

import 'package:go_router/go_router.dart';
import '../screens/main_screen.dart';
import '../screens/results_screen.dart';
import '../screens/detail_screen.dart';

final AppRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (ctx, state) => const MainScreen(),
      routes: [
        GoRoute(
          path: 'results',
          builder: (ctx, state) => const ResultsScreen(),
        ),
        GoRoute(
          path: 'details/:id',
          builder: (ctx, state) {
            final id = state.pathParameters['id']!;
            return DetailScreen(propertyId: id);
          },
        ),
      ],
    ),
  ],
);
