import 'package:flutter/material.dart';
import 'package:a_salon/entity/Reservasi.dart';
import 'package:a_salon/client/ReservasiClient.dart'; // Import the ReservasiClient

class EditReservationScreen extends StatefulWidget {
  final Reservasi reservasi;

  EditReservationScreen({required this.reservasi});

  @override
  _EditReservationScreenState createState() => _EditReservationScreenState();
}

class _EditReservationScreenState extends State<EditReservationScreen> {
  DateTime? selectedDate;
  String? selectedBarber;
  String? selectedService;
  String? selectedTime;

  final List<String> barbers = ['Dewa', 'Ardha', 'Hazel', 'Daflo'];
  final List<String> jamTersedia = [
    '09:00',
    '10:00',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00'
  ];

  final List<String> layananDewa = [
    'Haircut',
    'Beard Trim',
    'Hair Coloring',
    'HairStyling',
  ];
  final List<String> layananArdha = [
    'Premium Cut',
    'Shaving',
    'Hairstyling',
    'Kids Cut',
  ];
  final List<String> layananHazel = [
    'Haircut',
    'Shaving',
    'Hairstyling',
    'Kids Cut',
  ];
  final List<String> layananDaflo = [
    'Haircut',
    'Shaving',
    'Hairstyling',
    'Kids Cut',
  ];

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Fungsi untuk mengonversi string tanggal menjadi DateTime
  DateTime? _parseDate(String dateStr) {
    final parts = dateStr.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    return null;
  }

  // Fungsi untuk memformat tanggal menjadi string yang lebih mudah dibaca
String _formatDate(DateTime date) {
  // Convert DateTime to the format 'YYYY-MM-DD' for MySQL compatibility
  return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}


  // Fungsi untuk memvalidasi waktu yang dipilih
  String? _validateTime(String time) {
    // Format waktu untuk mencocokkan waktu yang tersedia
    String formattedTime = time.length > 5 ? time.substring(0, 5) : time;
    return jamTersedia.contains(formattedTime) ? formattedTime : null;
  }

  // Mendapatkan layanan berdasarkan barber yang dipilih
  List<String> _getAvailableServices() {
    if (selectedBarber == 'Dewa') {
      return layananDewa;
    } else if (selectedBarber == 'Ardha') {
      return layananArdha;
    } else if (selectedBarber == 'Hazel') {
      return layananHazel;
    } else if (selectedBarber == 'Daflo') {
      return layananDaflo;
    }
    return [];
  }

  // Fungsi untuk memperbarui reservasi
  Future<void> _updateReservation() async {
    if (selectedDate != null &&
        selectedService != null &&
        selectedBarber != null &&
        selectedTime != null) {
      String formattedDate = _formatDate(selectedDate!);

      final updatedReservation = Reservasi(
        id: widget.reservasi.id,
        date: formattedDate,
        time: selectedTime!,
        barber: selectedBarber!,
        service: selectedService!,
        status: 'Booked',
      );

      try {
        final response = await ReservasiClient.update(updatedReservation);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reservasi berhasil diperbarui')),
          );
          Navigator.pop(context, updatedReservation);
        } else {
          print('Server response: ${response.body}'); // Debug respons server
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui reservasi: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Error: $e'); // Debug error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data')),
      );
    }
  }

  // Inisialisasi data saat layar dibuka
  @override
  void initState() {
    super.initState();
    selectedDate = _parseDate(widget.reservasi.date);
    selectedBarber = widget.reservasi.barber;
    selectedService = widget.reservasi.service;
    selectedTime = _validateTime(widget.reservasi.time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: _buildForm(),
    );
  }

  // Formulir untuk mengedit reservasi
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Ubah Reservasi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 32),
          const Text('Pilih Tanggal', style: TextStyle(fontSize: 16)),
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate != null ? _formatDate(selectedDate!) : "",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Pilih Barber', style: TextStyle(fontSize: 16)),
          DropdownButtonFormField<String>(
            value: selectedBarber,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            hint: const Text('Pilih Barber'),
            items: barbers.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedBarber = newValue;
                selectedService = null; // Reset service when barber changes
              });
            },
          ),
          const SizedBox(height: 24),
          if (selectedBarber != null) ...[
            const Text('Pilih Layanan', style: TextStyle(fontSize: 16)),
            DropdownButtonFormField<String>(
              value: selectedService,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.zero,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              hint: const Text('Pilih Layanan'),
              items: _getAvailableServices().map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedService = newValue;
                });
              },
            ),
          ],
          const SizedBox(height: 24),
          const Text('Pilih Jam', style: TextStyle(fontSize: 16)),
          DropdownButtonFormField<String>(
            value: selectedTime,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            hint: const Text('Pilih Jam'),
            items: jamTersedia.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedTime = newValue;
              });
            },
          ),
          const SizedBox(height: 48),
          Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A9AB0),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'UPDATE RESERVASI',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
