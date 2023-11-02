import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../map/function/geocoding.dart'; // 위치 변환 함수가 정의된 파일을 import 합니다.

class GoogleMapPage extends StatefulWidget {
  final String initialAddress;

  GoogleMapPage({required this.initialAddress});

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addMarkerToInitialAddress();
  }

  Future<void> _addMarkerToInitialAddress() async {
    LatLng? initialPosition = await getLocationFromAddress(widget.initialAddress);
    if (initialPosition != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('initialMarker'),
            position: initialPosition,
            infoWindow: InfoWindow(
              title: '초기 위치',
              snippet: widget.initialAddress,
            ),
          ),
        );
      });

      if (_markers.isNotEmpty && mapController != null) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _markers.first.position,
              zoom: 16.0,
            ),
          ),
        );
      }
    } else {
      print('Failed to get coordinates for the initial address.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google 지도'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _markers.isNotEmpty
              ? _markers.first.position // 초기 위치를 마커 위치로 설정
              : LatLng(37.4895, 126.7220), // 기본 좌표
          zoom: 16.0,
        ),
        markers: _markers,
      ),
    );
  }
}