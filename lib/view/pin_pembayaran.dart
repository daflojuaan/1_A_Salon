import 'package:flutter/material.dart';
import 'package:a_salon/view/confirmPembayaran_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PinScreen extends StatefulWidget {
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final List<String> _pin = [];

  Future<void> _verifyPin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      
      if (userId == null) {
        throw Exception('User ID not found');
      }

      final response = await http.post(
        Uri.parse('http://192.168.0.62:8000/api/profile/pin/verify/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'pin': _pin.join(''),
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PaymentSuccessScreen()),
          );
        }
      } else {
        // Show error modal
        if (mounted) {
          _showErrorModal();
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorModal();
      }
    }
  }

  void _showErrorModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'PIN Salah',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text('PIN yang Anda masukkan salah. Silakan coba lagi.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _pin.clear();
                });
              },
              child: Text(
                'Coba Lagi',
                style: TextStyle(
                  color: Color(0xFF001F3F),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onKeyPress(String value) {
    if (_pin.length < 6) {
      setState(() {
        _pin.add(value);
      });

      if (_pin.length == 6) {
        _verifyPin();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF001F3F)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'PEMBAYARAN',
          style: TextStyle(
            color: Color(0xFF001F3F),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/asset/logo biru.png',
              width: 450,
              height: 150,
            ),
            SizedBox(height: 30),
            Icon(
              Icons.lock_outline,
              color: Color(0xFF001F3F),
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              'PIN',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF001F3F),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < _pin.length ? Color(0xFF001F3F) : Colors.transparent,
                    border: Border.all(color: Color(0xFF001F3F), width: 2),
                  ),
                );
              }),
            ),
            SizedBox(height: 40),
            _buildNumberPad(),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 3; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (j) {
              int num = i * 3 + j + 1;
              return _buildNumberButton(num.toString());
            }),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 60),
            _buildNumberButton('0'),
            _buildNumberButton(Icons.backspace_outlined, isBackspace: true),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(dynamic content, {bool isBackspace = false}) {
    return GestureDetector(
      onTap: () {
        if (isBackspace) {
          _onBackspace();
        } else if (content is String) {
          _onKeyPress(content);
        }
      },
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: content is String
            ? Text(
                content,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              )
            : Icon(
                content,
                color: Colors.black,
                size: 24,
              ),
      ),
    );
  }
}