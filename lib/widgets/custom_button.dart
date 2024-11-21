import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

// Define button statuses
enum ButtonStatus { primary, secondary }

class CustomButton extends StatelessWidget {
  final String text;
  final ButtonStatus status; // Accepts the button status
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.status,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define styles for the button
    final isPrimary = status == ButtonStatus.primary;

    return isPrimary
        ? TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.blue, // Text color
        backgroundColor: AppColors.primaryBtn, // Background color
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
    )
        : OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.red, width: 1), // Red outline
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.red,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}