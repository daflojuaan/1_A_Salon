import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  
  const EditProfilePage({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final String ip = "192.168.0.62"; //kalo mau ganti ip dari sini aja 


  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String _selectedGender = 'Laki-laki';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.userData['username']);
    _emailController = TextEditingController(text: widget.userData['email']);
    _phoneController = TextEditingController(text: widget.userData['phone']);
    _selectedGender = widget.userData['gender'] ?? 'Laki-laki';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Debug print untuk melihat data yang akan dikirim
      print('Sending update for user ID: $userId');
      print('Update data: ${json.encode({
        'username': _usernameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'gender': _selectedGender,
      })}');

      final response = await http.put(
        Uri.parse('http://$ip:8000/api/profile/update/$userId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': _usernameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'gender': _selectedGender,
        }),
      );

      // Debug print untuk response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _confirmSaveChanges() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFEAD8B0),
          title: const Text("KONFIRMASI"),
          content: const Text("Yakin Ingin Mengubah Data?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF001f3f),
                backgroundColor: const Color(0xFF6A9AB0),
              ),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveChanges();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF001f3f),
                backgroundColor: const Color(0xFF6A9AB0),
              ),
              child: const Text('YA'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Color(0xFF001F3F)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF001F3F)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInputFieldWithIcon(
                        _usernameController,
                        'Username',
                        Icons.person,
                        'Inputkan username baru',
                      ),
                      const SizedBox(height: 16),
                      _buildInputFieldWithIcon(
                        _emailController,
                        'Email',
                        Icons.email,
                        'Inputkan email baru',
                      ),
                      const SizedBox(height: 16),
                      _buildInputFieldWithIcon(
                        _phoneController,
                        'Nomor Telepon',
                        Icons.phone,
                        'Inputkan nomor telepon baru',
                      ),
                      const SizedBox(height: 16),
                      _buildGenderDropdown(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _confirmSaveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A9AB0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    _isLoading ? 'Updating...' : 'Simpan Perubahan',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputFieldWithIcon(
    TextEditingController controller,
    String labelText,
    IconData icon,
    String hintText,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF001F3F),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.white),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
        trailing: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF001F3F),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<String>(
        isExpanded: true,
        value: _selectedGender,
        onChanged: _isLoading
            ? null
            : (String? newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
        items: <String>['Laki-laki', 'Perempuan']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                Icon(
                  value == 'Laki-laki' ? Icons.male : Icons.female,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }).toList(),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        dropdownColor: const Color(0xFF001F3F),
        underline: const SizedBox(),
      ),
    );
  }
}