import 'package:a_salon/view/topup_saldo.dart';
import 'package:flutter/material.dart';
import 'package:a_salon/view/login_page.dart';
import 'package:a_salon/view/register_page.dart';
import 'package:a_salon/view/forgot_password_page.dart';
import 'package:a_salon/view/scan_page.dart';
import 'package:a_salon/view/payment_page.dart';
import 'package:a_salon/view/reservation_page.dart';
import 'package:a_salon/view/barber_page.dart';

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
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/login': (context) => const LoginPage(),
        '/scan' : (context) => const ScanPage(),    
        '/reservation': (context) => const ReservationPage(),
        '/payment': (context) => const PaymentPage(),
        '/topup': (context) => const TopUpSaldoPage(),
        '/barber': (context) => const BarberProfilePage(),
      },
    );
  }
}
