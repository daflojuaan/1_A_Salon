import 'dart:convert';

class Reservasi {
  final int id;
  final String date;
  final String time;
  final String barber;
  final String service;
  final String status;

  Reservasi({
    required this.id,
    required this.date,
    required this.time,
    required this.barber,
    required this.service,
    required this.status,
  });

  factory Reservasi.fromJson(Map<String, dynamic> json) {
    return Reservasi(
      id: json['id'],
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      barber: json['barber'] ?? '',
      service: json['service'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'barber': barber,
      'service': service,
      'status': status,
    };
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }
}
