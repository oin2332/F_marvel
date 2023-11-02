import 'package:flutter/material.dart';
import 'package:food_marvel/map/function/circleboundary.dart';
import 'package:food_marvel/map/function/geocoding.dart';
import 'package:food_marvel/map/function/getdbdata.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase/firebase_options.dart';

class Place {
  final String name;
  final String address;
  final Future<LatLng?> location;

  Place({required this.name, required this.address, required String category})
      : location = getLocationFromAddress(address);
}

class GooGleMap extends StatefulWidget {
  const GooGleMap({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<GooGleMap> {
  late GoogleMapController mapController;
  LatLng _center = LatLng(37.4895, 126.7220);
  double _zoomLevel = 14.0;
  LatLng? _selectedLocation;

  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  String _searchQuery = "";
  String _selectedCategory = '';

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentMyLocation();
    _addMarkers();
  }

  Future<void> _addMarkers() async {
    List<Place> places = await getData();
    for (Place place in places) {
      print(
          'Name: ${place.name}, Address: ${place.address}');
    }

    _circles.add(getCircleBoundary(_center, 600));

    if (_circles.isEmpty) {
      print('Circle is not available.');
      return;
    }

    LatLng circleCenter = _circles.first.center;
    double circleRadius = _circles.first.radius;

    for (var place in places) {
      LatLng? location = await place.location;
      if (location != null) {
        double distance = Geolocator.distanceBetween(
          circleCenter.latitude,
          circleCenter.longitude,
          location.latitude,
          location.longitude,
        );

        if (distance <= circleRadius) {
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
    }

    setState(() {});
  }

  void _filterPlaces(String query) {
    setState(() {
      _searchQuery = query;
      _addMarkers();
    });
  }

  Future<void> _getCurrentMyLocation() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        LatLng myLocation = LatLng(position.latitude, position.longitude);

        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: myLocation,
              zoom: 17.0,
            ),
          ),
        );

        _markers.add(
          Marker(
            markerId: MarkerId('my_location'),
            position: myLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(
              title: 'My Location',
              snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
            ),
          ),
        );

        Circle circleBoundary = getCircleBoundary(myLocation, 500);
        _circles.clear();
        _circles.add(circleBoundary);
        print(
            'Circle Center: ${circleBoundary.center}, Radius: ${circleBoundary.radius}');

        setState(() {});
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('User denied permissions to access the device\'s location.');
    }
  }

  void _showMarkersAroundSelectedLocation() async {
    if (_selectedLocation != null) {
      List<Place> places = await getData();
      _markers.clear();
      _circles.clear();

      _circles.add(getCircleBoundary(
          _selectedLocation!, 600));

      LatLng circleCenter = _selectedLocation!;
      double circleRadius = 600;

      for (var place in places) {
        LatLng? location = await place.location;
        if (location != null) {
          double distance = Geolocator.distanceBetween(
            circleCenter.latitude,
            circleCenter.longitude,
            location.latitude,
            location.longitude,
          );

          if (distance <= circleRadius) {
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
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: _zoomLevel,
            ),
            markers: _markers,
            circles: _circles,
          ),
          Positioned(
            top: 50.0,
            left: 0.0,
            right: 20.0,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        // Handle back button press
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: TextField(
                          onChanged: _filterPlaces,
                          decoration: InputDecoration(
                            hintText: '장소 검색...',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Row(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = '한식';
                            });
                          },
                          child: Text(
                            '한식',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.grey),
                            ),
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = '중식';
                            });
                          },
                          child: Text(
                            '중식',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.grey),
                            ),
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = '일식';
                            });
                          },
                          child: Text(
                            '일식',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.grey),
                            ),
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = '카페';
                            });
                          },
                          child: Text(
                            '카페',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.grey),
                            ),
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = '포장마차';
                            });
                          },
                          child: Text(
                            '포장마차',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.grey),
                            ),
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ),
                        SizedBox(width: 10.0),
                      ],
                    ),
                  ),
                ),
              ],
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
    );
  }
}
