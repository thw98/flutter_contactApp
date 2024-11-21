import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/data_loader.dart';
import '../utils/local_storage.dart';

class ContactListViewModel extends ChangeNotifier {
  List<User> _contacts = [];
  List<User> _filteredContacts = [];
  String? loggedInUserId;
  bool isLoading = true;
  String _searchQuery = '';

  List<User> get contacts => _contacts;
  List<User> get filteredContacts => _filteredContacts;

  // Load contacts from shared preferences
  Future<void> loadContactsFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    loggedInUserId = prefs.getString('userId');

    _contacts = await LocalStorage.loadContacts();
    // If no contacts found in local storage, load from JSON file and save to local storage
    if (_contacts.isEmpty) {
      await loadContactsFromJson();
    }

    // Sort contacts alphabetically by first name
    _contacts.sort((a, b) => a.firstName.compareTo(b.firstName));
    _filteredContacts = List.from(_contacts);

    isLoading = false;
    notifyListeners();
  }

  // Force reload contacts from JSON
  Future<void> loadContactsFromJson() async {
    isLoading = true;

    final data = await DataLoader.loadUserData();  // Load contacts from the JSON file
    _contacts = data;  // Update contacts with data from the JSON file

    // Save the loaded contacts to SharedPreferences
    await LocalStorage.saveContacts(_contacts);

    // Sort contacts alphabetically by first name
    _contacts.sort((a, b) => a.firstName.compareTo(b.firstName));
    _filteredContacts = List.from(_contacts);

    isLoading = false;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _filterContacts();
    notifyListeners();
  }

  void _filterContacts() {
    if (_searchQuery.isEmpty) {
      // When search query is empty, show all contacts
      _filteredContacts = List.from(_contacts);
    } else {
      // Filter contacts based on the search query
      _filteredContacts = _contacts.where((contact) {
        return contact.firstName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            contact.lastName.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }
}