import 'package:a_salon/entity/Reservasi.dart';
import 'dart:convert';
import 'package:http/http.dart';

class ReservasiClient {
  // Sesuaikan URL dan endpoint dengan device yang digunakan untuk uji coba

  // // Untuk emulator
  static final String url = '192.168.1.4:8000'; // Base URLhttp://127.0.0.1:8000
  static final String endpoint = '/api/reservations'; // Base endpoint

  // Untuk HP
  // static final String url = '192.168.1.14';
  // static final String endpoint = '/GD_API_1658/public/api/reservasi';

  // Mengambil semua reservasi aktif (status = 'Booked')
static Future<List<Reservasi>> fetchActive() async {
  try {
    var response = await get(Uri.http(url, '$endpoint/active'));

    if (response.statusCode != 200) throw Exception(response.reasonPhrase);

    List<dynamic> list = json.decode(response.body);
    return list.map((e) => Reservasi.fromJson(e)).toList();
  } catch (e) {
    return Future.error(e.toString());
  }
}

  // Mengambil semua reservasi yang dibatalkan (status = '')
static Future<List<Reservasi>> fetchCanceled() async {
  try {
    var response = await get(Uri.http(url, '$endpoint/canceled'));

    if (response.statusCode != 200) throw Exception(response.reasonPhrase);

    List<dynamic> list = json.decode(response.body);
    return list.map((e) => Reservasi.fromJson(e)).toList();
  } catch (e) {
    return Future.error(e.toString());
  }
}

  // Mengambil data reservasi berdasarkan ID
  static Future<Reservasi> find(id) async {
    try {
      var response = await get(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return Reservasi.fromJson(json.decode(response.body));
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Membuat data reservasi baru
  static Future<Response> create(Reservasi reservasi) async {
    try {
      var response = await post(
        Uri.http(url, endpoint),
        headers: {"Content-Type": "application/json"},
        body: reservasi.toRawJson(),
      );

      if (response.statusCode != 201) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Mengubah data reservasi berdasarkan ID
  static Future<Response> update(Reservasi reservasi) async {
    try {
      var response = await put(
        Uri.http(url, '$endpoint/${reservasi.id}'),
        headers: {"Content-Type": "application/json"},
        body: reservasi.toRawJson(),
      );

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Menghapus data reservasi berdasarkan ID
  static Future<Response> destroy(id) async {
    try {
      var response = await delete(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Membatalkan reservasi (set status = 'Selesai')
 static Future<Response> cancel(int id) async {
  try {
    var response = await patch(
      Uri.http(url, '$endpoint/$id/cancel'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) throw Exception(response.reasonPhrase);

    return response;
  } catch (e) {
    return Future.error(e.toString());
  }
}
}
