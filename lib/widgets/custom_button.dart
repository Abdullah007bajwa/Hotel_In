// ─── Crafted by Abdullah Student’s QuickStay Squad® ────────────────────────

import 'package:flutter/material.dart';

/// A reusable, customizable button that matches the QuickStay design system.
/// Supports a label, optional leading icon, loading state, and adjustable padding.
class CustomButton extends StatelessWidget {
  /// The text label to display inside the button.
  final String label;

  /// Callback invoked when the user taps the button.
  final VoidCallback onPressed;

  /// Optional icon widget displayed before the label.
  final Widget? leadingIcon;

  /// Whether to show a loading spinner instead of the label/icon.
  final bool isLoading;

  /// Vertical padding inside the button.
  final double verticalPadding;

  /// Horizontal padding inside the button.
  final double horizontalPadding;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.isLoading = false,
    this.verticalPadding = 14.0,
    this.horizontalPadding = 24.0, required EdgeInsets padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.secondary,
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(theme.primaryColor),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  leadingIcon!,
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
    );
  }
}
