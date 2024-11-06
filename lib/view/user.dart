class User {
  final int? id;
  final String username;
  final String password;
  final String email;
  final String phone;
  final String gender;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
    required this.gender,
  });

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
}
