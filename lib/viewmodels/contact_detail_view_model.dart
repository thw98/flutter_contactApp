import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/local_storage.dart';

class ContactDetailViewModel extends ChangeNotifier {
  User? contact;
  bool isLoading = false;
  String? errorMessage;

  // Load contact details from local storage
  Future<void> loadContact(String userId) async {
    isLoading = true;
    notifyListeners();

    try {
      List<User> contacts = await LocalStorage.loadContacts();
      contact = contacts.firstWhere((contact) => contact.id == userId);
    } catch (e) {
      errorMessage = 'Failed to load contact';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Update contact
  Future<void> updateContact(BuildContext context, User updatedContact) async {
    try {
      // Load contacts from local storage
      List<User> contacts = await LocalStorage.loadContacts();

      // Remove the old contact and add the updated one
      contacts.removeWhere((contact) => contact.id == updatedContact.id);
      contacts.add(updatedContact);

      // Save updated contacts back to local storage
      await LocalStorage.saveContacts(contacts);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to update contact: $e';
      notifyListeners();
    }
  }

  // Remove contact
  Future<void> removeContact(String contactId) async {
    try {
      List<User> contacts = await LocalStorage.loadContacts();
      contacts.removeWhere((contact) => contact.id == contactId);

      // Save updated contacts to local storage
      await LocalStorage.saveContacts(contacts);
      contact = null;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to remove contact';
    }
  }

  // Add a new contact
  Future<void> addContact(User newContact) async {
    try {
      List<User> contacts = await LocalStorage.loadContacts();

      // Add the new contact to the list
      contacts.add(newContact);

      // Save updated contacts back to local storage
      await LocalStorage.saveContacts(contacts);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to add contact: $e';
      notifyListeners();
    }
  }
}