import 'package:flutter/material.dart';
import 'package:a_salon/entity/Reservasi.dart';
import 'package:a_salon/client/ReservasiClient.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:list/view/ListReservasiPage.dart';

class Service {
  final int id;
  final int barberId;
  final String serviceName;
  final int price;

  Service({
    required this.id,
    required this.barberId,
    required this.serviceName,
    required this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      barberId: json['id_barber'],
      serviceName: json['name'],
      price: int.parse(json['harga'].toString()),
    );
  }
}

class Barber {
  final int id;
  final String barbername;
  final String phone;
  final String experience;
  final String? photo;
  List<Service> services = [];

  Barber({
    required this.id,
    required this.barbername,
    required this.phone,
    required this.experience,
    this.photo,
    this.services = const [],
  });

  factory Barber.fromJson(Map<String, dynamic> json) {
    return Barber(
      id: json['id'],
      barbername: json['barbername'],
      phone: json['phone'],
      experience: json['experience'],
      photo: json['photo'],
    );
  }
}

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
  int _selectedPrice = 0;

  bool _isLoading = false;

  List<Barber> barbers = [];
  List<Service> service = [];

  @override
  void initState() {
    super.initState();
    getBarbers();
  }

  Future<void> getBarbers() async {
    final response =
        await http.get(Uri.parse('http://192.168.0.62:8000/api/barber'));

    if (response.statusCode == 200) {
      final List<Barber> loadedBarbers = (json.decode(response.body) as List)
          .map((data) => Barber.fromJson(data))
          .toList();

      for (var barber in loadedBarbers) {
        final servicesResponse = await http.get(
          Uri.parse('http://192.168.0.62:8000/api/service/get/${barber.id}'),
        );

        if (servicesResponse.statusCode == 200) {
          final List<Service> services =
              (json.decode(servicesResponse.body) as List)
                  .map((data) => Service.fromJson(data))
                  .toList();
          barber.services = services;
        }
      }
      setState(() {
        barbers = loadedBarbers;
      });
    }
  }

  Future<void> _addReservasi() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userId');
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.62:8000/api/reservations'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'id_user': id,
          'date': _selectedDate!,
          'time': _selectedTime!,
          'barber': _selectedBarber!,
          'service': _selectedService!,
          'harga' : _selectedPrice,
          'status': "Booked",
        }),
      );
      if (response.statusCode != 201) throw Exception(response.reasonPhrase);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  final List<String> _times = [
    '09:00',
    '10:00',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00'
  ];

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

        final prefs = await SharedPreferences.getInstance();
        final id = prefs.getInt('userId');
        try {
          final response = await http.post(
            Uri.parse('http://192.168.0.62:8000/api/reservations'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'id_user': id,
              'date': _selectedDate!,
              'time': _selectedTime!,
              'barber': _selectedBarber!,
              'service': _selectedService!,
              'harga' : _selectedPrice,
              'status': "Booked",
            }),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Reservasi berhasil dibuat!'),
              backgroundColor: Colors.green,
            ),
          );

          _formKey.currentState!.reset();
          setState(() {
            _selectedDate = null;
            _selectedTime = null;
            _selectedBarber = null;
            _selectedService = null;
          });

          if (response.statusCode != 201) throw Exception(response.reasonPhrase);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan reservasi: $e'),
              backgroundColor: Colors.red,
            ),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }

        // try {
        //   await ReservasiClient.create(reservasi); // Simulate API call
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Reservasi berhasil dibuat!'),
        //       backgroundColor: Colors.green,
        //     ),
        //   );

        //   // Reset form
        //   _formKey.currentState!.reset();
        //   setState(() {
        //     _selectedDate = null;
        //     _selectedTime = null;
        //     _selectedBarber = null;
        //     _selectedService = null;
        //   });

        //   // Navigate back with the newly created reservation
        //   Navigator.pop(context, reservasi);
        // } catch (e) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Gagal menyimpan reservasi: $e'),
        //       backgroundColor: Colors.red,
        //     ),
        //   );
        // } finally {
        //   setState(() {
        //     _isLoading = false;
        //   });
        // }
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
                items: barbers.map((barber) {
                  return DropdownMenuItem<String>(
                    value: barber.barbername,
                    child: Text(barber.barbername),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBarber = value;
                    _selectedService = null;

                    if (value != null) {
                      final selectedBarber = barbers.firstWhere(
                        (barber) => barber.barbername == value,
                      );
                      service = selectedBarber
                          .services; // Update service list dengan service dari barber yang dipilih
                    }
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
                  items: service.map((service) {
                    return DropdownMenuItem<String>(
                      value: service.serviceName,
                      child:
                          Text('${service.serviceName} - Rp ${service.price}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedService = value;
                      if (value != null) {
                        final selectedService = service.firstWhere(
                          (service) => service.serviceName == value,
                        );
                        _selectedPrice = selectedService.price;
                      }
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
