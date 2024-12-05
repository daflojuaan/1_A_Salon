  import 'dart:io';
  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:a_salon/view/camera_profile_page.dart';
  import 'package:a_salon/view/pengaturan_profile_page.dart';
  import 'package:a_salon/view/edit_profile_page.dart';
  import 'user.dart';

  class ProfileScreen extends StatefulWidget {
    final User user;

    const ProfileScreen({super.key, required this.user});

    @override
    _ProfileScreenState createState() => _ProfileScreenState();
  }

  class _ProfileScreenState extends State<ProfileScreen> {
    late User _user; 
    File? _profileImage;
    final ImagePicker _picker = ImagePicker();

    @override
    void initState() {
      super.initState();
      _user = widget.user; 
    }

    Future<void> _pickImage(ImageSource source) async {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    }

    Future<void> _navigateToCamera() async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraView()),
      );

      if (result != null && result is String) {
        setState(() {
          _profileImage = File(result);
        });
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
                  leading: const Icon(
                    Icons.camera,
                    color: Color(0xFF001F3F), 
                  ),
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
                  leading: const Icon(
                    Icons.photo_library,
                    color: Color(0xFF001F3F), 
                  ),
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

    void _updateUser(User updatedUser) {
      setState(() {
        _user = updatedUser; 
      });
    }

  @override
    Widget build(BuildContext context) {
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
                                : null,
                            child: _profileImage == null
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
                                child: const Icon(Icons.camera_alt, color: Colors.white),
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
                    _user.username,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildProfileInfoCard('Username', _user.username),
                _buildProfileInfoCard('Email', _user.email),
                _buildProfileInfoCard('Phone', _user.phone),
                _buildProfileInfoCard('Gender', _user.gender),
                const SizedBox(height: 20),
                // Settings Button
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PengaturanProfilePage(user: _user),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A9AB0),
                      foregroundColor: Colors.white, 
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                          final updatedUser = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(user: _user),
                            ),
                          );

                          if (updatedUser != null) {
                            _updateUser(updatedUser);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A9AB0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text('Edit Profile', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 10), 
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Logika untuk membuat PIN 
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A9AB0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text('Buat PIN', style: TextStyle(fontSize: 16)),
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
          return Icons.transgender;
        default:
          return Icons.info;
      }
    }
  }