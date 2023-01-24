import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  final Completer<GoogleMapController> _controller = Completer();
  late String lat;
  late String lng;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Completer<GoogleMapController> _controller = Completer();

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
    return Scaffold(
        body: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(10, 40),
            zoom: 8,
          ),
          onMapCreated: ((GoogleMapController controller) {
            _controller.complete(controller);
          }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            setState(() {
              getCurrentLocation().then((value) async {
                widget.lat = '${value.latitude}';
                widget.lng = '${value.longitude}';
                GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        double.parse(widget.lat),
                        double.parse(widget.lng),
                      ),
                      zoom: 17,
                    ),
                  ),
                );
              });
            });
          }),
          child: const Icon(Icons.my_location_outlined),
        ));
  }
}
