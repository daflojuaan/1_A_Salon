import 'package:flutter/material.dart';

class NotaPembayaran extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12.0 : 20.0,
                    vertical: 20.0,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: isSmallScreen ? screenWidth - 16 : 600,
                        constraints: BoxConstraints(
                          // Increased the minimum height for both mobile and desktop
                          minHeight: isSmallScreen ? screenHeight * 0.9 : 900,
                        ),
                        color: Colors.white,
                        // Adjusted padding to accommodate increased height
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 10 : 26,
                          vertical: isSmallScreen ? 20 : 40,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: isSmallScreen ? 16 : 30),
                            Center(
                              child: Image.asset(
                                'images/logobiru.jpg',
                                width: isSmallScreen ? screenWidth * 0.6 : 350,
                                height: isSmallScreen ? screenWidth * 0.24 : 140,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 20),
                            Text(
                              'ATMA SALON CUKUR',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 20 : 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 16),
                            Divider(thickness: 1),
                            Text(
                              'ID CUSTOMER : 1234567890',
                              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                              textAlign: TextAlign.center,
                            ),
                            Divider(thickness: 1),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 12.0 : 16.0
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Customer", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("Barber"),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Budi Susanto", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("Yohanes Ardha"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Layanan",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: isSmallScreen ? 12 : 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Harga",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: isSmallScreen ? 12 : 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Jumlah",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: isSmallScreen ? 12 : 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Total",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: isSmallScreen ? 12 : 14,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            Divider(thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "HairCut",
                                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "50.000",
                                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "1",
                                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "50.000",
                                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            Divider(thickness: 1),
                            SizedBox(height: isSmallScreen ? 20 : 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                rowWithLabelValue("SubTotal", "50.000", isSmallScreen),
                                rowWithLabelValue("PPN 10%", "5.000", isSmallScreen),
                                rowWithLabelValue("Total", "55.000", isSmallScreen),
                                rowWithLabelValue("Tunai", "100.000", isSmallScreen),
                                rowWithLabelValue("Kembalian", "45.000", isSmallScreen),
                              ],
                            ),
                            SizedBox(height: isSmallScreen ? 20 : 30),
                            Divider(thickness: 1),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: isSmallScreen ? 12.0 : 16.0
                              ),
                              child: Text(
                                "Kami tunggu kedatangan Anda lagi\nTerima Kasih",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                              ),
                            ),
                            Divider(thickness: 1),
                            SizedBox(height: isSmallScreen ? 20 : 30),
                            SizedBox(
                              width: isSmallScreen ? double.infinity : 200,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.print, size: isSmallScreen ? 18 : 24),
                                label: Text(
                                  "Cetak Bukti Transaksi",
                                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 8 : 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.black, size: isSmallScreen ? 20 : 24),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: Text(
                    'Created at: 2024-10-15 21:30:45',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget rowWithLabelValue(String label, String value, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
          ),
          Spacer(),
          Text(
            "Rp. $value",
            style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
          ),
        ],
      ),
    );
  }
}