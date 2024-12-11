import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:a_salon/view/caraPembayaranPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:a_salon/view/home_page.dart';

class TopUpSaldoPage extends StatefulWidget {
  const TopUpSaldoPage({super.key});

  @override
  _TopUpSaldoPageState createState() => _TopUpSaldoPageState();
}

class _TopUpSaldoPageState extends State<TopUpSaldoPage> {
  List<int> topUpAmounts = [100000, 200000, 500000, 1000000];
  int selectedAmount = 100000;
  String paymentMethod = 'Bank Transfer';
  TextEditingController customAmountController = TextEditingController();
  String? selectedBank;
  bool _isLoading = false;

  // Daftar bank yang tersedia
  List<String> banks = ['BCA', 'BRI', 'Mandiri', 'BNI'];
  List<String> ewallets = ['DANA', 'GOPAY', 'ShopeePay', 'OVO'];

  // Base URL API Laravel
  final String apiUrl = 'http://192.168.0.62:8000/api';

Future<void> addSaldo() async {
    if (paymentMethod == 'Bank Transfer' && selectedBank == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih bank terlebih dahulu')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        throw Exception('User ID not found');
      }

      final response = await http.post(
        Uri.parse('$apiUrl/profile/topup/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'amount': selectedAmount,
          'payment_method': paymentMethod,
          'bank': selectedBank,
        }),
      );

      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        // Reset loading state
        setState(() => _isLoading = false);

        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Top Up Berhasil',
                style: TextStyle(color: Colors.green),
                textAlign: TextAlign.center,
              ),
              content: Text(
                'Top up sebesar Rp ${selectedAmount.toString()} berhasil',
                textAlign: TextAlign.center,
              ),
            );
          },
        );

        // Wait 3 seconds then navigate back to home
        await Future.delayed(const Duration(seconds: 3));
        
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false
          );
        }
      } else {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Top up gagal'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showSuccessModal(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Top Up Berhasil',
            style: TextStyle(color: Colors.green),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Top Up Saldo",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2B5585),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Jumlah Top Up',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B3358),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 15.0,
              children: topUpAmounts.map((amount) {
                return ChoiceChip(
                  label: Text('Rp. ${amount.toString()}'),
                  selected: selectedAmount == amount,
                  onSelected: (selected) {
                    setState(() {
                      selectedAmount = selected ? amount : selectedAmount;
                      customAmountController.clear();
                    });
                  },
                  selectedColor: const Color.fromARGB(255, 13, 32, 241),
                  backgroundColor: Colors.grey[300],
                  labelStyle: const TextStyle(color: Colors.black),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            const Text(
              'Atau Masukkan Jumlah Top Up (Rp)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B3358),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: customAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Jumlah Top Up',
                hintText: 'Masukkan jumlah top up',
              ),
              onChanged: (value) {
                setState(() {
                  selectedAmount = int.tryParse(value) ?? selectedAmount;
                });
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B3358),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                _buildPaymentMethodOption('Bank Transfer'),
                _buildPaymentMethodOption('E-wallet'),
              ],
            ),
            if (paymentMethod == 'Bank Transfer') ...[
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Bank',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B3358),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Pilih Bank'),
                    value: selectedBank,
                    onChanged: (String? newBank) {
                      setState(() {
                        selectedBank = newBank;
                      });
                    },
                    items: banks.map<DropdownMenuItem<String>>((String bank) {
                      return DropdownMenuItem<String>(
                        value: bank,
                        child: Text(bank),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : addSaldo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B5585),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Top Up Sekarang',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption(String method) {
    return ListTile(
      title: Text(
        method,
        style: const TextStyle(fontSize: 16, color: Color(0xFF1B3358)),
      ),
      leading: Radio<String>(
        value: method,
        groupValue: paymentMethod,
        onChanged: (value) {
          setState(() {
            paymentMethod = value!;
            selectedBank = null;
          });
        },
        activeColor: const Color(0xFFFFC107),
      ),
    );
  }

  void _topUpSaldo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CaraPembayaranPage(
          amount: selectedAmount,
          paymentMethod: paymentMethod,
          bank: paymentMethod == 'Bank Transfer' ? selectedBank : null,
          ewallet: paymentMethod == 'E-wallet' ? _getEwallet() : null,
        ),
      ),
    );
  }

  String? _getEwallet() {
    return paymentMethod == 'E-wallet' ? ewallets.first : null;
  }
}