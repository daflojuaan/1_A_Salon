import 'package:flutter/material.dart';
import 'package:a_salon/view/notapembayaran_page.dart';

class PaymentSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFF001F3F),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 30),
              Image.asset(
                'lib/asset/ceklistpembayaran.png',
                width: 200,
                height: 160,
              ),
              SizedBox(height: 16),
              Text(
                "PEMBAYARAN BERHASIL!",
                style: TextStyle(
                  fontFamily: 'Arial', // You can change this to any system font
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "15 Oktober 2024 - 10:00 WIB",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[300],
                ),
              ),
              SizedBox(height: 24),
              Text(
                "Penerima",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[300],
                ),
              ),
              Text(
                "ATMA SALON CUKUR",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Nominal Transaksi",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[300],
                ),
              ),
              Text(
                "Rp. 55.000",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotaPembayaran()),
                  );
                },
                child: Text(
                  "detail",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.amber[700],
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 35),
                child: Center(
                  child: Image.asset(
                    'lib/asset/logo putih.png',
                    width: 550,
                    height: 200,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
