import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:food_marvel/map/mini.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String initialAddress = "인천광역시 부평구 부평1동 부흥로 264 동아웰빙타운관리단 9층";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google 지도 앱'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // 위치 권한 요청
            var status = await Permission.location.request();
            if (status.isGranted) {
              // 권한이 허용되었을 때 동작
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GoogleMapPage(initialAddress: initialAddress),
                ),
              );
            } else {
              // 권한이 거부되었을 때 동작
              print('Permission denied');
            }
          },
          child: Text('지도 보기'),
        ),
      ),
    );
  }
}

