import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class CreatorPage extends StatefulWidget {
  CreatorPage({super.key});

  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage> {
  late GeoPoint currentLocation;
  GeoPoint startingPoint = GeoPoint(latitude: 0, longitude: 0);
  GeoPoint destinationPoint = GeoPoint(latitude: 0, longitude: 0);
  int numberOfAvailableSeats = 0;

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

  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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

  Future askAvailableSpace() => showDialog(
        context: context,
        builder: (BuildContext c) {
          TextEditingController textController = TextEditingController();
          FocusManager.instance.primaryFocus?.unfocus();

          controller.zoomToBoundingBox(
              BoundingBox.fromGeoPoints([startingPoint, destinationPoint]),
              paddinInPixel: 100);

          return AlertDialog(
            title: const Text("Enter number of available space"),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: textController,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  if (int.parse(textController.text) <= 0) {
                    textController.text = "1";
                  } else if (int.parse(textController.text) >= 5) {
                    textController.text = "5";
                  } else {
                    Navigator.of(c).pop();

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
                  }
                },
                child: const Text('Ok'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(c).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OSMFlutter(
            controller: controller,
            showZoomController: true,
            // androidHotReloadSupport: true,
            onLocationChanged: (p0) {
              currentLocation = p0;
            },
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
            onPressed: askAvailableSpace,
            child: Icon(Icons.directions),
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
