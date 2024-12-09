import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:a_salon/entity/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, this.id});
  final int? id;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  bool _isPasswordVisible = false;
  String? _selectedGender;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.237.62:8000/api/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
            'username': _usernameController.text,
            'password': _passwordController.text,
            'email': _emailController.text,
            'phone': _phoneController.text,
            'gender': _selectedGender,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
          _showMessage('Register Success', isError: false);
          Navigator.pop(context);
      } else {
          final responseData = json.decode(response.body);
          if (responseData['status'] == 'error' && responseData['errors'] != null) {
              // Tampilkan error validasi spesifik
              final errors = responseData['errors'] as Map<String, dynamic>;
              final firstError = errors.values.first[0];
              _showMessage(firstError, isError: true);
          } else {
              _showMessage(responseData['message'] ?? 'Registration failed', isError: true);
          }
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage('Connection error. Please try again.', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          textColor: Colors.white,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  bool _validateInputs() {
    if (_usernameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _selectedGender == null) {
      _showMessage('All fields are required!', isError: true);
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text)) {
      _showMessage('Please enter a valid email address', isError: true);
      return false;
    }

    if (!RegExp(r'^\d{10,}$').hasMatch(_phoneController.text)) {
      _showMessage('Phone number must be at least 10 digits', isError: true);
      return false;
  }

    if (_passwordController.text.length < 8) {
      _showMessage('Password must be at least 8 characters', isError: true);
      return false;
    }

    return true;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextField(
          controller: controller,
          obscureText: isPassword && !_isPasswordVisible,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Color(0xFF001f3f)),
            prefixIcon: Icon(icon, color: const Color(0xFF001f3f)),
            suffixIcon: isPassword ? _buildPasswordVisibilityToggle() : null,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        color: const Color(0xFF001f3f),
      ),
      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
    );
  }

  Widget _buildGenderDropdown() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: DropdownButtonFormField<String>(
          value: _selectedGender,
          decoration: const InputDecoration(
            labelText: 'Gender',
            labelStyle: TextStyle(color: Color(0xFF001f3f)),
            prefixIcon: Icon(Icons.people, color: Color(0xFF001f3f)),
            border: InputBorder.none,
          ),
          items: const [
            DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-Laki')),
            DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
          ],
          onChanged: (value) => setState(() => _selectedGender = value),
          hint: const Text('Pilih Gender'),
          isExpanded: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001f3f),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset('lib/asset/logo putih.png', height: 100),
                const SizedBox(height: 20),
                const Text(
                  'REGISTER',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _usernameController,
                  label: 'Username',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildGenderDropdown(),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading ? null : _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF001f3f),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'REGISTER',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Login here',
                        style: TextStyle(
                          color: Color(0xFFEAD8B1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}