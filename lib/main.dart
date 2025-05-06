// ─── Crafted by Abdullah Student’s Hotel In Squad® ─────────────────────────

import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';

void main() => runApp(const HotelInApp());

class HotelInApp extends StatelessWidget {
  const HotelInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hotel In',
      theme: AppTheme.light,
      routerConfig: AppRouter,
    );
  }
}
