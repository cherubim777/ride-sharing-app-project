import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  final Completer<GoogleMapController> _controller = Completer();
  double lat = 100;
  double lng = -40;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? controller;

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Error');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Denied Permanently');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      getCurrentLocation().then((value) {
        widget.lat = value.latitude;
        widget.lng = value.longitude;
        print(widget.lat);
        print(widget.lng);
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.lat, widget.lat),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            getCurrentLocation().then((value) {
              widget.lat = value.latitude;
              widget.lng = value.longitude;
            });
          });
        },
        child: const Icon(Icons.my_location_outlined),
      ),
    );
  }
}
