import 'package:contact_app/utils/text_utils.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData? leading; // Optional leading icon
  final String? placeholder; // Optional placeholder text
  final String? errorText; // Optional error message
  final String? Function(String?)? validator; // Validator function
  final bool isRequired; // Indicates if the field is required

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.leading,
    this.placeholder,
    this.errorText, // Error message
    this.validator, // Validator parameter
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isRequired ?
        TextUtils.addAsterisk(label) :
        Text(
          label,
          style: TextStyle(fontSize: 16, color: AppColors.black),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: AppColors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: leading != null
                ? Icon(leading, color: AppColors.blue)
                : null,
            hintText: placeholder,
            hintStyle: TextStyle(fontSize: 14.0, color: AppColors.placeholder, fontWeight: FontWeight.w300),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            errorText: errorText,
          ),
          style: const TextStyle(
            fontSize: 14.0,
            color: AppColors.black,
            fontWeight: FontWeight.w300,
          ),
          validator: validator,
        ),
      ],
    );
  }
}