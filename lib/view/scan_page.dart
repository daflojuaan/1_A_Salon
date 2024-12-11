import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart' as barcode_widget;
import 'package:screen_brightness/screen_brightness.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:a_salon/view/create_pin_page.dart';
import 'package:a_salon/view/pin_pembayaran.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('QR Code App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRScreen()),
                );
              },
              icon: const Icon(Icons.qr_code),
              label: const Text('Show QR Code'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanPage()),
                );
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan QR Code'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final brightness = ScreenBrightness();

  @override
  void initState() {
    super.initState();
    setMaxBrightness();
  }

  Future<void> setMaxBrightness() async {
    try {
      await brightness.setScreenBrightness(1.0);
    } catch (e) {
      print('Error mengatur kecerahan: $e');
    }
  }

  Future<void> resetBrightness() async {
    try {
      await brightness.resetScreenBrightness();
    } catch (e) {
      print('Error mereset kecerahan: $e');
    }
  }

  @override
  void dispose() {
    resetBrightness();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('QR Code')),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: barcode_widget.BarcodeWidget(
            barcode: barcode_widget.Barcode.qrCode(),
            data:
                'Your fixed QR code data here', // Replace with your fixed data
            width: 250,
            height: 250,
            drawText: false,
          ),
        ),
      ),
    );
  }
}

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String result = "Scan a code";

  Future<bool> _checkPinExists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        return false;
      }

      final response = await http.get(
        Uri.parse('http://192.168.0.62:8000/api/profile/pin/check/$userId'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['hasPin'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error checking PIN: $e');
      return false;
    }
  }

  void _showCreatePinModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Buat PIN',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
              'Buatlah PIN terlebih dahulu untuk melanjutkan transaksi'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PinPage(
                      isUpdate: false,
                      userData: {},
                    ),
                  ),
                );
              },
              child: const Text(
                'Buat PIN',
                style: TextStyle(
                  color: Color(0xFF001F3F),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 0, 31, 63), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.hardEdge,
              child: MobileScanner(
                controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.noDuplicates,
                  returnImage: true,
                ),
                onDetect: (capture) async {
                  final List<Barcode> barcodes = capture.barcodes;
                  final Uint8List? image = capture.image;

                  if (barcodes.isNotEmpty) {
                    bool hasPin = await _checkPinExists();

                    if (!hasPin) {
                      if (mounted) {
                        _showCreatePinModal(context);
                      }
                    } else {
                      if (mounted) {
                        // Navigate to PaymentSuccessScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PinScreen(),
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Arahkan kamera ke QR Code',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRScreen()),
                );
              },
              icon: const Icon(Icons.qr_code),
              label: const Text('Generate QR Code'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: const Color.fromARGB(255, 0, 31, 63),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
