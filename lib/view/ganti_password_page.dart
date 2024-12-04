import 'package:flutter/material.dart';
import 'user.dart';

class GantiPasswordPage extends StatefulWidget {
  final User user;
  final Future<bool> Function(BuildContext, String, String) changePassword;

  const GantiPasswordPage({
    super.key,
    required this.user,
    required this.changePassword,
  });

  @override
  _GantiPasswordPageState createState() => _GantiPasswordPageState();
}

class _GantiPasswordPageState extends State<GantiPasswordPage> {
  String? oldPassword;
  String? newPassword;
  String? confirmPassword;

  // Fungsi untuk menampilkan konfirmasi sebelum mengganti password
  void _showConfirmationDialog(BuildContext context) {
    // Cek apakah semua input sudah diisi
    if (oldPassword == null ||
        newPassword == null ||
        confirmPassword == null ||
        oldPassword!.isEmpty ||
        newPassword!.isEmpty ||
        confirmPassword!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom harus diisi.')),
      );
      return; // Tidak menampilkan dialog jika ada kolom yang kosong
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFEAD8B0),
        title: const Text('Konfirmasi Penggantian Password'),
        content: const Text('Apakah Anda yakin ingin mengganti password?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Menutup dialog jika dibatalkan
            },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF001f3f), // Warna teks
                backgroundColor:const Color(0xFF6A9AB0), // Warna tombol
              ),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Menutup dialog sebelum mengganti password
              
              // Cek kecocokan password baru dan konfirmasi
              if (newPassword != confirmPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Password baru dan konfirmasi password tidak cocok.')),
                );
                return;
              }

              // Proses penggantian password
              if (await widget.changePassword(
                  context, oldPassword!, newPassword!)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Password berhasil diganti.')),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password lama salah.')),
                );
              }
            },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF001f3f), // Warna teks
                backgroundColor:const Color(0xFF6A9AB0), // Warna tombol
              ),
            child: const Text('YA'),
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
          'Ganti Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFF001F3F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password lama',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Inputkan kata sandi lama',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      onChanged: (value) => setState(() {
                        oldPassword = value;
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFF001F3F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password baru',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Inputkan kata sandi baru',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      onChanged: (value) => setState(() {
                        newPassword = value;
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFF001F3F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Konfirmasi password baru',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Konfirmasi kata sandi baru',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      onChanged: (value) => setState(() {
                        confirmPassword = value;
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _showConfirmationDialog(context); // Menampilkan dialog konfirmasi
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A9AB0),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 30.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'SIMPAN',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}