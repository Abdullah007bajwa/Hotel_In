// ── ©HotelIn by Abdullah Student™ ── ProfileScreen ──

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder user data (replace with actual user model/provider later)
    const avatarUrl = 'https://via.placeholder.com/120';
    const name = 'Abdullah Bajwa';
    const email = 'abdullah.bajwa@example.com';
    const stats = {
      'Bookings': 12,
      'Favorites': 5,
      'Reviews': 8,
    };

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (ctx, innerBoxScrolled) => [
          SliverAppBar(
            expandedHeight: 280, // Height of the header when fully expanded
            flexibleSpace: _ProfileHeader(
              avatarUrl: avatarUrl,
              name: name,
              email: email,
            ),
            pinned: true, // Keeps the header pinned at the top when collapsed
          ),
        ],
        body: _ProfileContent(stats: stats),
      ),
    );
  }
}

// Header widget with background image and gradient
class _ProfileHeader extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String email;

  const _ProfileHeader({
    required this.avatarUrl,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/profile_bg.png', // Add this asset to your project
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey.shade300, // Fallback if image fails
            ),
          ),
        ),
        // Gradient overlay for better text readability
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Profile info
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _AnimatedAvatar(avatarUrl: avatarUrl),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Animated avatar widget
class _AnimatedAvatar extends StatefulWidget {
  final String avatarUrl;

  const _AnimatedAvatar({required this.avatarUrl});

  @override
  State<_AnimatedAvatar> createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<_AnimatedAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // Repeats animation, reversing direction
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (ctx, child) {
        return Transform.translate(
          offset: Offset(0, 8 * _controller.value), // Moves avatar up/down
          child: child,
        );
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 4,
            ),
          ],
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: widget.avatarUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}

// Content widget with stats and options
class _ProfileContent extends StatelessWidget {
  final Map<String, int> stats;

  const _ProfileContent({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<HotelInTokens>()!;

    // Build stat widget
    Widget buildStat(String label, int value) {
      return Column(
        children: [
          Text(
            value.toString(),
            style: theme.textTheme.headlineSmall?.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      );
    }

    // Build option widget
    Widget buildOption(IconData icon, String label, String route) {
      return ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(label, style: theme.textTheme.bodyMedium),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => GoRouter.of(context).go(route),
        contentPadding: EdgeInsets.symmetric(
          horizontal: tokens.padM,
          vertical: tokens.padS,
        ),
      );
    }

    return ListView(
      children: [
        // Stats section
        Padding(
          padding: EdgeInsets.symmetric(vertical: tokens.padM),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: stats.entries.map((e) => buildStat(e.key, e.value)).toList(),
          ),
        ),
        const Divider(thickness: 1),

        // Options list
        buildOption(Icons.payment, 'Payment Methods', '/payment-methods'),
        buildOption(Icons.settings, 'App Settings', '/settings'),
        buildOption(Icons.support_agent, 'Help & Support', '/support'),
        SizedBox(height: tokens.padL),

        // Logout button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: tokens.padM),
          child: CustomButton(
            label: 'Log Out',
            leadingIcon: const Icon(Icons.logout),
            padding: EdgeInsets.symmetric(
              vertical: tokens.padS,
              horizontal: tokens.padM,
            ),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Log Out?'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Log Out'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                // TODO: Implement actual sign-out logic (e.g., auth.signOut())
                GoRouter.of(context).go('/login');
              }
            },
          ),
        ),
        SizedBox(height: tokens.padL),
      ],
    );
  }
}