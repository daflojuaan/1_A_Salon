import 'package:flutter/material.dart';
import 'package:a_salon/view/home.dart';

class ReservasiView extends StatefulWidget {
  const ReservasiView({super.key});

  @override
  State<ReservasiView> createState() => _ReservasiPageState();
}

class _ReservasiPageState extends State<ReservasiView> {
  final int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/');
    } else if (index == 1) {
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  final List<String> orderHistory = [];
  final TextEditingController _controller = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedOutlet;
  String? _selectedService;
  String? _selectedTime;

  final List<String> outlets = ['Babarsary', 'Gejayan'];
  final List<String> services = [
    'Haircut',
    'Korean Perm',
    'Curly Perm',
    'Hair Coloring'
  ];
  final List<String> availableTimes = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '13:00 PM',
    '14:00 PM',
    '15:00 PM',
    '16:00 PM',
    '18:00 PM',
    '19:00 PM',
    '20:00 PM'
  ];

  void _addOrder(String order) {
    setState(() {
      orderHistory.add(order);
    });
    _controller.clear();
  }

  void _removeOrder(int index) {
    setState(() {
      orderHistory.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showReservationForm() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedOutlet,
                hint: const Text('Pilih Outlet'),
                items: outlets.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedOutlet = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedService,
                hint: const Text('Pilih Layanan Reservasi'),
                items: services.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedService = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: _selectedDate == null
                      ? 'Pilih Tanggal'
                      : _selectedDate.toString().split(' ')[0],
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTime,
                hint: const Text('Pilih Waktu Reservasi'),
                items: availableTimes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedTime = newValue;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_selectedDate != null &&
                      _selectedOutlet != null &&
                      _selectedService != null &&
                      _selectedTime != null) {
                    String newOrder =
                        '$_selectedService di outlet $_selectedOutlet pada ${_selectedDate?.toLocal().toString().split(' ')[0]} jam $_selectedTime';
                    _addOrder(newOrder);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Konfirmasi Reservasi'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('Reservasi'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: _showReservationForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 31, 63),
                ),
                icon: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                label: const Text(
                  'Reservasi Baru',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Riwayat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: orderHistory.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(orderHistory[index]),
                        subtitle: const Text('Detail pesanan'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeOrder(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 0, 31, 63),
          selectedItemColor: const Color.fromARGB(234, 216, 177, 0),
          unselectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }
}
