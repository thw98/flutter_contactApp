import 'package:contact_app/viewmodels/contact_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'views/login_page.dart';
import 'views/home_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) =>ContactListViewModel()), // HomeViewModel provider
      ],
      child: MaterialApp(
        title: 'Flutter App',
        theme: ThemeData(
          fontFamily: 'Poppins',
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder<bool>(
          future: _isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()), // Center the loading indicator
              );
            }

            // Based on login status, navigate to the HomePage or LoginPage
            if (snapshot.data == true) {
              return ChangeNotifierProvider(
                create: (_) => ContactListViewModel(),
                child: HomePage(), // Show the HomePage if logged in
              );
            } else {
              return LoginPage(); // Show the LoginPage if not logged in
            }
          },
        ),
      ),
    );
  }

  // Function to check login status
  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // Default to false if not set
  }
}