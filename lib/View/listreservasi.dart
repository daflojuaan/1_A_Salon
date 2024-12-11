import 'package:a_salon/View/ReservasiPage.dart';
import 'package:flutter/material.dart';
import 'package:a_salon/entity/reservasi_respon.dart';
import 'package:a_salon/client/ReservasiClient.dart';
import 'package:a_salon/View/ReservasiPage.dart';

class ReservasiView extends StatefulWidget {
  const ReservasiView({super.key});

  @override
  State<ReservasiView> createState() => _ReservasiViewState();
}

class _ReservasiViewState extends State<ReservasiView> {
  ReservasiResponse? resp;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement
    // initState
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      final res = await ReservasiClient.fetchActive();
      setState(() {
        resp = res;
        isLoading = false;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Reservasi'),
      ),
      body: isLoading != true
          ? ListView.builder(
              itemCount: resp!.reservasis!.length,
              itemBuilder: (context, index) {
                final reservasi = resp!.reservasis![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(reservasi.barber ?? 'Barber Unknown'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Service: ${reservasi.service ?? 'N/A'}'),
                        Text('Date: ${reservasi.date ?? 'N/A'}'),
                        Text('Time: ${reservasi.time ?? 'N/A'}'),
                        Text('Harga: Rp ${reservasi.harga ?? 0}'),
                        Text('Status: ${reservasi.status ?? 'Unknown'}'),
                      ],
                    ),
                    trailing: Icon(Icons.chevron_right),
                  ),
                );
              },
            )
          : Center(
              child: Text('Tidak ada reservasi.'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReservasiPage()),
          );
          _fetchData();
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Reservasi',
      ),
    );
  }
}
