import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  Future<void>? _initializeCameraFuture;
  late CameraController _cameraController;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    // Mendapatkan daftar semua kamera yang tersedia pada perangkat
    _cameras = await availableCameras();

    // Mengatur kamera pertama sebagai kamera awal
    _setCameraController(_cameras[_selectedCameraIndex]);
  }

  Future<void> _setCameraController(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );

    _initializeCameraFuture = _cameraController.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _switchCamera() {
    setState(() {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    });
    _setCameraController(_cameras[_selectedCameraIndex]);
  }

  @override
  Widget build(BuildContext context) {
    if (_initializeCameraFuture == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambil Foto'),
      ),
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeCameraFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_cameraController);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          // Menempatkan tombol switch kamera di bagian bawah tengah
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: FloatingActionButton(
                onPressed: _switchCamera,
                child: const Icon(Icons.switch_camera),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeCameraFuture;

            // Mengambil gambar
            final image = await _cameraController.takePicture();

            Navigator.of(context).pop(image.path);
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}