import 'package:flutter/material.dart';

class DatePickerManager {
  static Future<String?> selectDate(BuildContext context, {String? initialDate}) async {
    // Default to today's date if no date is provided
    DateTime initialDateTime = DateTime.now();

    if (initialDate != null && initialDate.isNotEmpty) {
      try {
        final parts = initialDate.split('/');
        if (parts.length == 3) {
          initialDateTime = DateTime(
            int.parse(parts[2]),  // Year
            int.parse(parts[0]),  // Month
            int.parse(parts[1]),  // Day
          );
        }
      } catch (e) {
        initialDateTime = DateTime.now();
      }
    }

    final DateTime lastDate = DateTime.now();
    if (initialDateTime.isAfter(lastDate)) {
      initialDateTime = lastDate;
    }

    // Show the date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime(1900),
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      // Return the date as a formatted string (MM/DD/YYYY)
      return "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
    }

    return null;
  }
}