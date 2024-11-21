import 'package:flutter/material.dart';
import 'app_colors.dart';

class TextUtils {
  /// Label and a red asterisk.
  static RichText addAsterisk(String label, {Color asteriskColor = AppColors.red}) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: AppColors.black,
          fontSize: 16,
        ),
        children: [
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: asteriskColor,
            ),
          ),
        ],
      ),
    );
  }
}