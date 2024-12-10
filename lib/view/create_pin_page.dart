// create_pin_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePinPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const CreatePinPage({super.key, required this.userData});

  @override
  _CreatePinPageState createState() => _CreatePinPageState();
}

class _CreatePinPageState extends State<CreatePinPage> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  bool _isPinVisible = false;
  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> _createPin() async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    String pin = _pinController.text;
    String confirmPin = _confirmPinController.text;

    if (pin.length != 6) {
      setState(() {
        _errorMessage = 'PIN harus terdiri dari 6 digit';
        _isLoading = false;
      });
      return;
    }

    if (pin != confirmPin) {
      setState(() {
        _errorMessage = 'PIN tidak cocok';
        _isLoading = false;
      });
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = widget.userData['id'];

      final response = await http.post(
        Uri.parse('http://http://192.168.0.62:8000/api/create-pin/$userId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'pin': pin,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        // PIN berhasil dibuat
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN berhasil dibuat')),
        );
        Navigator.pop(context, true);
      } else {
        // Error membuat PIN
        final errorData = json.decode(response.body);
        setState(() {
          _errorMessage = errorData['message'] ?? 'Gagal membuat PIN';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Buat PIN'),
        backgroundColor: const Color(0xFF001F3F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Buat PIN Baru',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _pinController,
              obscureText: !_isPinVisible,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'Masukkan PIN (6 digit)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPinVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPinVisible = !_isPinVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _confirmPinController,
              obscureText: !_isPinVisible,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'Konfirmasi PIN',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPinVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPinVisible = !_isPinVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _createPin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A9AB0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Buat PIN', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }
}