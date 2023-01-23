import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Share'),
      ),
      body: const Text("My Man"),
    );
  }
}
