import 'package:flutter/material.dart';
import 'ganti_password_page.dart';
import 'user.dart';
import 'package:a_salon/database/database_helper.dart';

class PengaturanProfilePage extends StatelessWidget {
  final User user;

  const PengaturanProfilePage({super.key, required this.user});

  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GantiPasswordPage(
          user: user,
          changePassword: _changePassword,
        ),
      ),
    );
  }

  Future<bool> _changePassword(
      BuildContext context, String oldPassword, String newPassword) async {
    User? user =
        await DatabaseHelper().getUser(this.user.username, oldPassword);

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

  void _deleteAccount(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFC107),
        title: const Text('Konfirmasi Penghapusan Akun'),
        content: const Text('Apakah Anda yakin ingin menghapus akun ini?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); 
              await DatabaseHelper().deleteUser(user.username);

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Akun Anda berhasil terhapus.'),
              ));

              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pengaturan Profil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InkWell(
              onTap: () => _navigateToChangePassword(context),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF6A9AB0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.lock, color: Colors.white),
                    SizedBox(width: 16),
                    Text(
                      'Ganti Password',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () => _deleteAccount(context),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.red[600],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.delete, color: Colors.white),
                    SizedBox(width: 16),
                    Text(
                      'Delete Account',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}