import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:location/location.dart' as locat;

// final locat.Location location = new locat.Location();

Future<bool> checkPermission() async {
  bool serviceEnabled;
  LocationPermission permission;
  
  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    return false;
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {   
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return false;
  }

  return true;
}

Future<Position> getCurrentPosition() async {
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  return position;
}

Future<List<Placemark>> getPlaceFromCoordinates(currentPosition) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(currentPosition!.latitude, currentPosition!.longitude);
  return placemarks;
}

/* Future<bool> checkPermissionLocation() async {
  bool serviceEnabled;
  locat.PermissionStatus permission;
  
  serviceEnabled = await location.serviceEnabled();

  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();

    if (!serviceEnabled) {
      return false;
    }
  }

  permission = await location.hasPermission();

  if (permission == locat.PermissionStatus.denied) {
    permission = await location.requestPermission();

    if (permission != locat.PermissionStatus.granted) {   
      return false;
    }
  }

  return true;
}

Future<locat.LocationData> getCurrentPositionLocation() async {
  locat.LocationData position = await location.getLocation();
  return position;
} */
