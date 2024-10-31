import 'package:flutter/material.dart';
import 'package:a_salon/view/home.dart';
import 'package:a_salon/view/reservasiList.dart';
import 'package:a_salon/view/register.dart';

class ProfileView extends StatefulWidget {
  final Map<String, dynamic>? user;

  const ProfileView({super.key, this.user});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    Map? dataForm = widget.user;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 0, 31, 63),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: Colors.white,
            onPressed: () {
              // Code edit setting
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.help),
            color: Colors.white,
            onPressed: () {
              // Code edit help
              Navigator.pushNamed(context, '/help');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 72,
                    backgroundImage: NetworkImage(
                        'https://akcdn.detik.net.id/visual/2023/10/10/reaksi-jefri-nichol-ditanya-soal-hijrah-usai-ikut-kajian-bareng-abidzar-1_43.jpeg?w=650&q=90'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    dataForm!['nama'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              color: const Color.fromARGB(255, 0, 31, 63),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text(
                  "Username",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  dataForm['username'],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Card(
              elevation: 2,
              color: const Color.fromARGB(255, 0, 31, 63),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.white),
                title: const Text(
                  "Email",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  dataForm['email'],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Card(
              elevation: 2,
              color: const Color.fromARGB(255, 0, 31, 63),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.white),
                title: const Text(
                  "Nomor Telepon",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  dataForm['notelp'],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            Card(
              elevation: 2,
              color: const Color.fromARGB(255, 0, 31, 63),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.boy, color: Colors.white),
                title: const Text(
                  "Jenis Kelamin",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  dataForm['gender'],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Code edit profile
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 31, 63),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Edit Profile",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
