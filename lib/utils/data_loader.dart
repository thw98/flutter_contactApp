import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user.dart';

class DataLoader {
  static Future<List<User>> loadUserData() async {
    final String jsonString =
    await rootBundle.loadString('assets/data/data.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((data) => User.fromJson(data)).toList();
  }
}