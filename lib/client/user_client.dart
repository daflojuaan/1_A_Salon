import 'package:a_salon/entity/user.dart';
import 'dart:convert';
import 'package:http/http.dart';

class UserClient {
  static final String url = '192.168.1.153';
  static final String endpoint = '/1_A_Salon_API/public/api';

  static Future<List<User>> fetchAll() async {
    try {
      var response = await get(Uri.http(url, '$endpoint/'));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      Iterable list = json.decode(response.body)['data'];

      return list.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> create(User user) async {
    try {
      var response = await post(
        Uri.parse('http://10.0.2.2:8000/api/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: user.toRawJson(),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create user: ${response.reasonPhrase}');
      }

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> login(String username, String password) async {
    try {
      var response = await post(
        Uri.parse('http://10.0.2.2:8000/api/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Login failed: ${response.body}');
      }

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
  
}
