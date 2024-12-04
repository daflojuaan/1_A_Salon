import 'package:flutter/material.dart';
import 'package:a_salon/database/database_helper_reservation.dart';
import 'package:a_salon/view/edit_reservasi_page.dart';
import 'package:a_salon/view/ulasan_page.dart';
import 'package:a_salon/view/detail_reservasi_page.dart';

class ReservasiView extends StatefulWidget {
  const ReservasiView({Key? key}) : super(key: key);

  @override
  State<ReservasiView> createState() => _ReservasiPageState();
}

class _ReservasiPageState extends State<ReservasiView> {
  final DatabaseHelperReservasi _dbHelper = DatabaseHelperReservasi.instance;
  int _selectedIndex = 2;
  bool isAktifSelected = true;
  bool showForm = false;
  List<Map<String, dynamic>> activeReservations = [];
  List<Map<String, dynamic>> canceledReservations = [];

  // Form state variables
  DateTime? selectedDate;
  String? selectedBarber;
  String? selectedService;
  String? selectedTime;

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

  final List<String> barbers = ['Dewa', 'Ardha', 'Hazel', 'Daflo'];

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  void _loadReservations() async {
    final activeReservations =
        await DatabaseHelperReservasi.instance.getActiveReservations();
    final canceledReservations =
        await DatabaseHelperReservasi.instance.getCanceledReservations();

    setState(() {
      this.activeReservations = activeReservations;
      this.canceledReservations = canceledReservations;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTabSelected(bool isAktif) {
    setState(() {
      isAktifSelected = isAktif;
    });
  }

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

  void _toggleForm() {
    setState(() {
      showForm = !showForm;
    });
  }

  Future<void> _addReservation() async {
    if (selectedDate != null &&
        selectedService != null &&
        selectedBarber != null &&
        selectedTime != null) {
      // Show DIALOG CONFIRM
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFEAD8B0),
            title: const Center(
              child: Text('Konfirmasi'),
            ),
            content: const Text(
              'Yakin Ingin Membuat Reservasi?',
              textAlign: TextAlign.center,
            ),
            actions: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        // Create a new reservation entry
                        final reservation = {
                          'date':
                              "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          'time': selectedTime!,
                          'barber': selectedBarber!,
                          'service': selectedService!,
                          'status': 'Booked',
                        };

                        // Insert the reservation into the database
                        await _dbHelper.insertReservation(reservation);

                        // Reset form and hide it
                        setState(() {
                          selectedDate = null;
                          selectedService = null;
                          selectedBarber = null;
                          selectedTime = null;
                          showForm = false;
                        });

                        // Reload reservations
                        _loadReservations();

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Reservasi berhasil dibuat'),
                          ),
                        );

                        // Close the dialog
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF001f3f), // Warna teks
                        backgroundColor:
                            const Color(0xFF6A9AB0), // Warna tombol
                      ),
                      child: const Text('Ya'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF001f3f), // Warna teks
                        backgroundColor:
                            const Color(0xFF6A9AB0), // Warna tombol
                      ),
                      child: const Text('Tidak'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua data'),
        ),
      );
    }
  }

//FORM INPUT RESERVASI
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
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
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate != null
                        ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                        : "",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Pilih Barber
          const Text(
            'Pilih Barber',
            style: TextStyle(fontSize: 16),
          ),
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
                selectedService =
                    null; // Reset selected service when barber changes
              });
            },
          ),
          const SizedBox(height: 24),

          // Pilih Layanan (only show after selecting Barber)
          if (selectedBarber != null) ...[
            const Text(
              'Pilih Layanan',
              style: TextStyle(fontSize: 16),
            ),
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
            const SizedBox(height: 24),
          ],

          // Pilih Jam
          const Text(
            'Pilih Jam',
            style: TextStyle(fontSize: 16),
          ),
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

          // Pesan Sekarang Button
          Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A9AB0),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
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
    );
  }

  //Detail Reservasi
