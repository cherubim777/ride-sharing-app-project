// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_geocoder/geocoder.dart';

// class MainPage extends StatefulWidget {
//   MainPage({super.key});

//   // final Completer<GoogleMapController> _controller = Completer();

//   double lat = 100;
//   double lng = -40;

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   String googleApikey = "AIzaSyDjg5BjkediEdY8WoxWZlnw7jT1c4yIilo";
//   TextEditingController textController = TextEditingController();
//   LatLng userCurrentLocation = LatLng(9.033314395327793, 38.76338387172701);
//   LatLng destinationLocation = LatLng(9.037903472374747, 38.76270242040341);
//   LatLng? locationChoice;

//   final startFieldController = TextEditingController();
//   final destinationFieldController = TextEditingController();
//   List<Address>? placemarks;

//   final Set<Marker> markers = new Set();
//   Completer<GoogleMapController> _controller = Completer();
//   // GoogleMapController? mapController;

//   String location = "Search Location";
//   Future<Position> getCurrentLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Error');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('on Denied Permanently');
//     }
//     return await Geolocator.getCurrentPosition();
//   }

//   void initState() {
//     super.initState();
//     String googleApikey = "AIzaSyBzogOnf5nhgsGym6PIsuHKibpF8hqY7wc";

//     getCurrentLocation().then((value) async {
//       userCurrentLocation = LatLng(value.latitude, value.longitude);
//       print('Latitude: ${value.latitude} and Longitude: ${value.longitude}');
//     });
//   }

//   @override
//   void dispose() {
//     startFieldController.dispose();
//     destinationFieldController.dispose();
//     super.dispose();
//   }

//   addMarker(String id, String title, LatLng position, double hue) {
//     markers.add(Marker(
//       markerId: MarkerId(id),
//       position: position,
//       infoWindow: InfoWindow(title: title),
//       icon: BitmapDescriptor.defaultMarkerWithHue(hue),
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: userCurrentLocation,
//               zoom: 15,
//             ),
//             markers: markers,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             mapToolbarEnabled: true,
//             onMapCreated: ((GoogleMapController controller) {
//               _controller.complete(controller);
//               setState(() {});
//             }),
//             onCameraMove: (position) {
//               setState(() {
//                 locationChoice = position.target;
//               });
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 23.0),
//             child: Center(
//                 child: Icon(
//               Icons.place,
//               color: Colors.red[800],
//               size: 40,
//             )),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Column(
//               children: [
//                 Positioned(
//                   top: 10,
//                   right: 15,
//                   left: 15,
//                   child: Container(
//                     color: Colors.white,
//                     child: Row(
//                       children: <Widget>[
//                         IconButton(
//                           splashColor: Colors.grey,
//                           icon: Icon(Icons.place),
//                           onPressed: () {},
//                         ),
//                         const Expanded(
//                           child: TextField(
//                             readOnly: true,
//                             showCursor: true,
//                             cursorColor: Colors.black,
//                             keyboardType: TextInputType.text,
//                             textInputAction: TextInputAction.go,
//                             decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 contentPadding:
//                                     EdgeInsets.symmetric(horizontal: 15),
//                                 hintText: "Starting Location..."),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Positioned(
//                   top: 10,
//                   right: 15,
//                   left: 15,
//                   child: Container(
//                     color: Colors.white,
//                     child: Row(
//                       children: <Widget>[
//                         IconButton(
//                           splashColor: Colors.grey,
//                           icon: const Icon(Icons.local_taxi),
//                           onPressed: () {},
//                         ),
//                         const Expanded(
//                           child: TextField(
//                             readOnly: true,
//                             showCursor: true,
//                             cursorColor: Colors.black,
//                             keyboardType: TextInputType.text,
//                             textInputAction: TextInputAction.go,
//                             decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 contentPadding:
//                                     EdgeInsets.symmetric(horizontal: 15),
//                                 hintText: "Destination Location"),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           placemarks = await Geocoder.local.findAddressesFromCoordinates(
//               Coordinates(locationChoice!.latitude, locationChoice!.longitude));

//           print(
//               "${placemarks?.first.adminArea}, ${placemarks?.first.featureName}, ${placemarks?.first.addressLine}");
//         },
//         child: const Icon(Icons.arrow_right_alt_rounded),
//       ),
//     );
//   }
// }
