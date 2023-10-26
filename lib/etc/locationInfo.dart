import 'package:flutter/material.dart';

class LocationInfo extends StatelessWidget {
  const LocationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('위치정보 이용약관'),
        leading: IconButton(
          icon: Icon(Icons.close), // "X" 아이콘
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
