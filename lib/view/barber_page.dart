import 'package:flutter/material.dart';
import 'package:a_salon/view/reservation_page.dart';

class BarberProfilePage extends StatelessWidget {
  const BarberProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BarberList();
  }
}

class BarberList extends StatelessWidget {
  const BarberList({super.key});

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
            colors: [
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            BarberCard(
              name: "John Smith",
              experience: "5 years experience",
              rating: 4.8,
              imageUrl: "/api/placeholder/400/400",
              specialties: ["Haircut", "Beard Trim", "Hair Coloring", "Styling"],
              contact: "+1234567890",
              available: true,
            ),
            SizedBox(height: 16),
            BarberCard(
              name: "Mike Johnson",
              experience: "8 years experience",
              rating: 4.9,
              imageUrl: "/api/placeholder/400/400",
              specialties: ["Premium Haircut", "Shaving", "Hair Treatment", "Kids Cut"],
              contact: "+1234567891",
              available: true,
            ),
            SizedBox(height: 16),
            BarberCard(
              name: "David Wilson",
              experience: "3 years experience",
              rating: 4.5,
              imageUrl: "/api/placeholder/400/400",
              specialties: ["Classic Haircut", "Beard Grooming", "Face Massage"],
              contact: "+1234567892",
              available: false,
            ),
          ],
        ),
      ),
    );
  }
}

class BarberCard extends StatelessWidget {
  final String name;
  final String experience;
  final double rating;
  final String imageUrl;
  final List<String> specialties;
  final String contact;
  final bool available;

  const BarberCard({
    super.key,
    required this.name,
    required this.experience,
    required this.rating,
    required this.imageUrl,
    required this.specialties,
    required this.contact,
    required this.available,
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
            specialties: specialties,
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
            // Barber Image with Status Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: available ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      available ? 'Available' : 'Busy',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
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
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
  final List<String> specialties;

  const ServicesBottomSheet({
    super.key,
    required this.name,
    required this.specialties,
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
          ...specialties.map((service) => Padding(
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
                      Text(
                        service,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Tutup bottom sheet
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservasiView(
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 31, 63),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Book Appointment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}