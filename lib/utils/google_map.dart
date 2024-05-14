import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:map_launcher/map_launcher.dart' as launcher;

import 'package:bonsplans/configs/constants.dart';

Future<void> goToTheCameraPosition(Completer<GoogleMapController> controllerGoogleMap, CameraPosition cameraPosition) async {
  final GoogleMapController controller = await controllerGoogleMap.future;
  await controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
}

Future<void> goToTheLatLngBounds(Completer<GoogleMapController> controllerGoogleMap, LatLngBounds latLngBounds) async {
  final GoogleMapController controller = await controllerGoogleMap.future;
  await controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100.0));
}

Future<PolylineResult> createPolylineResult(double lat_1, double lon_1, double? lat_2, double? lon_2) async {
  PolylinePoints polylinePoints = PolylinePoints();

  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    Constants.googleAPiKey, // Google Maps API Key
    PointLatLng(lat_1, lon_1),
    PointLatLng(lat_2!, lon_2!),
    travelMode: TravelMode.transit,
  );

  return result;
}

Future<void> launcherGoogleMapShowDirections(launcher.Coords coords, String title) async {
  var isMapAvailable = await launcher.MapLauncher.isMapAvailable(launcher.MapType.google);
  if (isMapAvailable != null) {
    await launcher.MapLauncher.showDirections(
      mapType: launcher.MapType.google,
      destination: coords,
      originTitle: title,
    );
  } else {
    print('Could not launch Google Map');
  }
}

Future<void> launcherGoogleMapShowMarker(launcher.Coords coords, String title) async {
  var isMapAvailable = await launcher.MapLauncher.isMapAvailable(launcher.MapType.google);
  if (isMapAvailable != null) {
    await launcher.MapLauncher.showMarker(
      mapType: launcher.MapType.google,
      coords: coords,
      title: title,
    );
  } else {
    print('Could not launch Google Map');
  }
}
