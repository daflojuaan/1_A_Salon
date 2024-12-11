import 'package:a_salon/view/scan_page.dart';
import 'package:a_salon/view/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:a_salon/view/notification_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool isSaldoVisible = false;
  bool _isLoading = true;

  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    _getSaldo();
    _loadUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadUserData();
        _getSaldo();
      }
    });
  }

  Future<void> refreshData() async {
    if (mounted) {
      await _loadUserData();
      await _getSaldo();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _pages => [
        _buildHomePage(context),
        const ScanPage(),
        const ProfileScreen(), // Assuming you have a normal ProfilePage without user parameter
      ];

  Future<void> _getSaldo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt('userId');

      if (id == null) {
        throw Exception('User ID not found');
      }

      print('Fetching saldo for user ID: $id'); // Debug print

      final response = await http.get(
        Uri.parse('http://192.168.0.62:8000/api/profile/$id'),
        headers: {'Accept': 'application/json'},
      );

      print('Saldo Response: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            if (userData['user'] == null) {
              userData['user'] = {};
            }
            userData['user']['saldo'] = data['data']['user']['saldo'];
          });
        }
      } else {
        throw Exception('Failed to load saldo');
      }
    } catch (e) {
      print('Error getting saldo: $e'); // Debug print
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt('userId');

      if (id == null) {
        throw Exception('User ID not found. Please log in.');
      }

      final response = await http.get(
        Uri.parse('http://192.168.0.62:8000/api/profile/$id'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            userData = data['data'];
            _isLoading = false;
          });
        }
      } else {
        throw Exception(
            'Failed to load user data. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset('lib/asset/logo biru.png', height: 45),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Color(0xFF1B3358)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SELAMAT DATANG,',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B3358),
                letterSpacing: 0.5,
              ),
            ),
            Text(
              userData['user']['username'] ?? 'GUEST',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B3358),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 234, 212, 48),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Saldo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isSaldoVisible
                            ? 'Rp. ${(userData['user']?['saldo'] ?? 0).toString()}'
                            : 'Rp. ***',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isSaldoVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                isSaldoVisible = !isSaldoVisible;
                              });
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/topup');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 35, 64, 225),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            child: const Text(
                              '+ Top Up Saldo',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B3358),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMenuButton(
                  icon: Icons.calendar_today_outlined,
                  label: 'Reservasi',
                  onPressed: () {
                    Navigator.pushNamed(context, '/reservation');
                  },
                ),
                _buildMenuButton(
                  icon: Icons.store_outlined,
                  label: 'Barber',
                  onPressed: () {
                    Navigator.pushNamed(context, '/barber');
                  },
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 30),
                _buildPromoSection(
                  context,
                  'Promo Terbaru',
                  [
                    {
                      'title': 'Diskon 20% untuk Haircut',
                      'image': 'lib/asset/promo 1.jpg'
                    },
                  ],
                ),
                const SizedBox(height: 16),
                _buildPromoSection(
                  context,
                  'Promo Khusus',
                  [
                    {
                      'title': 'Potongan Harga untuk Paket',
                      'image': 'lib/asset/promo 2.jpg'
                    },
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(icon, size: 32, color: const Color(0xFF1B3358)),
            onPressed: onPressed,
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1B3358),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPromoSection(BuildContext context, String title,
      List<Map<String, String>> promoItems) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width * 0.9,
      color: const Color(0xFF001F3F),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              '-$title-',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: promoItems.length,
              itemBuilder: (context, index) {
                final promo = promoItems[index];
                return GestureDetector(
                  onTap: () => _showPromoNotification(context, promo['title']!),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _buildPromoBox(promo['image']!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPromoNotification(BuildContext context, String promoTitle) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detail Promo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B3358),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                promoTitle,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B3358),
                  ),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPromoBox(String imagePath) {
    return Container(
      width: 380,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.black),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image.asset(
          imagePath,
          width: 380,
          height: 110,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
