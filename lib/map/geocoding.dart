import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<LatLng?> getLocationFromAddress(String address) async {
  try {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      Location location = locations.first;
      return LatLng(location.latitude, location.longitude);
    }
    return null;
  } catch (e) {
    print('Error: $e');
    return null;
  }
}