import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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

class Place {
  final String name;
  final String address;
  final Future<LatLng?> location; // 위치를 비동기로 받음

  Place({required this.name, required this.address})
      : location = getLocationFromAddress(address);
}

List<Place> places = [
  Place(name: '칸다소바', address: '인천 부평구 부평대로36번길 5'),
  Place(name: '인브스키친', address: '인천 부평구 부평대로 39-6'),
  Place(name: '에픽', address: '인천 부평구 경원대로1363번길 8'),
  // 다른 더미 데이터들도 동일한 방식으로 추가할 수 있음
];

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  late LatLng _center = LatLng(37.4895, 126.7220);

  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

  Future<void> _addMarkers() async {
    for (var place in places) {
      LatLng? location = await place.location;
      if (location != null) {
        _markers.add(
          Marker(
            markerId: MarkerId(place.name),
            position: location,
            infoWindow: InfoWindow(
              title: place.name,
              snippet: place.address,
            ),
          ),
        );
      }
    }
    setState(() {}); // 마커를 추가한 후 화면을 갱신하여 지도에 마커를 표시
  }

  Future<void> _getCurrentMyLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng myLocation = LatLng(position.latitude, position.longitude);

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: myLocation,
            zoom: 18.0,
          ),
        ),
      );

      // 추가: 사용자의 위치를 마커로 표시
      _markers.add(
        Marker(
          markerId: MarkerId('my_location'),
          position: myLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // 파란색 마커 아이콘 사용
          infoWindow: InfoWindow(
            title: 'My Location',
            snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
          ),
        ),
      );
      setState(() {}); // 위젯을 리빌드하여 마커를 지도에 표시
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
          onPressed: _getCurrentMyLocation,
          child: Icon(Icons.my_location),
          backgroundColor: Colors.blue[700],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
