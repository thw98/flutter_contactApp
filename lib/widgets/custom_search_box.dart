import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CustomSearchBox extends StatefulWidget {
  final Function(String) onSearchChanged;

  CustomSearchBox({required this.onSearchChanged});

  @override
  _CustomSeachBoxState createState() => _CustomSeachBoxState();
}

class _CustomSeachBoxState extends State<CustomSearchBox> {
  final FocusNode _focusNode = FocusNode(); // Track focus state
  bool _isFocused = false; // Track if the TextField is focused

  @override
  void initState() {
    super.initState();
    // Listen to focus changes and update the state
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode, // Attach focus node to TextField
      onChanged: widget.onSearchChanged, // Update search query in the ViewModel
      decoration: InputDecoration(
        hintText: 'Search your contact list...',
        hintStyle: TextStyle(color: AppColors.placeholder, fontWeight: FontWeight.w300),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(width: 1.0, color: AppColors.darkGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.blue), // Color when focused
        ),
        filled: true, // Background filled with white color
        fillColor: Colors.transparent, // Transparent background
        suffixIcon: GestureDetector(
          onTap: () {
            if (_isFocused) {
              FocusScope.of(context).unfocus();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              _isFocused ? 'assets/icons/icon_search_selected.png' : 'assets/icons/icon_search_unselected.png',
            ),
          ),
        ),
      ),
    );
  }
}