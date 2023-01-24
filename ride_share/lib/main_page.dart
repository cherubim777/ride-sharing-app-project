import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: Stack(
        children: [
          const GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(12, 41),
              zoom: 9,
            ),
          ),
          Column(
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(50, 15, 50, 5),
                child: TextField(
                  decoration: InputDecoration(labelText: 'Starting Location'),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(50, 5, 50, 5),
                child: TextField(
                  decoration:
                      InputDecoration(labelText: 'Destination Location'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
