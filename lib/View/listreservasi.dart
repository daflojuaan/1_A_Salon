import 'package:flutter/material.dart';

class ReservasiView extends StatefulWidget {
  const ReservasiView({Key? key}) : super(key: key);

  @override
  State<ReservasiView> createState() => _ReservasiPageState();
}

class _ReservasiPageState extends State<ReservasiView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton (),
        title: const Text('Reservasi'),
        backgroundColor: const Color.fromARGB(255, 244, 239, 239),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: Color.fromARGB(255, 255, 255, 255)),
              label: const Text(
                'Reservasi Baru',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Riwayat',
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
