import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
 const MyApp({Key? key}) : super(key: key);

 @override
 _MyAppState createState() => _MyAppState();
}

class Place {
 final String name;
 final String address;
 final LatLng location;

 Place({required this.name, required this.address, required this.location});
}

List<Place> places = [
 Place(name: '칸다소바', address: '인천 부평구 부평대로36번길 5', location: LatLng(37.4910133, 126.7206483)),
 Place(name: '인브스키친', address: '인천 부평구 부평대로 39-6', location: LatLng(37.490815, 126.720895)),
 Place(name: '에픽', address: '인천 부평구 경원대로1363번길 8', location: LatLng(37.490539, 126.718667)),
];

class _MyAppState extends State<MyApp> {
 late GoogleMapController mapController;
 late LatLng _center = LatLng(37.4895, 126.7220); // 인천 부평구의 중심 좌표

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
  // Clear previous markers
  _markers.clear();

  // TODO: 위치 서비스를 사용하여 정확한 현재 위치 가져오기
  Position position = await Geolocator.getCurrentPosition(
   desiredAccuracy: LocationAccuracy.high,
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

  // Add markers for the current position
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
  // Add markers for the dummy places


  // Add markers for the dummy places
  void _addDummyMarkers() {
   for (var place in places) {
    _markers.add(
     Marker(
      markerId: MarkerId(place.name),
      position: place.location,
      infoWindow: InfoWindow(
       title: place.name,
       snippet: place.address,
      ),
     ),
    );
   }
  }
  // Add markers for the dummy places
  _addDummyMarkers();

  setState(() {}); // Rebuild the widget after updating markers
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


