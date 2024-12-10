import 'package:flutter/material.dart';
import 'package:a_salon/entity/Reservasi.dart';
import 'package:a_salon/client/ReservasiClient.dart';
// import 'package:list/view/ListReservasiPage.dart';

class ReservasiPage extends StatefulWidget {
  @override
  _ReservasiPageState createState() => _ReservasiPageState();
}

class _ReservasiPageState extends State<ReservasiPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedDate;
  String? _selectedTime;
  String? _selectedBarber;
  String? _selectedService;

  bool _isLoading = false;

  final List<String> _times = [
    '09:00',
    '10:00',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00'
  ];

  final List<String> _barbers = ['Dewa', 'Ardha', 'Hazel', 'Daflo'];

  List<String> _services = [
    'Premium Cut',
    'Shaving',
    'Hairstyling',
    'Kids Cut',
  ];

  void _updateServices(String barber) {
    switch (barber) {
      case 'Ardha':
        setState(() {
          _services = [
            'Premium Cut',
            'Shaving',
            'Hairstyling',
            'Kids Cut',
          ];
        });
        break;
      case 'Hazel':
        setState(() {
          _services = [
            'Haircut',
            'Shaving',
            'Hairstyling',
            'Kids Cut',
          ];
        });
        break;
      case 'Dewa':
        setState(() {
          _services = [
            'Haircut',
            'Beard Trim',
            'Hair Coloring',
            'HairStyling',
          ];
        });
        break;
      default:
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _selectedDate =
            "${picked.toLocal()}".split(' ')[0]; // Format to yyyy-MM-dd
      });
    }
  }

  void _submitReservasi() async {
    if (_formKey.currentState!.validate()) {
      bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFEAD8B0),
            title: const Text(
              'KONFIRMASI',
              textAlign: TextAlign.center, // Pusatkan teks judul
            ),
            content: Text('Yakin ingin membuat reservasi?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Cancel
                child: Text('Tidak'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF001f3f), // Warna teks
                  backgroundColor: const Color(0xFF6A9AB0), // Warna tombol
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Confirm
                child: Text('Ya'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF001f3f), // Warna teks
                  backgroundColor: const Color(0xFF6A9AB0), // Warna tombol
                ),
              ),
            ],
          );
        },
      );

      if (confirmed == true) {
        setState(() {
          _isLoading = true;
        });

        Reservasi reservasi = Reservasi(
          id: DateTime.now().millisecondsSinceEpoch, // Temporary unique ID
          date: _selectedDate!,
          time: _selectedTime!,
          barber: _selectedBarber!,
          service: _selectedService!,
          status: 'Booked',
        );

        try {
          await ReservasiClient.create(reservasi); // Simulate API call
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Reservasi berhasil dibuat!'),
            backgroundColor: Colors.green,),
          );

          // Reset form
          _formKey.currentState!.reset();
          setState(() {
            _selectedDate = null;
            _selectedTime = null;
            _selectedBarber = null;
            _selectedService = null;
          });

          // Navigate back with the newly created reservation
          Navigator.pop(context, reservasi);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan reservasi: $e'),
            backgroundColor: Colors.red,),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Silahkan Isi Data',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Pilih Tanggal
              const Text(
                'Pilih Tanggal',
                style: TextStyle(fontSize: 16),
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: _selectedDate ?? '',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(text: _selectedDate),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tanggal harus dipilih';
                      }
                      return null;
                    },
                    readOnly: true,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Pilih Waktu
              const Text(
                'Pilih Waktu',
                style: TextStyle(fontSize: 16),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                value: _selectedTime,
                items: _times.map((time) {
                  return DropdownMenuItem<String>(
                    value: time,
                    child: Text(time),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTime = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Waktu harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Pilih Barber
              const Text(
                'Pilih Barber',
                style: TextStyle(fontSize: 16),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                value: _selectedBarber,
                items: _barbers.map((barber) {
                  return DropdownMenuItem<String>(
                    value: barber,
                    child: Text(barber),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBarber = value;
                    _updateServices(value!);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Barber harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Pilih Layanan
              if (_selectedBarber != null) ...[
                const Text(
                  'Pilih Layanan',
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  value: _selectedService,
                  items: _services.map((service) {
                    return DropdownMenuItem<String>(
                      value: service,
                      child: Text(service),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedService = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Layanan harus dipilih';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
              ],

              // Simpan Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitReservasi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6A9AB0),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            'PESAN SEKARANG',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
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
