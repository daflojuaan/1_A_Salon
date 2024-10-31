import 'package:flutter/material.dart';
import 'package:a_salon/view/tampilanProfile.dart';
import 'package:a_salon/view/reservasiList.dart';
import 'package:a_salon/view/login.dart';

class HomeView extends StatefulWidget {
  final Map<String, dynamic>? profileData;

  const HomeView({super.key, this.profileData});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  bool _isBalanceVisible = true;
  late List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const Center(),
      const Center(),
      ProfileView(user: widget.profileData),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Selamat Datang',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF001F3F),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'images/logo putih.jpg',
            width: 500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 58, 109, 140),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Saldo',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isBalanceVisible ? 'Rp. 0' : '•••',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isBalanceVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isBalanceVisible = !_isBalanceVisible;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: () {},
                        child: const Text('+ Top Up Saldo'),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Point',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Bonus',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Menu
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      ' Menu',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMenuItem(Icons.payment, 'Pembayaran\nSaya', () {
                          print('Pembayaran Saya Tapped');
                        }),
                        _buildMenuItem(Icons.calendar_today, 'Reservasi\n', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ReservasiView()),
                          );
                        }),
                        _buildMenuItem(Icons.feedback, 'Keluhan\nPelanggan',
                            () {
                          print('Keluhan Pelanggan Tapped');
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: _buildPromoSection('Promo HairCut', ['Promo 1']),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: _buildPromoSection('Promo HairCut', ['Promo 2']),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: _buildPromoSection('Promo HairCut', ['Promo 3']),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: _widgetOptions.elementAt(_selectedIndex),
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
            icon: Icon(Icons.qr_code_scanner_outlined),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 30,
            child: Icon(icon, size: 30, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSection(String title, List<String> promoTitles) {
    return Container(
      height: 200,
      width: 450,
      color: const Color(0xFF001F3F),
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              '-Promo HairCut-',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Expanded(
            child: Center(
              child: _buildPromoBox(promoTitles[0]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBox(String title) {
    return Container(
      width: 400,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
