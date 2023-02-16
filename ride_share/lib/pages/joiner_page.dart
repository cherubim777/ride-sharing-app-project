import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:ride_share/Map/map.dart';
import 'package:ride_share/data/UserProfileData.dart';
import 'package:ride_share/data/dataModel.dart';

class JoinerPage extends StatefulWidget {
  JoinerPage({super.key});

  @override
  State<JoinerPage> createState() => _JoinerPageState();
}

class _JoinerPageState extends State<JoinerPage> {
  // GeoPoint startingPoint = GeoPoint(latitude: 0, longitude: 0);
  // GeoPoint destinationPoint = GeoPoint(latitude: 0, longitude: 0);

  GeoPoint? startingPoint;
  GeoPoint? destinationPoint;

  UserProfileData user = UserProfileData();
  var joinerMap = JoinerMap();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    joinerMap.controller.dispose();
    super.dispose();
  }

  void _registerIntoDatabase() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // String current = user.uid.toString();
        final currentProfileData = DataModel(
          user.uid.toString(),
          user.email.toString(),
          currentLocation: startingPoint.toString(),
          destinationLocation: destinationPoint.toString(),
        );
        this.user.registerUser(currentProfileData);
      }
    });
  }

  Future<GeoPoint> getPointFromAddress(String address) async {
    if (address == "Your Location") {
      return await joinerMap.controller.myLocation();
    }
    List<SearchInfo> suggestionsInfo =
        await addressSuggestion(address, limitInformation: 2);
    return suggestionsInfo[0].point!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OSMFlutter(
            controller: joinerMap.controller,
            showZoomController: true,
            androidHotReloadSupport: true,
            initZoom: 11,
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
                      return const Iterable<String>.empty();
                    } else {
                      List<String> sug = await joinerMap
                          .fetchSuggestions(textEditingValue.text);

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
                          prefixIcon: const Icon(Icons.local_taxi),
                          suffix: IconButton(
                              onPressed: () async {
                                FocusManager.instance.primaryFocus?.unfocus();

                                GeoPoint current = await getPointFromAddress(
                                    textEditingController.text);

                                startingPoint =
                                    await joinerMap.controller.myLocation();
                                destinationPoint = current;

                                if (startingPoint != null) {
                                  joinerMap.controller.setStaticPosition(
                                      [startingPoint!], "location");
                                  if (destinationPoint != null) {
                                    joinerMap.controller.setStaticPosition(
                                        [destinationPoint!], "destination");
                                    joinerMap.controller.setMarkerOfStaticPoint(
                                      id: "destination",
                                      markerIcon: MarkerIcon(
                                        icon: Icon(
                                          Icons.place,
                                          color: Colors.blue[900],
                                          size: 100,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.done)),
                          filled: true,
                          constraints: const BoxConstraints(maxHeight: 60),
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none),
                          hintText: "Destination Location"),
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
              joinerMap.controller.zoomIn();
            },
            heroTag: null,
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              joinerMap.controller.zoomOut();
            },
            heroTag: null,
            child: const Icon(Icons.zoom_out),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () async {
              joinerMap.creatorPoint =
                  GeoPoint(latitude: 9.04083, longitude: 38.76194);

              if (joinerMap.creatorPoint != null) {
                joinerMap.controller.setStaticPosition([
                  joinerMap.creatorPoint!,
                ], "creator");
                joinerMap.controller.setMarkerOfStaticPoint(
                  id: "creator",
                  markerIcon: MarkerIcon(
                    icon: Icon(
                      Icons.drive_eta,
                      color: Colors.blue[900],
                      size: 100,
                    ),
                  ),
                );
                if (startingPoint != null &&
                    destinationPoint != null &&
                    startingPoint != joinerMap.creatorPoint) {
                  joinerMap.controller.zoomToBoundingBox(
                      BoundingBox.fromGeoPoints(
                          [startingPoint!, joinerMap.creatorPoint!]),
                      paddinInPixel: 350);

                  RoadInfo roadInfo = await joinerMap.controller.drawRoad(
                    startingPoint!,
                    joinerMap.creatorPoint!,
                    roadType: RoadType.car,
                    roadOption: RoadOption(
                      roadWidth: 20,
                      roadColor: Colors.purple[400],
                      showMarkerOfPOI: true,
                      zoomInto: true,
                    ),
                  );
                }
              }
            },
            heroTag: null,
            child: const Icon(Icons.directions),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: joinerMap.goToMyLocation,
            heroTag: null,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}
