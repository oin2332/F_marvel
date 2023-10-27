import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
 const MyApp({Key? key}) : super(key: key);

 @override
 _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 late GoogleMapController mapController;
 late LatLng _center;

 @override
 void initState() {
  super.initState();
  _getCurrentLocation(); // Get current location when the app starts
 }

 void _onMapCreated(GoogleMapController controller) {
  mapController = controller;
 }

 Set<Marker> _markers = {};

 Future<void> _getCurrentLocation() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
   permission = await Geolocator.requestPermission();
   if (permission != LocationPermission.whileInUse &&
       permission != LocationPermission.always) {
    // Handle the case if the user denies the permission
    print('Location permission denied.');
    return;
   }
  }

  bool isGeolocationAvailable = await Geolocator.isLocationServiceEnabled();

  if (isGeolocationAvailable) {
   try {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
     _center = LatLng(position.latitude, position.longitude);
    });

    // Clear previous markers
    _markers.clear();

    // Add a marker for the current position
    _markers.add(
     Marker(
      markerId: MarkerId('current_location'),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(
       title: 'Current Location',
       snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
      ),
     ),
    );

    // Move the camera to the current position
    mapController.animateCamera(
     CameraUpdate.newCameraPosition(
      CameraPosition(
       target: LatLng(position.latitude, position.longitude),
       zoom: 15.0,
      ),
     ),
    );
   } catch (error) {
    // Handle error if necessary
    print('Error getting location: $error');
   }
  } else {
   // Handle case when location services are not available
   print('Location services are not enabled.');
  }
 }

 @override
 Widget build(BuildContext context) {
  return MaterialApp(
   home: Scaffold(
    appBar: AppBar(
     title: const Text('Maps Sample App'),
     backgroundColor: Colors.green[700],
    ),
    body: Column(
     children: <Widget>[
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
    floatingActionButton: FloatingActionButton(
     onPressed: _getCurrentLocation,
     child: Icon(Icons.my_location),
     backgroundColor: Colors.blue[700],
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
   ),
  );
 }
}