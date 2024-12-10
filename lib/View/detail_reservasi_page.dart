import 'package:flutter/material.dart';

class DetailReservasiPage extends StatelessWidget {
  final Map<String, dynamic> reservasi;

  const DetailReservasiPage({Key? key, required this.reservasi})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imagePath;
    if (reservasi['barber'] == 'Ardha') {
      imagePath = 'lib/asset/1.jpg';
    } else if (reservasi['barber'] == 'Dewa') {
      imagePath = 'lib/asset/2.jpg';
    } else if (reservasi['barber'] == 'Hazel'){
      imagePath = 'lib/asset/3.jpg'; 
    }else{
      imagePath = 'lib/asset/4.jpg';
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 40.0),
            child: Text(
              'DETAIL',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar dan nama salon/layanan
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  imagePath, // Gambar layanan
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Text(
                'ATMA SALON - ${reservasi['service']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Detail Reservasi
            Text(
              'DATE & TIME',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(reservasi['date']! + ' - ' + reservasi['time']!),
            const SizedBox(height: 16.0),

            Text(
              'SERVICES',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text('${reservasi['service']} - Rp ${reservasi['price']}'),
            const SizedBox(height: 16.0),

            Text(
              'BARBER',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(reservasi['barber']!),
            const SizedBox(height: 20.0),

            // Tombol Kembali
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001F3F), // Warna biru gelap
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'KEMBALI',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
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
}
