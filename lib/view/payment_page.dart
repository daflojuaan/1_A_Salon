import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? result = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Center(
        child: Text('Scanned Result: ${result ?? "No result found"}', style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}