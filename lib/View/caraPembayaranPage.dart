import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'topup_saldo.dart';

class CaraPembayaranPage extends StatefulWidget {
  final int amount;
  final String paymentMethod;
  final String? bank;
  final String? ewallet;

  const CaraPembayaranPage({
    super.key,
    required this.amount,
    required this.paymentMethod,
    this.bank,
    this.ewallet,
  });

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<CaraPembayaranPage> {
  late String uniqueCode;
  late Timer countdownTimer;
  int _remainingTime = 600; // 10 minutes in seconds

  @override
  void initState() {
    super.initState();
    // Generate a unique code for BRIVA payment
    uniqueCode = _generateUniqueCode();
    // Start countdown timer
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        countdownTimer.cancel();
      }
    });
  }

  @override
  void dispose() {
    countdownTimer.cancel();
    super.dispose();
  }

  String _generateUniqueCode() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(11, (index) {
      return characters[random.nextInt(characters.length)];
    }).join();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int sec = seconds % 60;
    return '$minutes:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pembayaran Top Up',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2B5585),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Top Up: Rp. ${widget.amount}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (widget.paymentMethod == 'Bank Transfer') ...[
              const Text(
                'Tata Cara Pembayaran via Bank Transfer:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '1. Pilih metode pembayaran Bank Transfer.\n'
                '2. Pilih bank yang diinginkan: ${widget.bank ?? "Tunggu pilihan bank"}\n'
                '3. Transfer ke rekening yang ditentukan.',
                style: const TextStyle(fontSize: 16),
              ),
            ] else if (widget.paymentMethod == 'E-wallet') ...[
              const Text(
                'Tata Cara Pembayaran via E-wallet:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '1. Pilih metode pembayaran E-wallet.\n'
                '2. Gunakan e-wallet seperti DANA, Gopay, atau ShopeePay.',
                style: const TextStyle(fontSize: 16),
              ),
            ],
            const SizedBox(height: 30),
            Text(
              'Unique Code: $uniqueCode',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Text(
              'Waktu Sisa Pembayaran: ${_formatTime(_remainingTime)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}