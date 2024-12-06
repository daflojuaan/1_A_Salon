import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:a_salon/view/camera_profile_page.dart';
import 'package:a_salon/view/pengaturan_profile_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final int? userid;
  const ProfileScreen({Key? key, this.userid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = {};
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Ambil ID pengguna dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt('userId');

      if (id == null) {
        throw Exception('User ID not found. Please log in.');
      }

      // Permintaan ke API menggunakan ID pengguna
      final response = await http.get(
        Uri.parse(
            'http://192.168.237.62:8000/api/profile/$id'), // Sesuaikan endpoint
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(
              response.body)['data']; // Sesuaikan struktur data respons API
          print('Decoded data structure: $userData');
          // print('Username: ${userData['username']}');
          print('Username: ${userData['user']['username']}');
          _isLoading = false;
        });
      } else {
        throw Exception('Response body: ${response.body}'
            'Failed to load user data. Status code: ${response.statusCode}. Testing id: ${id}');
      }
    } catch (e) {
      // Tangani kesalahan dengan notifikasi atau logging
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
        await _uploadProfileImage(_profileImage!);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _uploadProfileImage(File image) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        throw Exception('User not logged in');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.237.62/api/profile/image'),
      );

      request.headers.addAll({
        'Accept': 'application/json',
      });

      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (mounted) {
          setState(() {
            userData['profile_image_url'] =
                responseData['data']['profile_image_url'];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile image updated successfully')),
          );
        }
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    }
  }

  Future<void> _navigateToCamera() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraView()),
      );

      if (result != null && result is String && mounted) {
        final imageFile = File(result);
        setState(() {
          _profileImage = imageFile;
        });
        await _uploadProfileImage(imageFile);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error capturing image: $e')),
        );
      }
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera, color: Color(0xFF001F3F)),
                title: const Text(
                  'Ambil dari Kamera',
                  style: TextStyle(color: Color(0xFF001F3F)),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToCamera();
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: Color(0xFF001F3F)),
                title: const Text(
                  'Pilih dari Galeri',
                  style: TextStyle(color: Color(0xFF001F3F)),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : (userData['profile_image_url'] != null
                                  ? NetworkImage(userData['profile_image_url'])
                                      as ImageProvider
                                  : null),
                          child: (_profileImage == null &&
                                  userData['profile_image_url'] == null)
                              ? const Icon(Icons.person,
                                  size: 50, color: Colors.white)
                              : null,
                          backgroundColor: const Color(0xFF001F3F),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _showImageSourceActionSheet,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF6A9AB0),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  userData['user']['username'] ?? 'Guest', // Handle null values
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildProfileInfoCard(
                  'Username', userData['user']['username'] ?? 'Not available'),
              _buildProfileInfoCard(
                  'Email', userData['user']['email'] ?? 'Not available'),
              _buildProfileInfoCard(
                  'Phone', userData['user']['phone'] ?? 'Not available'),
              _buildProfileInfoCard(
                  'Gender', userData['user']['gender'] ?? 'Not available'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfoCard(String label, String value) {
    return Card(
      color: const Color(0xFF001F3F),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  _getIconForLabel(label),
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Username':
        return Icons.person;
      case 'Email':
        return Icons.email;
      case 'Phone':
        return Icons.phone;
      case 'Gender':
        return Icons.person_outline;
      default:
        return Icons.info_outline;
    }
  }
}
