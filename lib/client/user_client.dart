// import 'package:a_salon/entity/user.dart';
// import 'dart:convert';
// import 'package:http/http.dart';

// class UserClient {
//   static final String url = '192.168.237.62';
//   static final String endpoint = '/1_A_Salon_API/public/api';

//   static Future<Response> create(User user) async {
//     try {
//       var response = await post(
//         Uri.parse('http://192.168.237.62:8000/api/register'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: user.toRawJson(),
//       );

//       if (response.statusCode != 201) {
//         throw Exception('Failed to create user: ${response.reasonPhrase}');
//       }

//       return response;
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   static Future<Response> login(String username, String password) async {
//     try {
//       var response = await post(
//         Uri.parse('http://192.168.237.62:8000/api/login'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',

//         },
//         body: json.encode({
//           'username': username,
//           'password': password,
//         }),
//       );

//       if (response.statusCode != 200 && response.statusCode != 201) {
//         throw Exception('Login failed: ${response.body}');
//       }

//       return response;
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   static Future<Response> getProfile(int id) async {
//     try {
//       var response = await get(
//         Uri.parse('http://192.168.237.62:8000/api/profile/$id'),
//         headers: {
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode != 200) {
//         throw Exception('Failed to get profile: ${response.body}');
//       }

//       return response;
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }

//   static Future<Response> updateProfile(int id, User user) async {
//     try {
//       var response = await put(
//         Uri.parse('http://192.168.237.62:8000/api/profile/$id'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: json.encode({
//           'username': user.username,
//           'email': user.email,
//           'phone': user.phone,
//           'gender': user.gender,
//         }),
//       );

//       if (response.statusCode != 200) {
//         throw Exception('Failed to update profile: ${response.body}');
//       }

//       return response;
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }
// }
