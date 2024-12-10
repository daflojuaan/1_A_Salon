import 'package:flutter/material.dart';

class GantiPasswordPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  
  final Future<bool> Function(String, String) onPasswordChanged;

  const GantiPasswordPage({
    Key? key, 
    required this.userData,
    required this.onPasswordChanged,
  }) : super(key: key);

  @override
  _GantiPasswordPageState createState() => _GantiPasswordPageState();
}

class _GantiPasswordPageState extends State<GantiPasswordPage> {
  String? oldPassword;
  String? newPassword;
  String? confirmPassword;
  bool _isLoading = false;

  void _showConfirmationDialog() {
    if (oldPassword == null || 
        newPassword == null || 
        confirmPassword == null ||
        oldPassword!.isEmpty || 
        newPassword!.isEmpty || 
        confirmPassword!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom harus diisi')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password baru dan konfirmasi password tidak cocok'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFEAD8B0),
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin mengganti password?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF001f3f),
              backgroundColor: const Color(0xFF6A9AB0),
            ),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: _isLoading ? null : _handleChangePassword,
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

  Future<void> _handleChangePassword() async {
    try {
      setState(() => _isLoading = true);
      Navigator.of(context).pop();

      final success = await widget.onPasswordChanged(oldPassword!, newPassword!);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password berhasil diubah')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengubah password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
            color: Color(0xFF001F3F),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF001F3F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPasswordField(
                    'Password lama',
                    'Inputkan kata sandi lama',
                    (value) => setState(() => oldPassword = value),
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                    'Password baru',
                    'Inputkan kata sandi baru',
                    (value) => setState(() => newPassword = value),
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                    'Konfirmasi password baru',
                    'Konfirmasi kata sandi baru',
                    (value) => setState(() => confirmPassword = value),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _showConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A9AB0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 30.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      _isLoading ? 'MENYIMPAN...' : 'SIMPAN',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
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

  Widget _buildPasswordField(
    String label,
    String hint,
    ValueChanged<String> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF001F3F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
            style: const TextStyle(color: Colors.white),
            obscureText: true,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
