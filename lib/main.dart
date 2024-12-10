import 'package:flutter/material.dart';
import 'package:a_salon/view/login_page.dart';
import 'package:a_salon/view/register_page.dart';
import 'package:a_salon/view/scan_page.dart';
import 'package:a_salon/view/payment_page.dart';
import 'package:a_salon/view/ReservasiPage.dart';
import 'package:a_salon/view/barber_page.dart';
import 'package:a_salon/view/notification_page.dart';
import 'package:a_salon/view/topup_saldo.dart';


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
        '/login': (context) => const LoginPage(),
        '/scan': (context) => const ScanPage(),
        '/reservation': (context) => ReservasiPage(),
        '/payment': (context) => const PaymentPage(),
        '/topup': (context) => const TopUpSaldoPage(),
        '/barber': (context) => const BarberProfilePage(),
        '/notification': (context) => const NotificationPage(),
      },
    );
  }
}
