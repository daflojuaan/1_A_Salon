import 'package:flutter/material.dart';
import 'package:a_salon/view/ListReservasiPage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
 Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListReservasiPage(), 
      routes: {
        '/ListReservasiPage': (context) => ListReservasiPage(), 
      },
    );
  }
}