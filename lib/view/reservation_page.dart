import 'package:flutter/material.dart';
import 'package:a_salon/database/database_helper_reservation.dart';

class ReservationPage extends StatefulWidget {
  final bool initiallyShowForm; // Parameter baru
  final String? preselectedBarber; // Parameter untuk barber yang dipilih
  final List<String>? availableServices; // Parameter untuk layanan yang tersedia

  const ReservationPage({
    Key? key,
    this.initiallyShowForm = false,
    this.preselectedBarber,
    this.availableServices,
  }) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final DatabaseHelperReservasi _dbHelper = DatabaseHelperReservasi.instance;
  int _selectedIndex = 2;
  bool isAktifSelected = true;
  late bool showForm;
  List<Map<String, dynamic>> activeReservations = [];

  // Form state variables
  DateTime? selectedDate;
  String? selectedService;
  String? selectedBarber;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    _loadReservations();
    showForm = widget.initiallyShowForm;
    if (widget.preselectedBarber != null) {
      selectedBarber = widget.preselectedBarber;
    }
  }

  final List<String> jamTersedia = [
    '09:00',
    '10:00',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00'
  ];

  final List<String> layanan = [
    'Potong Rambut',
    'Creambath',
    'Hair Coloring',
    'Styling'
  ];

  final List<String> barbers = ['John', 'Mike', 'David', 'Sarah'];

  void _loadReservations() async {
    final data = await _dbHelper.getActiveReservations();
    setState(() {
      activeReservations = data;
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
            title: const Text('Konfirmasi Reservasi'),
            content: const Text('Apakah Anda yakin ingin memesan layanan ini?'),
            actions: [
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
                child: const Text('Ya'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tidak'),
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
    // Gunakan widget.availableServices jika tersedia, jika tidak gunakan daftar layanan default
    final services = widget.availableServices ?? layanan;
    
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

          // Pilih Layanan (menggunakan layanan dari barber yang dipilih)
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
            items: services.map((String value) {
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

          // Pilih Barber (disabled jika sudah dipilih dari halaman barber)
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
            items: widget.preselectedBarber != null 
                ? [
                    DropdownMenuItem<String>(
                      value: widget.preselectedBarber,
                      child: Text(widget.preselectedBarber!),
                    )
                  ]
                : barbers.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            onChanged: widget.preselectedBarber != null 
                ? null // Disable jika barber sudah dipilih
                : (newValue) {
                    setState(() {
                      selectedBarber = newValue;
                    });
                  },
          ),
          const SizedBox(height: 24),

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
  Widget _buildReservationDetails(Map<String, dynamic> reservation) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                'images/layanan.jpg',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Barber: ${reservation['barber']}',
                        style: const TextStyle(fontSize: 14),
                      ),
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
                    children: [
                      TextButton(
                        onPressed: () {
                          // fungsionalitas
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
                        onPressed: () {
                          // fungsionalitas
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
                  )
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


      //set gambar Menu AKTIF dan RIWAYAT
      body: showForm
          ? _buildForm()
          : isAktifSelected
              ? (activeReservations.isEmpty
                  ? Center(
                      child: Image.asset(
                        'asset/reservasi.png',
                        height: 300,
                      ),
                    )
                  : _buildActiveReservations())
              : Center(
                  child: Image.asset(
                    'asset/reservasi.png',
                    height: 300,
                  ),
                ),
      floatingActionButton: !showForm
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
