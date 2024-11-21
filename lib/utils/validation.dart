// Validate First Name
String? validateFirstName(String? value) {
  if (value == null || value.isEmpty) {
    return 'First name is required';
  }
  return null;
}

// Validate Last Name
String? validateLastName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Last name is required';
  }
  return null;
}

// Validate Email
String? validateEmail(String? value) {
  if (value != null && value.isNotEmpty) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
  }
  return null;
}