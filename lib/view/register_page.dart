import 'package:flutter/material.dart';
import 'package:a_salon/database/database_helper.dart';
import 'user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  String? _selectedGender;
  bool _isPasswordVisible = false;

  void _register() async {
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please fill in all fields'),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    bool usernameExists = await DatabaseHelper().isUsernameExists(_usernameController.text);
    if (usernameExists) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Username already exists'),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    User user = User(
      username: _usernameController.text,
      password: _passwordController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      gender: _selectedGender!,
    );

    try {
      await DatabaseHelper().insertUser(user);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Registration successful!'),
        backgroundColor: Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
      ));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error registering user: $e'),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001f3f),
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 0, 31, 63)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  Image.asset('lib/asset/logo putih.png', height: 100),
                  const SizedBox(height: 20),
                  Text(
                    'REGISTER',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 31, 63)),
                          prefixIcon: Icon(Icons.person, color: const Color.fromARGB(255, 0, 31, 63)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 31, 63)),
                          prefixIcon: Icon(Icons.lock, color: const Color.fromARGB(255, 0, 31, 63)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: const Color.fromARGB(255, 0, 31, 63),
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 31, 63)),
                          prefixIcon: Icon(Icons.email, color: const Color.fromARGB(255, 0, 31, 63)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 31, 63)),
                          prefixIcon: Icon(Icons.phone, color: const Color.fromARGB(255, 0, 31, 63)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 31, 63)),
                          prefixIcon: Icon(Icons.people, color: const Color.fromARGB(255, 0, 31, 63)),
                          border: InputBorder.none,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-Laki')),
                          DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        hint: const Text('Pilih Gender'),
                        isExpanded: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      foregroundColor: const Color.fromARGB(255, 0, 31, 63),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
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
                      Text(
                        'Already have an account? ',
                        style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Login here',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 234, 216, 177),
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
      ),
    );
  }
}