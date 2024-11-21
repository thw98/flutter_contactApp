import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import 'contact_list_page.dart';
import 'profile_page.dart';
import '../viewmodels/contact_list_view_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ContactListPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContactListViewModel(),
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.white,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('assets/icons/icon_home_unselected.png', width: 24.0, height: 24.0),
              activeIcon: Image.asset('assets/icons/icon_home_selected.png', width: 24.0, height: 24.0),
              label: ''
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/icons/icon_profile_unselected.png', width: 24.0, height: 24.0),
              activeIcon: Image.asset('assets/icons/icon_profile_selected.png', width: 24.0, height: 24.0),
              label: ''
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Update selected tab index
            });
          },
        ),
      ),
    );
  }
}