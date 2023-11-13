import 'package:flutter/material.dart';
import 'package:food_marvel/user/userModel.dart';
import 'package:provider/provider.dart';

import 'function/Edit.dart';

class NameEdit extends StatelessWidget {
  final TextEditingController _name = TextEditingController(); // 이름 컨트롤러

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    String? userId = userModel.userId;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {Navigator.pop(context);},
          ),
          title: Text('이름 변경', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white,elevation: 0),
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.all(20.0), // 여백 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('레스토랑 예약에 필요한 정보이므로 반드시 실명을 입력해 주세요.', style: TextStyle(fontSize: 12,),),
            SizedBox(height: 20.0),
            TextField(
              controller: _name,
                style: TextStyle(fontSize: 18.0),
                decoration: InputDecoration(border: OutlineInputBorder(), hintText: '이름을 입력해 주세요'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
                onPressed: (){
                  updateNameInFirestore(userId!, _name.text);
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(16.0)), // 패딩 추가
                  textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontSize: 18.0)), // 버튼 안 텍스트 스타일
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange[400]!), // 버튼 색상 변경
                ),
                child: Text('변경'))
          ],
        ),
      ),
    );
  }
}
