import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/data_loader.dart';
import '../models/user.dart';

class LoginViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<bool> handleLogin(String userId) async {
    isLoading = true;
    notifyListeners();

    // Load user data and check if the user exists
    final List<User> data = await DataLoader.loadUserData();

    // Find the user with matching userId
    User? user;
    try {
      user = data.firstWhere((user) => user.id == userId);
    } catch (e) {
      user = null;
    }

    if (user != null) {
      // Save login status and userId
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', userId);

      isLoading = false;
      notifyListeners();
      return true; // Successful login
    } else {
      isLoading = false;
      errorMessage = 'Invalid User ID. Please try again.';
      notifyListeners();
      return false; // Failed login
    }
  }
}