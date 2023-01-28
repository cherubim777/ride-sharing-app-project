import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MyMap {
  GeoPoint? startingPoint;
  GeoPoint? destinationPoint;

  int passengersJoined = 0;

  late GeoPoint currentLocation;

  List<GeoPoint> joiners = [
    GeoPoint(latitude: 9.028622, longitude: 38.763225), // Friendship park
    GeoPoint(latitude: 9.036000, longitude: 38.763039), // Romina
    GeoPoint(latitude: 9.030251, longitude: 38.763458), // Abrehot Library
    GeoPoint(latitude: 9.038204, longitude: 38.763609), // Burte
    GeoPoint(latitude: 9.033495, longitude: 38.763833), // NBH complex
  ];

  List<GeoPoint> joined = [];

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

  OSMFlutter showMap() {
    return OSMFlutter(
      controller: controller,
      showZoomController: true,
      onLocationChanged: (p0) {
        currentLocation = p0;
      },
      onGeoPointClicked: (p0) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
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
    );
  }

  void addMarkerAction(int numberOfAvailableSeats) {
    if (startingPoint != null && destinationPoint != null) {
      if (passengersJoined < numberOfAvailableSeats) {
        controller.addMarker(joiners[passengersJoined]);
        controller.setMarkerIcon(
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

        controller.zoomToBoundingBox(
            BoundingBox.fromGeoPoints(
                [startingPoint!, destinationPoint!, ...joined]),
            paddinInPixel: 400);
      }
    }
  }

  void goToMyLocation() async {
    await controller.currentLocation();
    controller.setZoom(zoomLevel: 15);
  }
}
