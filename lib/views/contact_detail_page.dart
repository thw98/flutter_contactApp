import 'package:contact_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../utils/app_colors.dart';
import '../utils/data_picker_manager.dart';
import '../utils/validation.dart';
import '../viewmodels/contact_detail_view_model.dart';
import '../widgets/custom_button.dart';

class ContactDetailPage extends StatefulWidget {
  final String? contactId;

  ContactDetailPage({this.contactId});

  @override
  _ContactDetailPageState createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for form validation

  String? firstNameError;
  String? lastNameError;
  String? emailError;
  String? phoneError;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContactDetailViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.contactId == null ? 'Add Contact' : 'Contact Details', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Consumer<ContactDetailViewModel>(
          builder: (context, viewModel, child) {
            if (widget.contactId != null && viewModel.contact == null && !viewModel.isLoading) {
              Future.delayed(Duration.zero, () {
                viewModel.loadContact(widget.contactId!);
              });
            }

            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage != null) {
              return Center(child: Text(viewModel.errorMessage!));
            }

            final contact = viewModel.contact;

            if (contact == null && widget.contactId != null) {
              return Center(child: Text('Contact not found'));
            }

            final firstNameController = TextEditingController(text: contact?.firstName ?? '');
            final lastNameController = TextEditingController(text: contact?.lastName ?? '');
            final emailController = TextEditingController(text: contact?.email ?? '');
            final dobController = TextEditingController(text: contact?.dob ?? '');

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar Section
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.blue,
                          child: contact == null ?
                          Icon(
                              Icons.person,
                              size: 40,
                              color: AppColors.white,
                            ) :
                          Text(
                            '${contact.firstName[0]}${contact.lastName[0]}',
                            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300, color: AppColors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Main Information Section
                      _buildSectionTitle('Main Information'),
                      Divider(height: 18),
                      CustomTextField(
                        label: 'First Name',
                        controller: firstNameController,
                        leading: Icons.person_2_outlined,
                        placeholder: 'Enter first name..',
                        isRequired: true,
                        errorText: firstNameError,
                        validator: validateFirstName,
                      ),
                      SizedBox(height: 24),
                      CustomTextField(
                        label: "Last Name",
                        controller: lastNameController,
                        leading: Icons.person_2_outlined,
                        placeholder: 'Enter last name..',
                        isRequired: true,
                        errorText: lastNameError,
                        validator: validateLastName,
                      ),
                      SizedBox(height: 24),

                      // Sub Information Section
                      _buildSectionTitle('Sub Information'),
                      Divider(height: 18),
                      CustomTextField(
                        label: 'Email',
                        controller: emailController,
                        leading: Icons.email_outlined,
                        placeholder: 'Enter email..',
                        errorText: emailError,
                        validator: validateEmail,
                      ),
                      SizedBox(height: 24),
                      GestureDetector(
                        onTap: () async {
                          final selectedDate = await DatePickerManager.selectDate(context, initialDate: dobController.text);
                          if (selectedDate != null) {
                            dobController.text = selectedDate;
                          }
                        },
                        child: AbsorbPointer(
                          child: CustomTextField(
                            label: 'Date of Birth',
                            controller: dobController,
                            leading: Icons.calendar_today_outlined,
                            placeholder: 'Enter birthday..',
                          ),
                        ),
                      ),

                      SizedBox(height: 50),

                      // Action Buttons
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text: widget.contactId == null ? 'Save' : 'Update',
                              status: ButtonStatus.primary,
                              onPressed: () async {
                                // Validate the form before proceeding
                                if (_formKey.currentState!.validate()) {
                                  final updatedContact = contact == null
                                      ? User(
                                    id: '',
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    email: emailController.text,
                                    dob: dobController.text,
                                  )
                                      : contact.copyWith(
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    email: emailController.text,
                                    dob: dobController.text,
                                  );

                                  if (widget.contactId == null) {
                                    await viewModel.addContact(updatedContact);
                                  } else {
                                    await viewModel.updateContact(context, updatedContact);
                                  }
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                          if (widget.contactId != null) ...[
                            SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                text: 'Remove',
                                status: ButtonStatus.secondary,
                                onPressed: () async {
                                  await viewModel.removeContact(contact!.id);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 15, color: AppColors.blue, fontStyle: FontStyle.italic),
    );
  }
}