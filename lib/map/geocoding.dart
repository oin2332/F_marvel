import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocation App',
      home: GeolocationScreen(),
    );
  }
}

class GeolocationScreen extends StatefulWidget {
  @override
  _GeolocationScreenState createState() => _GeolocationScreenState();
}

class _GeolocationScreenState extends State<GeolocationScreen> {
  TextEditingController _addressController = TextEditingController();
  String _latitude = '';
  String _longitude = '';

  Future<void> _getGeolocationData() async {
    String address = _addressController.text;

    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        setState(() {
          _latitude = location.latitude.toString();
          _longitude = location.longitude.toString();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Geolocation App'),
      ),
      body: Padding(
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
    );
  }
}
