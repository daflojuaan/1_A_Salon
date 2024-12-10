import 'dart:convert';

class User {
  int id;
  String username;
  String password;
  String email;
  String phone;
  String? gender;

  User(
      {required this.id,
      required this.username,
      required this.password,
      required this.email,
      required this.phone,
      required this.gender});

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        password: json["password"],
        email: json["email"],
        phone: json["phone"],
        gender: json["gender"],
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "email": email,
        "phone": phone,
        "gender": gender,
      };
}
