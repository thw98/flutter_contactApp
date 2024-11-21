import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class LocalStorage {
  static const String _contactsKey = 'contacts';

  // Load contacts from SharedPreferences
  static Future<List<User>> loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getString(_contactsKey);
    if (contactsJson != null) {
      List<dynamic> jsonList = jsonDecode(contactsJson);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } else {
      return [];  // Return an empty list if no data exists
    }
  }

  // Save contacts to SharedPreferences
  static Future<void> saveContacts(List<User> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = contacts.map((contact) => contact.toJson()).toList();
    prefs.setString(_contactsKey, jsonEncode(jsonList));
  }
}