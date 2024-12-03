import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UlasanPage extends StatefulWidget {
  final Map<String, dynamic> reservation;

  const UlasanPage({Key? key, required this.reservation}) : super(key: key);

  @override
  State<UlasanPage> createState() => _UlasanPageState();
}

class _UlasanPageState extends State<UlasanPage> {
  double _rating = 4.0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var reservation = widget.reservation;
    String imagePath;
    if (reservation['barber'] == 'Ardha') {
      imagePath = 'lib/asset/1.jpg';
    } else if (reservation['barber'] == 'Dewa') {
      imagePath = 'lib/asset/2.jpg';
    } else if (reservation['barber'] == 'Hazel') {
      imagePath = 'lib/asset/3.jpg';
    } else {
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
          child: Text(
            'ULASAN',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card untuk Informasi Reservasi
            Card(
              elevation: 2,
              color: const Color(
                  0xFF6A9AB0), // Warna yang sama seperti di listView.dart
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, top: 9.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset(
                          imagePath, // Path ke gambar
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Detail Reservasi
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reservation['date']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text('Waktu: ${reservation['time']}'),
                          const SizedBox(height: 4.0),
                          Text('Barber: ${reservation['barber']}'),
                          const SizedBox(height: 4.0),
                          Text('Layanan: ${reservation['service']}'),
                          const SizedBox(height: 4.0),
                          Text('Status: ${reservation['status']}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // Rating dan Review
            Card(
              elevation: 8,
              color: const Color(0xFFEAD8B0), // Warna latar seperti gambar
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bagian Rating
                    const Text(
                      'RATING',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0, // Ukuran font lebih kecil
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: _rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30.0, // Ukuran bintang
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.orange, // Warna bintang oranye
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '(${_rating.toStringAsFixed(1)})',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    // Bagian Review
                    const Text(
                      'REVIEW',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: _reviewController,
                      maxLines: 5, // Tinggi area review diperbesar
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white, // Latar putih
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none, // Tanpa border
                        ),
                        hintText: 'Tulis ulasan Anda di sini...',
                      ),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(height: 16.0),
                    // Tombol Simpan
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Logika untuk menyimpan ulasan
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF001F3F), // Warna biru gelap
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32.0,
                            vertical: 12.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Rounded corners
                          ),
                        ),
                        child: const Text(
                          'SIMPAN',
                          style: TextStyle(
                            fontSize: 18.0, // Ukuran font tombol
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
