import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:a_salon/view/camera_profile_page.dart';
import 'package:a_salon/view/edit_profile_page.dart';
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
  String? _savedImageUrl;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Future<void> _loadSavedImageUrl() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final savedUrl = prefs.getString('profile_image_url');
  //   if (savedUrl != null && mounted) {
  //     setState(() {
  //       _savedImageUrl = savedUrl;
  //     });
  //   }
  // }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt('userId');

      print('Loading data for user ID: $id');

      if (id == null) {
        throw Exception('User ID not found. Please log in.');
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/profile/$id'),
        headers: {'Accept': 'application/json'},
      );

      print('Profile load response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            userData = data['data'];
            // Update foto profile jika ada
            if (data['data']['user']['photo'] != null) {
              _savedImageUrl = data['data']['user']['photo'];
              // prefs.setString('profile_image_url', _savedImageUrl!);
            }
            _isLoading = false;
          });
        }
      } else {
        throw Exception(
            'Failed to load user data. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _uploadProfileImage(File image) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      print('Uploading image for user ID: $userId'); // Debug print
      print('Image path: ${image.path}'); // Debug print

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8000/api/profile/photo/$userId'),

      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data',
      });

      var photoFile = await http.MultipartFile.fromPath('photo', image.path);
      print('File size: ${photoFile.length} bytes'); // Debug print
      request.files.add(photoFile);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status code: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (mounted) {
          setState(() {
            _profileImage = image;
            if (responseData['data'] != null &&
                responseData['data']['photo'] != null) {
              _savedImageUrl = responseData['data']['photo'];
              // prefs.setString('profile_image_url', _savedImageUrl!);
            }
          });
        }
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading: $e'); // Debug print
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
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
                title: const Text('Ambil dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToCamera();
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: Color(0xFF001F3F)),
                title: const Text('Pilih dari Galeri'),
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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
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
                              : (_savedImageUrl != null && _savedImageUrl!.isNotEmpty
                                  ? NetworkImage(_savedImageUrl!)
                                  : null) as ImageProvider?,
                          child: (_profileImage == null && 
                                  (_savedImageUrl == null || _savedImageUrl!.isEmpty))
                              ? const Icon(Icons.person, size: 50, color: Colors.white)
                              : null,
                          backgroundColor: const Color(0xFF001F3F),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _showImageSourceActionSheet,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF6A9AB0),
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
                  userData['user']['username'] ?? 'Guest',
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
              const SizedBox(height: 20),
              // Settings Button
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PengaturanProfilePage(
                          userData: userData['user'],
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A9AB0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    minimumSize: const Size(0, 20),
                  ),
                  child: const Text('Settings', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                userData: userData['user'],
                              ),
                            ),
                          );

                          if (result == true) {
                            await _loadUserData();
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A9AB0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Edit Profile',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // PIN creation logic will be implemented here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A9AB0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Buat PIN',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
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
