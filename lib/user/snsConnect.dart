import 'package:flutter/material.dart';

class SnsConnect extends StatefulWidget {
  const SnsConnect({super.key});

  @override
  State<SnsConnect> createState() => _SnsConnectState();
}

class _SnsConnectState extends State<SnsConnect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {Navigator.pop(context);},
          ),
          title: Text('SNS 계정 연동', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white,elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Text('인스타그램', style: TextStyle(color: Colors.black54, fontSize: 13)),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                labelText: '인스타그램 프로필 주소를 입력해주세요',
                labelStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                prefixIcon: Icon(Icons.search), // 텍스트 필드 왼쪽에 아이콘 추가
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 10),
            Text('트위터', style: TextStyle(color: Colors.black54, fontSize: 13)),
            TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200]!, // 배경색 설정
                  labelText: '트위터 프로필 주소를 입력해주세요',
                  labelStyle: TextStyle(color: Colors.black38),
                  prefixIcon: Icon(Icons.search), // 텍스트 필드 왼쪽에 아이콘 추가
                  border: InputBorder.none, // 밑줄 없애기
                ),
                style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 10),
            Text('유튜브', style: TextStyle(color: Colors.black54, fontSize: 13)),
            TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200]!, // 배경색 설정
                  labelText: '유튜브 프로필 주소를 입력해주세요',
                  labelStyle: TextStyle(color: Colors.black38),
                  prefixIcon: Icon(Icons.search), // 텍스트 필드 왼쪽에 아이콘 추가
                  border: InputBorder.none, // 밑줄 없애기
                ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 10),
            Text('블로그', style: TextStyle(color: Colors.black54, fontSize: 13)),
            TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200]!, // 배경색 설정
                    labelText: '블로그 프로필 주소를 입력해주세요',
                  labelStyle: TextStyle(color: Colors.black38),
                  prefixIcon: Icon(Icons.search), // 텍스트 필드 왼쪽에 아이콘 추가
                  border: InputBorder.none, // 밑줄 없애기
                ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 100),
            ElevatedButton(
                onPressed: (){},
                child: Text('저장')
            )
          ],
        ),
      ),
    );
  }
}
