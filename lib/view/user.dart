class User {
  final int id;
  final String username;
  final String password;  // tambahkan ini
  final String email;
  final String phone;
  final String gender;

  User({
    required this.id,
    required this.username,
    this.password = '',  // buat opsional dengan default value
    required this.email,
    required this.phone,
    required this.gender,
  });
  
  // Convert User object to a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'phone': phone,
      'gender': gender,
    };
  }

  // Convert a Map into a User object
  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      email: map['email'],
      phone: map['phone'],
      gender: map['gender'],
    );
  }

  // Method to update the user details
  User copyWith({
    String? username,
    String? password,
    String? email,
    String? phone,
    String? gender,
  }) {
    return User(
      id: this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
    );
  }
}