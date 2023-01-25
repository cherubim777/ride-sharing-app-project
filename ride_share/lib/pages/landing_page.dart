import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GeoPoint startingPoint = GeoPoint(latitude: 0, longitude: 0);
  GeoPoint destinationPoint = GeoPoint(latitude: 0, longitude: 0);

  MapController controller = MapController(
    initMapWithUserPosition: false,
    initPosition: GeoPoint(latitude: 9.005401, longitude: 38.763611),
    areaLimit: BoundingBox(
      east: 15.0,
      north: 47.738,
      south: 33.017,
      west: 3.233,
    ),
  );

  // String googleApikey = "AIzaSyDjg5BjkediEdY8WoxWZlnw7jT1c4yIilo";
  // TextEditingController textController = TextEditingController();
  // LatLng userCurrentLocation = LatLng(9.033314395327793, 38.76338387172701);
  // LatLng destinationLocation = LatLng(9.037903472374747, 38.76270242040341);
  // LatLng? locationChoice;
  // final startFieldController = TextEditingController();
  // final destinationFieldController = TextEditingController();
  // List<Address>? placemarks;
  // final Set<Marker> markers = new Set();
  // Completer<GoogleMapController> _controller = Completer();
  // GoogleMapController? mapController;
  // String location = "Search Location";
  // Future<Position> getCurrentLocation() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Error');
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error('on Denied Permanently');
  //   }
  //   return await Geolocator.getCurrentPosition();
  // }

  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // addMarker(String id, String title, LatLng position, double hue) {
  //   markers.add(Marker(
  //     markerId: MarkerId(id),
  //     position: position,
  //     infoWindow: InfoWindow(title: title),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(hue),
  //   ));
  // }
  Future<List<String>> fetchSuggestions(String input) async {
    List<String> suggestions = [];
    try {
      List<SearchInfo> suggestionsInfo =
          await addressSuggestion(input, limitInformation: 10);
      if (suggestionsInfo.isEmpty) {
        return [];
      }
      for (var info in suggestionsInfo) {
        suggestions.add(info.address.toString());
      }
    } catch (error) {
      return [];
    }

    return suggestions;
  }

  Future<GeoPoint> getPointFromAddress(String address) async {
    if (address == "Your Location") {
      return await controller.myLocation();
    }
    List<SearchInfo> suggestionsInfo =
        await addressSuggestion(address, limitInformation: 2);
    return suggestionsInfo[0].point!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Stack(
      //   children: [
      //     GoogleMap(
      //       initialCameraPosition: CameraPosition(
      //         target: userCurrentLocation,
      //         zoom: 15,
      //       ),
      //       markers: markers,
      //       myLocationEnabled: true,
      //       myLocationButtonEnabled: true,
      //       mapToolbarEnabled: true,
      //       onMapCreated: ((GoogleMapController controller) {
      //         _controller.complete(controller);
      //         setState(() {});
      //       }),
      //       onCameraMove: (position) {
      //         setState(() {
      //           locationChoice = position.target;
      //         });
      //       },
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.only(bottom: 23.0),
      //       child: Center(
      //           child: Icon(
      //         Icons.place,
      //         color: Colors.red[800],
      //         size: 40,
      //       )),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(15.0),
      //       child: Column(
      //         children: [
      //           Positioned(
      //             top: 10,
      //             right: 15,
      //             left: 15,
      //             child: Container(
      //               color: Colors.white,
      //               child: Row(
      //                 children: <Widget>[
      //                   IconButton(
      //                     splashColor: Colors.grey,
      //                     icon: Icon(Icons.place),
      //                     onPressed: () {},
      //                   ),
      //                   const Expanded(
      //                     child: TextField(
      //                       readOnly: true,
      //                       showCursor: true,
      //                       cursorColor: Colors.black,
      //                       keyboardType: TextInputType.text,
      //                       textInputAction: TextInputAction.go,
      //                       decoration: InputDecoration(
      //                           border: InputBorder.none,
      //                           contentPadding:
      //                               EdgeInsets.symmetric(horizontal: 15),
      //                           hintText: "Starting Location..."),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           const SizedBox(
      //             height: 10,
      //           ),
      //           Positioned(
      //             top: 10,
      //             right: 15,
      //             left: 15,
      //             child: Container(
      //               color: Colors.white,
      //               child: Row(
      //                 children: <Widget>[
      //                   IconButton(
      //                     splashColor: Colors.grey,
      //                     icon: const Icon(Icons.local_taxi),
      //                     onPressed: () {},
      //                   ),
      //                   const Expanded(
      //                     child: TextField(
      //                       readOnly: true,
      //                       showCursor: true,
      //                       cursorColor: Colors.black,
      //                       keyboardType: TextInputType.text,
      //                       textInputAction: TextInputAction.go,
      //                       decoration: InputDecoration(
      //                           border: InputBorder.none,
      //                           contentPadding:
      //                               EdgeInsets.symmetric(horizontal: 15),
      //                           hintText: "Destination Location"),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),

      body: Stack(
        children: [
          OSMFlutter(
            controller: controller,
            // trackMyPosition: true,
            showZoomController: true,
            androidHotReloadSupport: true,
            initZoom: 6,
            minZoomLevel: 8,
            maxZoomLevel: 19,
            stepZoom: 1.0,
            userLocationMarker: UserLocationMaker(
              personMarker: const MarkerIcon(
                icon: Icon(
                  Icons.location_history_rounded,
                  color: Colors.red,
                  size: 48,
                ),
              ),
              directionArrowMarker: const MarkerIcon(
                icon: Icon(
                  Icons.place,
                  size: 48,
                ),
              ),
            ),
            roadConfiguration: RoadConfiguration(
              startIcon: const MarkerIcon(
                icon: Icon(
                  Icons.person,
                  size: 64,
                  color: Colors.brown,
                ),
              ),
              roadColor: Colors.yellowAccent,
            ),
            markerOption: MarkerOption(
                defaultMarker: const MarkerIcon(
              icon: Icon(
                Icons.person_pin_circle,
                color: Colors.blue,
                size: 56,
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Autocomplete(
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text.isEmpty) {
                      // return const Iterable<String>.empty();
                      return ["Your Location"];
                    } else {
                      List<String> sug =
                          await fetchSuggestions(textEditingValue.text);

                      return sug.where((word) => word
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                    }
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    return TextField(
                      onSubmitted: (value) {},
                      controller: textEditingController,
                      focusNode: focusNode,
                      onEditingComplete: onFieldSubmitted,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.place),
                          suffix: IconButton(
                              onPressed: () async {
                                controller.removeMarker(startingPoint);
                                GeoPoint current = await getPointFromAddress(
                                    textEditingController.text);
                                startingPoint = current;
                                controller.removeMarker(current);
                                controller.changeLocation(current);
                                controller.setMarkerIcon(
                                  current,
                                  MarkerIcon(
                                    icon: Icon(Icons.place,
                                        color: Colors.red[900], size: 100),
                                  ),
                                );
                              },
                              icon: Icon(Icons.arrow_right_alt)),
                          filled: true,
                          constraints: BoxConstraints(maxHeight: 60),
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none),
                          // contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Starting Location..."),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Autocomplete(
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                      // return ["Your Location"];
                    } else {
                      List<String> sug =
                          await fetchSuggestions(textEditingValue.text);

                      return sug.where((word) => word
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                    }
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      onEditingComplete: onFieldSubmitted,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.local_taxi),
                          suffix: IconButton(
                              onPressed: () async {
                                controller.removeMarker(destinationPoint);
                                GeoPoint current = await getPointFromAddress(
                                    textEditingController.text);
                                destinationPoint = current;
                                controller.removeMarker(current);
                                controller.changeLocation(current);

                                controller.setMarkerIcon(
                                  current,
                                  MarkerIcon(
                                    icon: Icon(Icons.place,
                                        color: Colors.blue[900], size: 100),
                                  ),
                                );
                              },
                              icon: Icon(Icons.arrow_right_alt)),
                          filled: true,
                          constraints: BoxConstraints(maxHeight: 60),
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none),
                          // contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Destination Location..."),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              controller.zoomIn();
            },
            child: Icon(Icons.zoom_in),
            heroTag: null,
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              controller.zoomOut();
            },
            child: Icon(Icons.zoom_out),
            heroTag: null,
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () async {
              controller.zoomToBoundingBox(
                  BoundingBox.fromGeoPoints([startingPoint, destinationPoint]),
                  paddinInPixel: 400);

              RoadInfo roadInfo = await controller.drawRoad(
                destinationPoint,
                startingPoint,
                roadType: RoadType.car,
                roadOption: RoadOption(
                  roadWidth: 20,
                  roadColor: Colors.purple[400],
                  showMarkerOfPOI: true,
                  zoomInto: true,
                ),
              );
            },
            child: Icon(Icons.arrow_right_alt_sharp),
            heroTag: null,
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () async {
              await controller.currentLocation();
              controller.zoomIn();
            },
            child: Icon(Icons.my_location),
            heroTag: null,
          ),
        ],
      ),
    );
  }
}
