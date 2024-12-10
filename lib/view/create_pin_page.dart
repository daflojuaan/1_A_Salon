import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PinPage extends StatefulWidget {
  final bool isUpdate;
  final Map<String, dynamic> userData;

  const PinPage({
    Key? key, 
    required this.isUpdate,
    required this.userData,
  }) : super(key: key);

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final TextEditingController _currentPinController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  bool _isPinVisible = false;
  String _errorMessage = '';

  Future<void> _handlePin() async {
    setState(() {
      _errorMessage = '';
    });

    String pin = _pinController.text;
    String confirmPin = _confirmPinController.text;

    if (pin.length != 6) {
      setState(() {
        _errorMessage = 'PIN harus terdiri dari 6 digit';
      });
      return;
    }

    if (pin != confirmPin) {
      setState(() {
        _errorMessage = 'PIN tidak cocok';
      });
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      
      if (userId == null) {
        throw Exception('User ID not found');
      }

      // Print data untuk debugging
      print('Request data:');
      print(widget.isUpdate ? 'current_pin: ${_currentPinController.text}' : '');
      print('pin: $pin');
      print('confirm_pin: $confirmPin');

      final url = widget.isUpdate 
        ? 'http://192.168.0.62:8000/api/profile/pin/update/$userId'
        : 'http://192.168.0.62:8000/api/profile/pin/create/$userId';

      // Persiapkan body request sesuai dengan jenis operasi
      final Map<String, String> requestBody = widget.isUpdate 
        ? {
            'current_pin': _currentPinController.text,
            'new_pin': pin,
            'confirm_pin': confirmPin,
          }
        : {
            'pin': pin,
            'confirm_pin': confirmPin,
          };

      // Print request untuk debugging
      print('URL: $url');
      print('Request body: $requestBody');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // Print response untuk debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.isUpdate ? 'PIN berhasil diubah' : 'PIN berhasil dibuat')),
          );
          Navigator.pop(context, true);
        }
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          _errorMessage = errorData['message'] ?? 'Terjadi kesalahan';
        });
      }
    } catch (e) {
      print('Error: $e'); // Debug print
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.isUpdate ? 'Ubah PIN' : 'Buat PIN'),
        backgroundColor: const Color(0xFF001F3F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.isUpdate ? 'Ubah PIN' : 'Buat PIN Baru',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (widget.isUpdate) TextField(
              controller: _currentPinController,
              obscureText: !_isPinVisible,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'PIN Saat Ini',
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
            if (widget.isUpdate) const SizedBox(height: 10),
            TextField(
              controller: _pinController,
              obscureText: !_isPinVisible,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: widget.isUpdate ? 'PIN Baru' : 'Masukkan PIN (6 digit)',
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
                labelText: widget.isUpdate ? 'Konfirmasi PIN Baru' : 'Konfirmasi PIN',
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
              onPressed: _handlePin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A9AB0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                widget.isUpdate ? 'Ubah PIN' : 'Buat PIN',
                style: const TextStyle(fontSize: 16)
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentPinController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }
}