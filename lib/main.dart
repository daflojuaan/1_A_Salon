
import 'package:a_salon/View/listreservasi.dart';
import 'package:a_salon/view/register.dart';
import 'package:flutter/material.dart';
import 'package:a_salon/view/home.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              print('Tekan');
            },
            child: const Text(
              'Cobain',
              style: TextStyle(color: Color.fromARGB(255, 138, 97, 82)),
            ),
          ),
        ),
      ),

  }
}