import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:a_salon/database/database_helper.dart';
import 'package:a_salon/view/camera_profile_page.dart';
import 'user.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

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
      MaterialPageRoute(
        builder: (context) => CameraView(),
      ),
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
                leading: const Icon(Icons.camera),
                title: const Text('Ambil dari Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
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

  void _deleteAccount(BuildContext context) async {
    await DatabaseHelper().deleteUser(widget.user.username);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Akun Anda berhasil terhapus.'),
    ));

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _logout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Anda berhasil Logout.'),
    ));

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String? oldPassword;
        String? newPassword;
        return AlertDialog(
          title: const Text('Ganti Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Password Lama'),
                obscureText: true,
                onChanged: (value) => oldPassword = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Password Baru'),
                obscureText: true,
                onChanged: (value) => newPassword = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (oldPassword == null ||
                    oldPassword!.isEmpty ||
                    newPassword == null ||
                    newPassword!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Password lama dan baru harus diisi.')),
                  );
                  return;
                }

                if (await _changePassword(oldPassword!, newPassword!)) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password berhasil diganti.')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password lama salah.')),
                  );
                }
              },
              child: const Text('Ganti'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _changePassword(String oldPassword, String newPassword) async {
    User? user =
        await DatabaseHelper().getUser(widget.user.username, oldPassword);

    if (user != null) {
      User updatedUser = User(
        id: user.id,
        username: user.username,
        password: newPassword,
        email: user.email,
        phone: user.phone,
        gender: user.gender,
      );

      await DatabaseHelper().updateUserPassword(updatedUser);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _showImageSourceActionSheet,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF6A9AB0),
                          ),
                          padding: const EdgeInsets.all(8),
                          child:
                              const Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                  height:
                      10), // Add spacing between the avatar and the username
              Center(
                child: Text(
                  widget.user.username, // Display the username
                  style: const TextStyle(
                    fontSize: 20, // Adjust font size for the username
                    fontWeight: FontWeight.bold, // Make the username bold
                    color: Colors
                        .black, // Color of the username text (you can change this)
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildProfileInfoCard('Username', widget.user.username),
              _buildProfileInfoCard('Email', widget.user.email),
              _buildProfileInfoCard('Phone', widget.user.phone),
              _buildProfileInfoCard('Gender', widget.user.gender),
              const SizedBox(height: 10),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: _showChangePasswordDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A9AB0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    minimumSize: const Size(0, 40),
                  ),
                  child: const Text('Ganti Password',
                      style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () => _deleteAccount(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A9AB0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    minimumSize: const Size(0, 40),
                  ),
                  child: const Text('Delete Account',
                      style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () => _logout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A9AB0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    minimumSize: const Size(0, 40),
                  ),
                  child: const Text('Logout', style: TextStyle(fontSize: 16)),
                ),
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
      margin: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 12), // Adjusted margin to make the card smaller
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12), // Reduced padding for a more compact layout
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  _getIconForLabel(label),
                  color: Colors.white,
                  size: 20, // Reduced icon size for a smaller look
                ),
                const SizedBox(
                    width: 8), // Reduced spacing between icon and label
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16, // Smaller font size for a compact look
                  ),
                ),
              ],
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 14, // Reduced font size for the value text
                  color: Colors.white,
                ),
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