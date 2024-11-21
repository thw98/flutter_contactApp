class User {
  final String id;
  late final String firstName;
  late final String lastName;
  late final String? email;
  late final String? dob;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.dob,
  });

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String?,
      dob: json['dob'] as String?,
    );
  }

  // Convert the User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dob': dob,
    };
  }

  // copyWith method to update fields
  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? dob,
  }) {
    return User(
      id: id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      dob: dob ?? this.dob,
    );
  }
}