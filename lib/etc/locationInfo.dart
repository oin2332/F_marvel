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
      body: ListView(
        children: [
          Text('제 1 조 (목적)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text('본 약관은 주식회사 upc(이하 "회사"라 합니다)가 운영, 제공하는 위치기반서비스(이하 “서비스”)를 이용함에 있어 회사와 고객 및 개인위치정보주체의 권리, 의무 및 책임사항에 따른 이용조건 및 절차 등 기본적인 사항을 규정함을 목적으로 합니다.')
        ],
      ),
    );
  }
}
