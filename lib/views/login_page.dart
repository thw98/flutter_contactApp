import 'package:contact_app/widgets/custom_button.dart';
import 'package:contact_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../utils/text_utils.dart';
import 'home_page.dart';
import '../viewmodels/login_view_model.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _userIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<LoginViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  const Text(
                    'Hi There!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please login to see your contact list',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff7F7F7F),
                    ),
                  ),
                  const SizedBox(height: 30),

                  CustomTextField(
                    label: "User ID",
                    controller: _userIdController,
                    leading: Icons.person_2_outlined,
                    isRequired: true),
                  if (viewModel.errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      viewModel.errorMessage!,
                      style: const TextStyle(color: AppColors.red),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: "Login",
                      status: ButtonStatus.primary,
                      onPressed: () async {
                        final userId = _userIdController.text.trim();
                        final success = await viewModel.handleLogin(userId);

                        if (success) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        }
                      },
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}