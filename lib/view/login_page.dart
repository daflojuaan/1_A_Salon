import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:a_salon/view/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    final url = Uri.parse('http://192.168.237.62:8000/api/login');

    try {
      // Kirim permintaan login ke API
      final response = await http.post(
        url,
        body: json.encode({
          'username': _usernameController.text.trim(),
          'password': _passwordController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      // Debugging: Tampilkan status kode dan respons dari server
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parsing data dari respons API
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Response Data: $responseData');

        if (responseData['status'] == 'success') {
          // Ambil data pengguna
          final userData = responseData['data']['user']; // Sesuaikan dengan struktur respons API
          print('User Data: $userData');

          // Simpan ID pengguna ke SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userId', userData['id']);
          await prefs.setString('username', userData['username']);

          print('User data berhasil disimpan di SharedPreferences.');

          // Navigasi ke HomeView setelah login berhasil
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        } else {
          // Tampilkan pesan error dari API
          final errorMessage = responseData['message'] ?? 'Username atau password salah';
          showAlertDialog(context, 'Login Gagal', errorMessage);
        }
      } else {
        // Tampilkan pesan error untuk respons dengan status kode selain 200
        showAlertDialog(context, 'Login Gagal', 'Terjadi kesalahan saat login. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Tangani error saat mencoba terhubung ke server
      print('Error saat login: $e');
      showAlertDialog(context, 'Error', 'Tidak dapat terhubung ke server. Periksa koneksi Anda.');
    }
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF001f3f),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'lib/asset/logo putih.png',
                width: 400,
                height: 150,
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF001f3f),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _usernameController,
                        icon: Icons.person,
                        label: 'Username',
                        hint: 'Enter your username',
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _passwordController,
                        icon: Icons.lock,
                        label: 'Password',
                        hint: 'Enter your password',
                        isPassword: true,
                      ),
                      const SizedBox(height: 20),
                      _buildLoginButton(),
                      const SizedBox(height: 20),
                      _buildRegisterLink(),
                      // const SizedBox(height: 10),
                      // _buildForgotPasswordLink(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hint,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF001f3f)),
        hintText: hint,
        labelText: label,
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF001f3f),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 80,
          vertical: 15,
        ),
      ),
      onPressed: _loginUser,
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, '/register'),
      child: const Text(
        'Don\'t have an account? Register here',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  // Widget _buildForgotPasswordLink() {
  //   return TextButton(
  //     onPressed: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
  //       );
  //     },
  //     child: const Text(
  //       'Forgot Password?',
  //       style: TextStyle(color: Colors.black),
  //     ),
  //   );
  // }
}