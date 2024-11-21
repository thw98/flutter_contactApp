import 'package:contact_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/auth_manager.dart';
import '../viewmodels/contact_list_view_model.dart';
import '../viewmodels/profile_view_model.dart';
import 'contact_detail_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileViewModel()..loadProfile(), // Load profile on init
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0.0,
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'My Profile',
              style: TextStyle(color: AppColors.black, fontSize: 23, fontWeight: FontWeight.w700),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                AuthManager.logout(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Logout',
                  style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        body: Consumer<ProfileViewModel>(
          builder: (context, profileViewModel, child) {
            // Handle loading state
            if (profileViewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            // Handle error state
            if (profileViewModel.errorMessage != null) {
              return Center(child: Text(profileViewModel.errorMessage!));
            }

            final user = profileViewModel.user;

            if (user == null) {
              return Center(child: Text("User not found"));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar and Details
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.blue,
                    child: Text(
                      '${user.firstName[0]}${user.lastName[0]}', // Using initials
                      style: TextStyle(color: AppColors.white, fontSize: 40, fontWeight: FontWeight.w300),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.lightGrayLbl),
                  ),
                  SizedBox(height: 8),
                  Text(
                    user.email ?? "",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.lightGrayLbl),
                  ),
                  SizedBox(height: 8),
                  Text(
                    user.dob ?? "",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.lightGrayLbl),
                  ),
                  SizedBox(height: 16),
                  // Update Details Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Update my detail',
                      status: ButtonStatus.primary,
                      onPressed: () async {
                        // Navigate to Contact Detail Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactDetailPage(contactId: user.id),
                          ),
                        ).then((_) {
                          profileViewModel.loadProfile();
                          final viewModel = Provider.of<ContactListViewModel>(context, listen: false);
                          viewModel.loadContactsFromLocal(); // Reload contacts after coming back
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}