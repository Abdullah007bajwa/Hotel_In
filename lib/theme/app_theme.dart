// ── ©HotelIn by Abdullah Student™ ── app_theme.dart ──

// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for consistent spacing & radii
class HotelInTokens extends ThemeExtension<HotelInTokens> {
  final double borderRadius;
  final double paddingSmall;
  final double paddingMedium;
  final double paddingLarge;
  final List<BoxShadow> cardShadow;

  const HotelInTokens({
    this.borderRadius = 28.0,
    this.paddingSmall = 16.0,
    this.paddingMedium = 24.0,
    this.paddingLarge = 36.0,
    this.cardShadow = const [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.15),
        blurRadius: 20,
        spreadRadius: 2,
        offset: Offset(0, 10),
      ),
    ],
  });

  double get padS => paddingSmall;
  double get padM => paddingMedium;
  double get padL => paddingLarge;
  double get radius => borderRadius;

  @override
  HotelInTokens copyWith({
    double? borderRadius,
    double? paddingSmall,
    double? paddingMedium,
    double? paddingLarge,
    List<BoxShadow>? cardShadow,
  }) {
    return HotelInTokens(
      borderRadius: borderRadius ?? this.borderRadius,
      paddingSmall: paddingSmall ?? this.paddingSmall,
      paddingMedium: paddingMedium ?? this.paddingMedium,
      paddingLarge: paddingLarge ?? this.paddingLarge,
      cardShadow: cardShadow ?? this.cardShadow,
    );
  }

  @override
  HotelInTokens lerp(ThemeExtension<HotelInTokens>? other, double t) {
    if (other is! HotelInTokens) return this;
    return HotelInTokens(
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
      paddingSmall: lerpDouble(paddingSmall, other.paddingSmall, t)!,
      paddingMedium: lerpDouble(paddingMedium, other.paddingMedium, t)!,
      paddingLarge: lerpDouble(paddingLarge, other.paddingLarge, t)!,
      cardShadow: BoxShadow.lerpList(this.cardShadow, other.cardShadow, t)!,
    );
  }
}

/// Centralized ThemeData for the Hotel In app
class AppTheme {
  // ── Primary palette ──
  static const Color _primary = Color(0xFF2A2D3E); // Charcoal
  static const Color _secondary = Color(0xFFB193C3); // Dusty Lavender
  static const Color _goldAccent = Color(0xFFD4AF37); // Gold
  static const Color _emerald = Color(0xFF50C878); // Emerald
  static const Color _surface = Color(0xFFFFFCFA); // Soft Ivory
  static const Color _onSurface = _primary;
  static const Color _error = Colors.redAccent;

  // ── Gradient for primary buttons ──
  static const LinearGradient _buttonGradient = LinearGradient(
    colors: [_primary, Color(0xFF4A4E6D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: _primary,
        secondary: _secondary,
        background: _surface,
        surface: _surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: _onSurface,
        onSurface: _onSurface,
        error: _error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: _surface,

      // ── Typography ──
      textTheme: GoogleFonts.playfairDisplayTextTheme().copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: _primary,
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _primary,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _primary,
        ),
        bodyMedium: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _primary,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 14,
          color: _primary.withOpacity(0.7),
        ),
      ),

      // ── AppBar ──
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: _surface,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: _primary,
        ),
        iconTheme: const IconThemeData(
          color: _primary,
          size: 28.0,
        ),
      ),

      // ── Elevated Button (Gradient) ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          ),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            // use gradient via Ink
            return Colors.transparent;
          }),
          elevation: MaterialStateProperty.all(4),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          shadowColor: MaterialStateProperty.all(_primary.withOpacity(0.3)),
          overlayColor: MaterialStateProperty.all(_goldAccent.withOpacity(0.1)),
        ),
      ),

      // ── Text Button ──
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _secondary,
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Input Decoration ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: GoogleFonts.poppins(
          color: _primary.withOpacity(0.5),
          fontSize: 16,
        ),
      ),

      // ── Chips ──
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade200,
        selectedColor: _secondary,
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _primary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      // ── Cards ──
      cardTheme: CardTheme(
        elevation: 2,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // ── Bottom Navigation ──
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _surface,
        selectedItemColor: _primary,
        unselectedItemColor: _primary.withOpacity(0.5),
        showUnselectedLabels: true,
        elevation: 8,
      ),

      // ── Extensions ──
      extensions: const <ThemeExtension<dynamic>>[
        HotelInTokens(),
      ],
    );

    // Wrap with custom gradient button Ink
    return base.copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: base.elevatedButtonTheme.style?.copyWith(
          backgroundColor: MaterialStateProperty.all(_primary),
        ),
      ),
    );
  }
}