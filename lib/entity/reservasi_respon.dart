class ReservasiResponse {
  String? message;
  List<Reservasis>? reservasis;

  ReservasiResponse({this.message, this.reservasis});

  ReservasiResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['reservasis'] != null) {
      reservasis = <Reservasis>[];
      json['reservasis'].forEach((v) {
        reservasis!.add(new Reservasis.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.reservasis != null) {
      data['reservasis'] = this.reservasis!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reservasis {
  int? id;
  int? idUser;
  String? date;
  String? time;
  String? barber;
  String? service;
  int? harga;
  String? status;

  Reservasis(
      {this.id,
      this.idUser,
      this.date,
      this.time,
      this.barber,
      this.service,
      this.harga,
      this.status});

  Reservasis.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['id_user'];
    date = json['date'];
    time = json['time'];
    barber = json['barber'];
    service = json['service'];
    harga = json['harga'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_user'] = this.idUser;
    data['date'] = this.date;
    data['time'] = this.time;
    data['barber'] = this.barber;
    data['service'] = this.service;
    data['harga'] = this.harga;
    data['status'] = this.status;
    return data;
  }
}
