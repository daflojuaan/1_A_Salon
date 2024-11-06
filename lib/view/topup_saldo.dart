import 'package:flutter/material.dart';

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
                  label: Text('Rp. $amount'),
                  selected: selectedAmount == amount,
                  onSelected: (selected) {
                    setState(() {
                      selectedAmount = selected ? amount : selectedAmount;
                      customAmountController.clear();
                    });
                  },
                  selectedColor: const Color(0xFFFFC107),
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
              decoration: InputDecoration(
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
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _topUpSaldo();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B5585),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                child: const Text(
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
      title: Text(method, style: const TextStyle(fontSize: 16, color: Color(0xFF1B3358))),
      leading: Radio<String>(
        value: method,
        groupValue: paymentMethod,
        onChanged: (value) {
          setState(() {
            paymentMethod = value!;
          });
        },
        activeColor: const Color(0xFFFFC107),
      ),
    );
  }

  void _topUpSaldo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Top up Rp. $selectedAmount menggunakan $paymentMethod sedang diproses...'),
      ),
    );
  }
}
  State<TopUpSaldoPage> createState() => _TopUpSaldoPageState();
}

class _TopUpSaldoPageState extends State<TopUpSaldoPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
