import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class MapPosition { 
  const MapPosition(this.lat_1, this.lon_1, this.lat_2, this.lon_2, this.controllerGoogleMap);
  final double lat_1;
  final double lon_1;
  final double? lat_2;
  final double? lon_2;
  final Completer<GoogleMapController>? controllerGoogleMap;
}

class MapLocation extends StatelessWidget {
  final MapPosition item;
  final Set<Polyline> polylines;
  MapLocation({Key? key, required this.item, required this.polylines}) : super(key: key);
  List<LatLng> latLng = [];
  final Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    if (this.item.lat_2 != null && this.item.lon_2 != null) {
      latLng.add(LatLng(this.item.lat_2!, this.item.lon_2!));
      latLng.add(LatLng(this.item.lat_1, this.item.lon_1));

      markers.add(
        Marker(
          markerId: const MarkerId('marker (this.item.lat_2!, this.item.lon_2!)'),
          position: latLng[0],
        ),
      );
      markers.add(
        Marker(
          markerId: const MarkerId('marker (this.item.lat_1!, this.item.lon_1!)'),
          position: latLng[1],
        ),
      );
    } else {
      latLng.add(LatLng(this.item.lat_1, this.item.lon_1));

      markers.add(
        Marker(
          markerId: const MarkerId('marker (this.item.lat_1!, this.item.lon_1!)'),
          position: latLng[0],
        ),
      );
    }

    CameraPosition initialCameraPosition = CameraPosition(
      target: latLng[0],
      zoom: 14,
    );

    return GoogleMap(
      initialCameraPosition: initialCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        this.item.controllerGoogleMap!.complete(controller);
      },
      mapType: MapType.normal,
      compassEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      mapToolbarEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: true,
      markers: markers,
      polylines: polylines,
    ); 
  } 
}
