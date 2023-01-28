import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MyMap {
  static late GeoPoint currentLocation;
  static MapController controller = MapController(
    initMapWithUserPosition: false,
    initPosition: GeoPoint(latitude: 9.005401, longitude: 38.763611),
    areaLimit: BoundingBox(
      east: 15.0,
      north: 47.738,
      south: 33.017,
      west: 3.233,
    ),
  );

  static OSMFlutter osmMap() {
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
}
