import 'package:flutter/material.dart';

class NameEdit extends StatelessWidget {
  const NameEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('이름변경')),
      body: Container(
        margin: EdgeInsets.all(20.0), // 여백 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('레스토랑 예약에 필요한 정보이므로 반드시 실명을 입력해 주세요.', style: TextStyle(fontSize: 12,),),
            SizedBox(height: 20.0),
            TextField(style: TextStyle(fontSize: 18.0), decoration: InputDecoration(border: OutlineInputBorder())),
            SizedBox(height: 20.0),
            ElevatedButton(
                onPressed: (){},
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(16.0)), // 패딩 추가
                  textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 18.0)), // 버튼 안 텍스트 스타일
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[300]!), // 버튼 색상 변경
                ),
                child: Text('변경'))
          ],
        ),
      ),
    );
  }
}