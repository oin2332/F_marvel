import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  late LatLng _center = LatLng(37.4895, 126.7220);
  TextEditingController _addressController = TextEditingController();
  String _latitude = '';
  String _longitude = '';

  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _getGeolocationData() async {
    String address = _addressController.text;

    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        setState(() {
          _latitude = location.latitude.toString();
          _longitude = location.longitude.toString();

          // Clear previous markers
          _markers.clear();

          // Add marker for the searched address
          _markers.add(
            Marker(
              markerId: MarkerId('searched_location'),
              position: LatLng(location.latitude, location.longitude),
              infoWindow: InfoWindow(
                title: 'Searched Location',
                snippet: 'Lat: ${location.latitude}, Lng: ${location.longitude}',
              ),
            ),
          );

          // Move camera to the searched location
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(location.latitude, location.longitude),
                zoom: 15.0,
              ),
            ),
          );
        });
      } else {
        setState(() {
          _latitude = 'N/A';
          _longitude = 'N/A';
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps and Geolocation App'),
          backgroundColor: Colors.green[700],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Enter Address'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _getGeolocationData,
                    child: Text('Get Geolocation'),
                  ),
                  SizedBox(height: 20),
                  Text('Latitude: $_latitude'),
                  Text('Longitude: $_longitude'),
                ],
              ),
            ),
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: _center == null
                    ? const CameraPosition(
                  target: LatLng(37.4910133, 126.7206483),
                  zoom: 11.0,
                )
                    : CameraPosition(
                  target: _center,
                  zoom: 15.0,
                ),
                markers: _markers,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
