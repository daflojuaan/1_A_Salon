import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Service {
  final int id;
  final int barberId;
  final String serviceName;
  final int price;

  Service({
    required this.id,
    required this.barberId,
    required this.serviceName,
    required this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      barberId: json['id_barber'],
      serviceName: json['name'],
      price: int.parse(json['harga'].toString()),
    );
  }
}

class Barber {
  final int id;
  final String barbername;
  final String phone;
  final String experience;
  final String? photo;
  List<Service> services = [];

  Barber({
    required this.id,
    required this.barbername,
    required this.phone,
    required this.experience,
    this.photo,
    this.services = const [],
  });

  factory Barber.fromJson(Map<String, dynamic> json) {
    return Barber(
      id: json['id'],
      barbername: json['barbername'],
      phone: json['phone'],
      experience: json['experience'],
      photo: json['photo'],
    );
  }
}

class BarberProfilePage extends StatelessWidget {
  const BarberProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BarberPage();
  }
}

class BarberPage extends StatefulWidget {
  const BarberPage({super.key});

  @override
  State<BarberPage> createState() => _BarberPageState();
}

class _BarberPageState extends State<BarberPage> {
  List<Barber> barbers = [];

  @override
  void initState() {
    super.initState();
    getBarbers();
  }

  Future<void> getBarbers() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/barber'));

    if (response.statusCode == 200) {
      final List<Barber> loadedBarbers = (json.decode(response.body) as List)
            .map((data) => Barber.fromJson(data))
            .toList();
      
      for (var barber in loadedBarbers) {
        final servicesResponse = await http.get(
          Uri.parse('http://10.0.2.2:8000/api/service/get/${barber.id}'),
        );

        if (servicesResponse.statusCode == 200) {
          final List<Service> services = (json.decode(servicesResponse.body) as List)
              .map((data) => Service.fromJson(data))
              .toList();
          barber.services = services;
        }
      }
      setState(() {
          barbers = loadedBarbers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Our Barbers',
          style: TextStyle(
            color: const Color.fromARGB(255, 0, 31, 63),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: barbers.length,
          itemBuilder: (context, index) {
            final barber = barbers[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: BarberCard(
                name: barber.barbername,
                experience: '${barber.experience} years experience',
                imageUrl: barber.photo,
                contact: barber.phone,
                services: barber.services, 
              ),
            );
          },
        ),
      ),
    );
  }
}

class BarberCard extends StatelessWidget {
  final String name;
  final String experience;
  final String? imageUrl;
  final String contact;
  final List<Service> services;

  const BarberCard({
    super.key,
    required this.name,
    required this.experience,
    this.imageUrl,
    required this.contact,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => ServicesBottomSheet(
            name: name,
            services: services,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Container(
                height: 200,
                color: Colors.grey[300],
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? Image(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: $error');
                          return const Center(
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            // Barber Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    experience,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: const Color.fromARGB(255, 0, 31, 63),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        contact,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Tap to see services',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 31, 63),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: const Color.fromARGB(255, 0, 31, 63),
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
}

class ServicesBottomSheet extends StatelessWidget {
  final String name;
  final List<Service> services;

  const ServicesBottomSheet({
    super.key,
    required this.name,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$name\'s Services',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...services.map((service) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.serviceName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Rp ${service.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.check_circle,
                    color: const Color.fromARGB(255, 0, 31, 63),
                  ),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}