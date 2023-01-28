import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:ride_share/Map/map.dart';
import 'package:ride_share/data/UserProfileData.dart';
import 'package:ride_share/data/dataModel.dart';

class CreatorPage extends StatefulWidget {
  CreatorPage({super.key});

  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage> {
  GeoPoint? startingPoint;
  GeoPoint? destinationPoint;
  int numberOfAvailableSeats = 0;
  int passengersJoined = 0;

  UserProfileData user = UserProfileData();
  List<GeoPoint> joiners = [
    GeoPoint(latitude: 9.028622, longitude: 38.763225), // Friendship park
    GeoPoint(latitude: 9.036000, longitude: 38.763039), // Romina
    GeoPoint(latitude: 9.030251, longitude: 38.763458), // Abrehot Library
    GeoPoint(latitude: 9.038204, longitude: 38.763609), // Burte
    GeoPoint(latitude: 9.033495, longitude: 38.763833), // NBH complex
  ];

  List<GeoPoint> joined = [];

  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    MyMap.controller.dispose();
    _registerIntoDatabase(status: "offline");
    super.dispose();
  }

  void _registerIntoDatabase({String status = "offline"}) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // String current = user.uid.toString();
        final currentProfileData = DataModel(
          user.uid.toString(),
          user.email.toString(),
          currentLocation: startingPoint.toString(),
          destinationLocation: destinationPoint.toString(),
          userStatus: status,
        );
        this.user.registerUser(currentProfileData);
      }
    });
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
        if (info.address?.country == "ኢትዮጵያ") {
          print(info.address?.country);
          suggestions.add(info.address.toString());
        }
      }
    } catch (error) {
      return [];
    }

    return suggestions;
  }

  Future<GeoPoint> getPointFromAddress(String address) async {
    if (address == "Your Location") {
      return await MyMap.controller.myLocation();
    }
    List<SearchInfo> suggestionsInfo =
        await addressSuggestion(address, limitInformation: 2);
    return suggestionsInfo[0].point!;
  }

  Future askAvailableSpace() => showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController textController = TextEditingController();
          FocusManager.instance.primaryFocus?.unfocus();

          if (startingPoint != null && destinationPoint != null) {
            MyMap.controller.zoomToBoundingBox(
                BoundingBox.fromGeoPoints([startingPoint!, destinationPoint!]),
                paddinInPixel: 400);
          }
          return AlertDialog(
            title: const Text("Number of available seats"),
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
                  if (textController.text.isEmpty) {
                    return;
                  }
                  int input = int.parse(textController.text);
                  if (input <= 0) {
                    textController.text = "1";
                  } else if (input >= 5) {
                    textController.text = "5";
                  } else {
                    numberOfAvailableSeats = input;
                    _registerIntoDatabase(status: "online");
                    Navigator.of(context).pop();

                    if (startingPoint != null &&
                        destinationPoint != null &&
                        startingPoint != destinationPoint) {
                      RoadInfo roadInfo = await MyMap.controller.drawRoad(
                        startingPoint!,
                        destinationPoint!,
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
                child: const Text('Ok'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
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
          MyMap.osmMap(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                autocompleteTextField("Starting Location"),
                const SizedBox(height: 10),
                autocompleteTextField("Destination Location"),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: addMarkerAction,
            heroTag: null,
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: (() => MyMap.controller.zoomIn()),
            heroTag: null,
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: (() => MyMap.controller.zoomOut()),
            heroTag: null,
            child: const Icon(Icons.zoom_out),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: askAvailableSpace,
            heroTag: null,
            child: const Icon(Icons.directions),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () async {
              await MyMap.controller.currentLocation();
              MyMap.controller.zoomIn();
            },
            heroTag: null,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }

  void addMarkerAction() {
    if (startingPoint != null && destinationPoint != null) {
      if (passengersJoined < numberOfAvailableSeats) {
        MyMap.controller.addMarker(joiners[passengersJoined]);
        MyMap.controller.setMarkerIcon(
            joiners[passengersJoined],
            const MarkerIcon(
              icon: Icon(
                Icons.man,
                size: 100,
                color: Colors.black,
              ),
            ));
        joined.add(joiners[passengersJoined]);
        passengersJoined++;

        MyMap.controller.zoomToBoundingBox(
            BoundingBox.fromGeoPoints(
                [startingPoint!, destinationPoint!, ...joined]),
            paddinInPixel: 400);
      }
    }
  }

  Autocomplete<String> autocompleteTextField(String hintText) {
    return Autocomplete(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.isEmpty) {
          if (hintText == "Starting Location") {
            return ["Your Location"];
          } else {
            return const Iterable<String>.empty();
          }
        } else {
          List<String> sug = await fetchSuggestions(textEditingValue.text);

          return sug.where((word) =>
              word.toLowerCase().contains(textEditingValue.text.toLowerCase()));
        }
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          onSubmitted: (value) {},
          controller: textEditingController,
          focusNode: focusNode,
          onEditingComplete: onFieldSubmitted,
          decoration: InputDecoration(
              prefixIcon: hintText == "Starting Location"
                  ? const Icon(Icons.place)
                  : const Icon(Icons.local_taxi),
              suffix: IconButton(
                  onPressed: () async {
                    GeoPoint current =
                        await getPointFromAddress(textEditingController.text);
                    MyMap.controller.removeMarker(current);

                    hintText == "Starting Location"
                        ? startingPoint = current
                        : destinationPoint = current;
                    _registerIntoDatabase();
                    MyMap.controller.removeMarker(current);
                    MyMap.controller.changeLocation(current);
                    MyMap.controller.setMarkerIcon(
                      current,
                      MarkerIcon(
                        icon: Icon(Icons.place,
                            color: hintText == "Starting Location"
                                ? Colors.red[900]
                                : Colors.blue[900],
                            size: 100),
                      ),
                    );
                  },
                  icon: const Icon(Icons.done)),
              filled: true,
              constraints: const BoxConstraints(maxHeight: 60),
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide.none),
              hintText: hintText),
        );
      },
    );
  }
}
