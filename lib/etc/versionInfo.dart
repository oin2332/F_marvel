import 'package:flutter/material.dart';

class VersionInfo extends StatelessWidget {
  const VersionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('버전 정보', style: TextStyle(color: Colors.black)), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text('엔진 정보'),
            SizedBox(width: 5),
            Text('V. 0. 0. 1', style: TextStyle(color: Colors.deepOrange)),
          ],
        ),
      ),
    );
  }
}
