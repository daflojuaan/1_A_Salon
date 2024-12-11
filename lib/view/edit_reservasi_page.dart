import 'package:flutter/material.dart';
import 'package:a_salon/database/database_helper_reservation.dart';

class EditReservationScreen extends StatefulWidget {
  final Map<String, dynamic> reservation;

  EditReservationScreen({required this.reservation});

  @override
  _EditReservationScreenState createState() => _EditReservationScreenState();
}

class _EditReservationScreenState extends State<EditReservationScreen> {
  DateTime? selectedDate;
  String? selectedBarber;
  String? selectedService;
  String? selectedTime;

  final DatabaseHelperReservasi _dbHelper = DatabaseHelperReservasi.instance;

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDate = _parseDate(widget.reservation['date']);
    selectedBarber = widget.reservation['barber'];
    selectedService = widget.reservation['service'];
    selectedTime = widget.reservation['time'];
  }

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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

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

  Future<void> _updateReservation() async {
    if (selectedDate != null &&
        selectedService != null &&
        selectedBarber != null &&
        selectedTime != null) {
      String formattedDate = _formatDate(selectedDate!);

      // Create a mutable copy of the reservation data
      final updatedReservation = Map<String, dynamic>.from(widget.reservation);
      updatedReservation['date'] = formattedDate;
      updatedReservation['time'] = selectedTime!;
      updatedReservation['barber'] = selectedBarber!;
      updatedReservation['service'] = selectedService!;
      updatedReservation['status'] =
          'Booked'; // Ensure status is updated if necessary

      int result = await _dbHelper.updateReservation(updatedReservation);
      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reservasi berhasil diperbarui')),
        );
        // Pass the updated reservation back to the previous screen
        Navigator.pop(context, updatedReservation);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui reservasi')),
        );
      }
    } else { 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data')),
      );
    }
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
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
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
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
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
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
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
