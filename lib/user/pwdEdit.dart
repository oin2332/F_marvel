import 'package:flutter/material.dart';
import 'package:food_marvel/user/userModel.dart';
import 'package:provider/provider.dart';

import 'function/Edit.dart';

class PwdEdit extends StatelessWidget {
  final TextEditingController _pwd1 = TextEditingController(); // 이름 컨트롤러
  final TextEditingController _pwd2 = TextEditingController(); // 이름 컨트롤러
  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    String? userId = userModel.userId;

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {Navigator.pop(context);},
          ),
          title: Text('비밀번호 설정', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white,elevation: 0),
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.all(20.0), // 여백 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('카카오, 네이버, 애플 계정을 사용해 가입하셨더라도, 앱 비밀번호를 설정하여 전화번호 + 비밀번호 조합으로 푸드마블을 사용하실 수 있습니다.',
              style: TextStyle(fontSize: 12,),),
            SizedBox(height: 20.0),
            TextField(
              controller: _pwd1,
                obscureText: true,
                style: TextStyle(fontSize: 13.0),
                decoration: InputDecoration(border: OutlineInputBorder(),
                    hintText: '비밀번호를 입력해 주세요')
            ),
            SizedBox(height: 8.0),
            Text('영문,숫자 중 2종류 이상을 조합하여 8-20자리로 설정해 주세요.', style: TextStyle(fontSize: 11)),
            SizedBox(height: 8.0),
            TextField(
                controller: _pwd2,
                obscureText: true,
                style: TextStyle(fontSize: 13.0),
                decoration: InputDecoration(border: OutlineInputBorder(),
                    hintText: '비밀번호를 다시 입력해 주세요')
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                  if (_pwd1.text == _pwd2.text) {
                    updatePwdInFirestore(userId!, _pwd1.text);
                    Navigator.pop(context);
                  }
                }
                    : null,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.all(16.0)), // 패딩 추가
                  textStyle: MaterialStateProperty.all<TextStyle>(
                      TextStyle(fontSize: 18.0)), // 버튼 안 텍스트 스타일
                  backgroundColor: MaterialStateProperty.all<Color>(
                      isButtonEnabled
                          ? Colors.deepOrange[400]!
                          : Colors.grey[300]!),
                ),
                child: Text('변경'))
          ],
        ),
      ),
    );
  }
}
