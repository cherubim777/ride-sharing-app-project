import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:ride_share/Map/map.dart';
import 'package:ride_share/data/data_access_object.dart';
import 'package:ride_share/data/dataModel.dart';

class CreatorPage extends StatefulWidget {
  const CreatorPage({super.key});

  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage> {
  DataAccessObject user = DataAccessObject();
  CreatorMap creatorMap = CreatorMap();

  int numberOfAvailableSeats = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    creatorMap.controller.dispose();
    // _registerIntoDatabase();
    super.dispose();
  }

  void _registerIntoDatabase() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // String current = user.uid.toString();
        final creatorLocation = Location(
          currentLocation: Coordinates(
            latitude: creatorMap.startingPoint?.latitude,
            longitude: creatorMap.startingPoint?.longitude,
          ),
          destinationLocation: Coordinates(
            latitude: creatorMap.destinationPoint?.latitude,
            longitude: creatorMap.destinationPoint?.longitude,
          ),
        );
        final ride = Ride(
          creator: user.uid,
          location: creatorLocation,
          seats: numberOfAvailableSeats,
        );
        // final rideGroup = RideMembers();
        this.user.updateUserData(creatorLocation.toJson());
        this.user.createRide(ride);
        this.user.createRideGroup();
      }
    });
  }

  Future<GeoPoint> getPointFromAddress(String address) async {
    if (address == "Your Location") {
      return await creatorMap.controller.myLocation();
    }
    List<SearchInfo> suggestionsInfo =
        await addressSuggestion(address, limitInformation: 2);
    return suggestionsInfo[0].point!;
  }

  Future askAvailableSpace() => showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController textController = TextEditingController();
          textController.text = '$numberOfAvailableSeats';
          FocusManager.instance.primaryFocus?.unfocus();

          if (creatorMap.startingPoint != null &&
              creatorMap.destinationPoint != null) {
            creatorMap.controller.zoomToBoundingBox(
                BoundingBox.fromGeoPoints(
                    [creatorMap.startingPoint!, creatorMap.destinationPoint!]),
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
                    _registerIntoDatabase();
                    Navigator.of(context).pop();

                    if (creatorMap.startingPoint != null &&
                        creatorMap.destinationPoint != null &&
                        creatorMap.startingPoint !=
                            creatorMap.destinationPoint) {
                      RoadInfo roadInfo = await creatorMap.controller.drawRoad(
                        creatorMap.startingPoint!,
                        creatorMap.destinationPoint!,
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
          creatorMap.showMap(),
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
            onPressed: (() =>
                creatorMap.addMarkerAction(numberOfAvailableSeats)),
            heroTag: null,
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: (() => creatorMap.controller.zoomIn()),
            heroTag: null,
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: (() => creatorMap.controller.zoomOut()),
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
            onPressed: creatorMap.goToMyLocation,
            heroTag: null,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }

  Autocomplete<String> autocompleteTextField(String hintText) {
    return Autocomplete(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.isEmpty) {
          // if (hintText == "Starting Location") {
          return ["Your Location"];
          // } else {
          //   return const Iterable<String>.empty();
          // }
        } else {
          List<String> sug =
              await creatorMap.fetchSuggestions(textEditingValue.text);

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
                    GeoPoint userInput =
                        await getPointFromAddress(textEditingController.text);
                    creatorMap.controller.removeMarker(userInput);

                    hintText == "Starting Location"
                        ? creatorMap.startingPoint = userInput
                        : creatorMap.destinationPoint = userInput;
                    _registerIntoDatabase();
                    creatorMap.controller.removeMarker(userInput);
                    creatorMap.controller.changeLocation(userInput);
                    creatorMap.controller.setMarkerIcon(
                      userInput,
                      MarkerIcon(
                        icon: Icon(
                          Icons.place,
                          color: hintText == "Starting Location"
                              ? Colors.red[900]
                              : Colors.blue[900],
                          size: 100,
                        ),
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
