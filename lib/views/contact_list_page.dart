import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/contact_list_view_model.dart';
import '../models/user.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_search_box.dart';
import 'contact_detail_page.dart';

class ContactListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'My Contacts',
            style: TextStyle(color: AppColors.black, fontSize: 23, fontWeight: FontWeight.w700),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Container(
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 10.0),
              child: Consumer<ContactListViewModel>(
                builder: (context, viewModel, child) {
                  return CustomSearchBox(
                    onSearchChanged: (query) {
                      viewModel.updateSearchQuery(query);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
      body: Consumer<ContactListViewModel>(
        builder: (context, viewModel, child) {
          // If data is loading, show the progress indicator
          if (viewModel.isLoading) {
            viewModel.loadContactsFromLocal();
            return const Center(child: CircularProgressIndicator());
          }

          // Group contacts by the first letter of their first name, filtered by the search query
          Map<String, List<User>> groupedContacts = {};
          for (var contact in viewModel.filteredContacts) {
            final initial = contact.firstName[0].toUpperCase();
            groupedContacts.putIfAbsent(initial, () => []).add(contact);
          }

          return Container(
            color: Colors.white70,
            padding: const EdgeInsets.all(16.0),
            child: RefreshIndicator(
              onRefresh: () async {
                // Reload contacts from data.json when pulling to refresh
                await viewModel.loadContactsFromJson();
              },
              child: ListView(
                children: groupedContacts.entries.map((entry) {
                  final initial = entry.key;
                  final group = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Group title with divider
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                initial,
                                style: const TextStyle(
                                  color: AppColors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Divider(
                                color: AppColors.darkGray,
                                thickness: 0.5,
                              ),
                            ],
                          ),
                        ),
                        // List of contacts in this group
                        ...group.map((contact) {
                          final isLoggedInUser = contact.id == viewModel.loggedInUserId;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                child: Text(
                                  '${contact.firstName[0]}${contact.lastName[0]}',
                                  style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300),
                                ),
                                backgroundColor: AppColors.blue,
                              ),
                              title: RichText(
                                text: TextSpan(
                                  text: '${contact.firstName} ${contact.lastName}',
                                  style: const TextStyle(
                                      color: AppColors.contactLbl,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                  children: [
                                    if (isLoggedInUser)
                                      TextSpan(
                                        text: ' (you)',
                                        style: const TextStyle(color: AppColors.darkGray, fontStyle: FontStyle.italic),
                                      ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                // Navigate to Contact Detail Page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ContactDetailPage(contactId: contact.id),
                                  ),
                                ).then((_) {
                                  viewModel.loadContactsFromLocal(); // Reload contacts after coming back
                                });
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          final viewModel = Provider.of<ContactListViewModel>(context, listen: false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactDetailPage(),
            ),
          ).then((_) {
            viewModel.loadContactsFromLocal();
          });
        },
        child: const Icon(Icons.add, color: AppColors.white),
        backgroundColor: AppColors.blue,
      ),
    );
  }
}