Widget _buildReservationDetails(Map<String, dynamic> reservation,
      {bool isHistory = false}) {
    String imagePath;
    if (reservation['barber'] == 'Ardha') {
      imagePath = 'lib/asset/1.jpg';
    } else if (reservation['barber'] == 'Dewa') {
      imagePath = 'lib/asset/2.jpg';
    } else if (reservation['barber'] == 'Hazel'){
      imagePath = 'lib/asset/3.jpg'; 
    }else{
      imagePath = 'lib/asset/4.jpg';
    }
    return Card(
      elevation: 2,
      color: const Color(0xFF6A9AB0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 16.0, top: 17.0), // Tambahkan padding top
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(12.0), // Tambahkan radius lengkungan
                child: Image.asset(
                  imagePath, // Use the selected image path
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        reservation['date']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        reservation['time']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Barber: ${reservation['barber']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Layanan: ${reservation['service']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Status: ${reservation['status']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: isHistory
                        ? [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UlasanPage(reservation: reservation),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF001f3f),
                              ),
                              child: Text(
                                'Ulasan',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailReservasiPage(reservation: reservation),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF001f3f),
                                  width: 2.0,
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                              child: const Text(
                                'Detail',
                                style: TextStyle(
                                  color: Color(0xFF001f3f),
                                ),
                              ),
                            ),
                          ]
                        : [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditReservationScreen(
                                      reservation: reservation,
                                    ),
                                  ),
                                ).then((updatedReservation) {
                                  // Periksa apakah ada reservasi yang diperbarui
                                  if (updatedReservation != null) {
                                    // Muat ulang daftar reservasi
                                    _loadReservations();
                                  }
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF001f3f),
                              ),
                              child: const Text(
                                'Edit',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 10),
                            TextButton(
                              onPressed: () async {
                                await DatabaseHelperReservasi.instance
                                    .cancelReservation(reservation['id']);
                                _loadReservations();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF001f3f),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildActiveReservations() {
    return ListView.builder(
      itemCount: activeReservations.length,
      itemBuilder: (context, index) {
        final reservation = activeReservations[index];
        return _buildReservationDetails(reservation);
      },
    );
  }

  Widget _buildHistoryReservations() {
    return ListView.builder(
      itemCount: canceledReservations.length,
      itemBuilder: (context, index) {
        final reservation = canceledReservations[index];
        return _buildReservationDetails(reservation, isHistory: true);
      },
    );
  }

// app bar RESERVASI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            showForm ? BackButton(onPressed: _toggleForm) : const BackButton(),
        title: const Text(
          'RESERVASI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: !showForm
            ? PreferredSize(
                preferredSize: const Size.fromHeight(78),
                child: Column(
                  children: [
                    const SizedBox(height: 38),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            TextButton(
                              onPressed: () => _onTabSelected(true),
                              child: Text(
                                'AKTIF',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isAktifSelected
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 0),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 3,
                              width: isAktifSelected ? 50 : 0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Column(
                          children: [
                            TextButton(
                              onPressed: () => _onTabSelected(false),
                              child: Text(
                                'RIWAYAT',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: !isAktifSelected
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 0),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 3,
                              width: !isAktifSelected ? 50 : 0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : null,
      ),
      body: showForm
          ? _buildForm()
          : isAktifSelected
              ? (activeReservations.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 21.0),
                        child: Image.asset(
                          'lib/asset/reservasiAktif.png',
                          height: 280,
                        ),
                      ),
                    )
                  : _buildActiveReservations())
              : (canceledReservations.isEmpty
                  ? Center(
                      child: Image.asset(
                        'lib/asset/reservasi.png',
                        height: 300,
                      ),
                    )
                  : _buildHistoryReservations()),
      floatingActionButton: !showForm && isAktifSelected
          ? FloatingActionButton(
              onPressed: _toggleForm,
              child: const Icon(
                Icons.add,
                size: 50,
                color: Colors.white,
              ),
              backgroundColor: const Color(0xFF6A9AB0),
            )
          : null,
    );
  }
}
