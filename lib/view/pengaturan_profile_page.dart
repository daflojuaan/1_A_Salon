import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:a_salon/view/ganti_password_page.dart';

class PengaturanProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const PengaturanProfilePage({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  _PengaturanProfilePageState createState() => _PengaturanProfilePageState();
}

class _PengaturanProfilePageState extends State<PengaturanProfilePage> {
  final String ip = "10.0.0.2";
  bool _isLoading = false;

  void _navigateToLogin() {
    // Pastikan navigasi dilakukan pada context yang benar
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Future<void> _showSuccessDialog(BuildContext context, String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFEAD8B0),
        title: const Text('Berhasil'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              // Tutup dialog terlebih dahulu
              Navigator.of(dialogContext).pop();
              // Kemudian navigasi ke login
              _navigateToLogin();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF001f3f),
              backgroundColor: const Color(0xFF6A9AB0),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GantiPasswordPage(
          userData: widget.userData,
          onPasswordChanged: _handlePasswordChange,
        ),
      ),
    );
  }

  Future<bool> _handlePasswordChange(
      String oldPassword, String newPassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        throw Exception('User not logged in');
      }

      final response = await http.put(
        Uri.parse('http://$ip/api/profile/password/$userId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'current_password': oldPassword,
          'new_password': newPassword,
          'password_confirmation': newPassword,
        }),
      );

      print('Password change response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (!mounted) return false;

        // Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) => AlertDialog(
            backgroundColor: const Color(0xFFEAD8B0),
            title: const Text('Berhasil'),
            content: const Text('Password berhasil diubah'),
            actions: [
              TextButton(
                onPressed: () {
                  // Close dialog first
                  Navigator.of(dialogContext).pop();
                  // Then go back to profile page
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF001f3f),
                  backgroundColor: const Color(0xFF6A9AB0),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        );

        return true;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update password');
      }
    } catch (e) {
      print('Error changing password: $e');
      if (!mounted) return false;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );

      return false;
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        throw Exception('User not logged in');
      }

      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8000/api/profile/delete/$userId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      // Clear preferences setelah response diterima
      await prefs.clear();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // Tampilkan dialog dan tunggu sampai selesai
        await _showSuccessDialog(context, 'Akun berhasil dihapus');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus akun')),
        );
        _navigateToLogin();
      }
    } catch (e) {
      print('Error deleting account: $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      _navigateToLogin();
    }
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFEAD8B0),
        title: const Text('Konfirmasi Penghapusan Akun'),
        content: const Text('Apakah Anda yakin ingin menghapus akun ini?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF001f3f),
              backgroundColor: const Color(0xFF6A9AB0),
            ),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: _isLoading
                ? null
                : () {
                    Navigator.of(dialogContext).pop();
                    _deleteAccount(context);
                  },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF001f3f),
              backgroundColor: const Color(0xFF6A9AB0),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      
      await prefs.remove('profile_image_url');

      if (userId == null) {
        throw Exception('User not logged in');
      }

      final response = await http.post(
        Uri.parse('http://192.168.237.62:8000/api/profile/logout/$userId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      // Clear preferences setelah response diterima
      await prefs.clear();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // Tampilkan dialog dan tunggu sampai selesai
        await _showSuccessDialog(context, 'Berhasil logout');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal logout')),
        );
        _navigateToLogin();
      }
    } catch (e) {
      print('Error logging out: $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      _navigateToLogin();
    }
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFEAD8B0),
        title: const Text("KONFIRMASI"),
        content: const Text("Apakah ingin keluar dari akun?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF001f3f),
              backgroundColor: const Color(0xFF6A9AB0),
            ),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: _isLoading
                ? null
                : () {
                    Navigator.of(dialogContext).pop();
                    _logout(context);
                  },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF001f3f),
              backgroundColor: const Color(0xFF6A9AB0),
            ),
            child: const Text('Ya'),
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
        title: const Text(
          'Pengaturan Profil',
          style: TextStyle(color: Color(0xFF001F3F)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF001F3F)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: _isLoading
                      ? null
                      : () => _navigateToChangePassword(context),
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
                  onTap:
                      _isLoading ? null : () => _confirmDeleteAccount(context),
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
                InkWell(
                  onTap: _isLoading ? null : () => _confirmLogout(context),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.orange[600],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 16),
                        Text(
                          'Logout',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
}
