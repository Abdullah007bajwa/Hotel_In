// ─── Crafted by Abdullah Student’s QuickStay Squad® ────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotel_in/theme/app_theme.dart';

class PremiumSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;

  const PremiumSearchBar({
    super.key,
    required this.controller,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<HotelInTokens>()!;
    final radius = tokens.radius * 2;
    final padH = tokens.padM;
    final padV = tokens.padM;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padH),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // 5% opacity black
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Where to?',
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(vertical: padV),
          prefixIcon: SvgPicture.asset(
            'assets/icons/searchIcon.svg',
            width: 24,
            height: 24,
          ),
          suffixIcon: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/filterIcon.svg',
              width: 24,
              height: 24,
            ),
            onPressed: onFilterTap,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
