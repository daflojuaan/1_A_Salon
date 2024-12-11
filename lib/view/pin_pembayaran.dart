import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:a_salon/view/confirmPembayaran_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PinScreen extends StatefulWidget {
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_pinFocusNode);
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

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
          'pin': _pinController.text,
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
                _pinController.clear();
                FocusScope.of(context).requestFocus(_pinFocusNode);
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
              'Masukkan PIN',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001F3F),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 200,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF001F3F),
                    width: 2.0,
                  ),
                ),
              ),
              child: TextField(
                controller: _pinController,
                focusNode: _pinFocusNode,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  letterSpacing: 8.0,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  hintText: "······",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 24,
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  if (value.length == 6) {
                    _verifyPin();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}