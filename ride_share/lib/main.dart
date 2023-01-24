import 'package:flutter/material.dart';
import 'package:ride_share/main_page.dart';

void main() {
  runApp(MaterialApp(
    home: MainPage(),
  ));
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
