import 'package:flutter/material.dart';
import 'package:a_salon/view/ReservasiPage.dart';
import 'package:a_salon/client/ReservasiClient.dart';
import 'package:a_salon/entity/Reservasi.dart';
import 'package:a_salon/view/edit_reservasi_page.dart';
import 'package:a_salon/view/detail_reservasi_page.dart';
import 'package:a_salon/view/ulasan_page.dart';

class ListReservasiPage extends StatefulWidget {
  @override
  _ListReservasiPageState createState() => _ListReservasiPageState();
}

class _ListReservasiPageState extends State<ListReservasiPage> {
  bool showForm = false;
  bool isAktifSelected = true;
  List<Reservasi> activeReservations = [];
  List<Reservasi> canceledReservations = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.wait([
        _loadActiveReservations(),
        _loadCanceledReservations(),
      ]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat reservasi: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadActiveReservations() async {
    try {
      var reservations = await ReservasiClient.fetchActive();
      setState(() {
        activeReservations = reservations;
      });
    } catch (e) {
      print('Error loading active reservations: $e');
      rethrow;
    }
  }

  Future<void> _loadCanceledReservations() async {
    try {
      var reservations = await ReservasiClient.fetchCanceled();
      setState(() {
        canceledReservations = reservations;
      });
    } catch (e) {
      print('Error loading canceled reservations: $e');
      rethrow;
    }
  }

  void _toggleForm() {
    setState(() {
      showForm = !showForm;
    });
  }

  void _onTabSelected(bool isAktif) {
    setState(() {
      isAktifSelected = isAktif;
    });
  }

  void _navigateToReservasiPage() async {
    final newReservasi = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReservasiPage()),
    );

    if (newReservasi != null) {
      await _loadActiveReservations();
    }
  }

  void _navigateToEditReservation(Reservasi reservation) async {
    final updatedReservasi = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditReservationScreen(reservasi: reservation),
      ),
    );

    if (updatedReservasi != null) {
      await _loadReservations();
    }
  }

  Future<void> _cancelReservation(Reservasi reservation) async {
    try {
      await ReservasiClient.cancel(reservation.id);

      setState(() {
        var updatedReservation = Reservasi(
          id: reservation.id,
          date: reservation.date,
          time: reservation.time,
          barber: reservation.barber,
          service: reservation.service,
          status: 'Selesai',
        );

        activeReservations.remove(reservation);
        canceledReservations.add(updatedReservation);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservasi berhasil dibatalkan')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membatalkan reservasi: $e')),
      );
    }
  }

  Widget _buildReservationDetails(Reservasi reservation,
      {bool isHistory = false}) {
    String imagePath;
    switch (reservation.barber) {
      case 'Ardha':
        imagePath = 'lib/asset/1.jpg';
        break;
      case 'Dewa':
        imagePath = 'lib/asset/2.jpg';
        break;
      case 'Hazel':
        imagePath = 'lib/asset/3.jpg';
        break;
      default:
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
              padding: const EdgeInsets.only(right: 16.0, top: 17.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  imagePath,
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
                        reservation.date,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        reservation.time,
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
                        'Barber: ${reservation.barber}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Layanan: ${reservation.service}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Status: ${reservation.status}',
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
                                    builder: (context) => UlasanPage(
                                      reservasi: {
                                        'date': reservation.date,
                                        'time': reservation.time,
                                        'barber': reservation.barber,
                                        'service': reservation.service,
                                        'status': reservation.status,
                                      },
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF001f3f),
                              ),
                              child: const Text(
                                'Ulasan',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailReservasiPage(
                                      reservasi: {
                                        'date': reservation.date,
                                        'time': reservation.time,
                                        'barber': reservation.barber,
                                        'service': reservation.service,
                                        'status': reservation.status,
                                        'price': 0, // Add price property
                                      },
                                    ),
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
                                style: TextStyle(color: Color(0xFF001f3f)),
                              ),
                            ),
                          ]
                        : [
                            TextButton(
                              onPressed: () =>
                                  _navigateToEditReservation(reservation),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF001f3f),
                              ),
                              child: const Text(
                                'Edit',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 6),
                            TextButton(
                              onPressed: () => _cancelReservation(reservation),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF001f3f),
                              ),
                              child: const Text(
                                'Selesai',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 6),
                            TextButton(
                              onPressed: () async {
                                bool? confirmDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: const Color(0xFFEAD8B0),
                                      title: const Text(
                                        'KONFIRMASI',
                                        textAlign: TextAlign
                                            .center, // Pusatkan teks judul
                                      ),
                                      content: const Text(
                                          'Apakah Anda yakin ingin membatalkan reservasi ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                false); // Tidak jadi destroy
                                          },
                                          child: const Text('Tidak'),
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                const Color(0xFF001f3f),
                                            backgroundColor:
                                                const Color(0xFF6A9AB0),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                true); // Konfirmasi destroy
                                          },
                                          child: const Text('Ya'),
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                const Color(0xFF001f3f),
                                            backgroundColor:
                                                const Color(0xFF6A9AB0),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmDelete == true) {
                                  try {
                                    await ReservasiClient.destroy(
                                        reservation.id);
                                    setState(() {
                                      activeReservations.removeWhere(
                                          (r) => r.id == reservation.id);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Reservasi berhasil dihapus'),
                                            backgroundColor: Colors.green,
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Gagal menghapus reservasi: $e'),
                                            backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF800000),
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
        return _buildReservationDetails(activeReservations[index],
            isHistory: false);
      },
    );
  }

  Widget _buildHistoryReservations() {
    return ListView.builder(
      itemCount: canceledReservations.length,
      itemBuilder: (context, index) {
        return _buildReservationDetails(canceledReservations[index],
            isHistory: true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showForm ? BackButton(onPressed: _toggleForm) : BackButton(),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
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
              onPressed: _navigateToReservasiPage,
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
