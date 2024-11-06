import 'package:flutter/material.dart';
import 'package:a_salon/view/login_page.dart';
import 'package:a_salon/view/register_page.dart';
import 'package:a_salon/view/forgot_password_page.dart';
import 'package:a_salon/view/scan_page.dart';
import 'package:a_salon/view/payment_page.dart';
import 'package:a_salon/view/reservation_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A Salon Ulang',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),// Halaman utama
        '/register': (context) => const RegisterPage(),// Halaman registrasi
        '/forgot-password': (context) => const ForgotPasswordPage(), // Halaman pemulihan kata sandi
        '/login': (context) => const LoginPage(), // Halaman login
        '/scan' : (context) => const ScanPage(), // Halaman scan     
        '/reservation': (context) => const ReservationPage(),
        '/payment': (context) => const PaymentPage(),// Halaman pembayaran
      },
    );
  }
}
