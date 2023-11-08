import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 필요한 패키지를 추가합니다.
import 'package:food_marvel/user/userMain.dart';
import 'package:food_marvel/user/userModel.dart';
import 'package:provider/provider.dart';
import 'join.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseFirestore _fs = FirebaseFirestore.instance; // Firestore 인스턴스를 가져옵니다.
  final TextEditingController _id = TextEditingController();
  final TextEditingController _pwd = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Image.asset('assets/main/loading.png'),
              SizedBox(height: 30),
              TextField(
                controller: _id,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100]!,
                  hintText: '아이디',
                  hintStyle: TextStyle(color: Colors.black38),
                  border: InputBorder.none, // 밑줄 없애기
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _pwd,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100]!,
                  hintText: '패스워드',
                  hintStyle: TextStyle(color: Colors.black38),
                  border: InputBorder.none, // 밑줄 없애기
                ),
              ),
              SizedBox(height: 80),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey[300]!; // 비활성화 상태일 때 배경색을 회색으로 지정
                      }
                      return Colors.deepOrange[400]!; // 활성화 상태일 때 배경색을 주황색으로 지정
                    },
                  ),
                ),
                onPressed: _login,
                child: Text('로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    String id = _id.text;
    String password = _pwd.text;

    final userDocs = await _fs.collection('T3_USER_TBL')
        .where('id', isEqualTo: id)
        .where('pwd', isEqualTo: password).get();

    if (userDocs.docs.isNotEmpty) {
      DocumentSnapshot userDoc = userDocs.docs.first;

      String nickname = userDoc['nickname']; // 파이어스토어에서 닉네임 가져오기
      Provider.of<UserModel>(context, listen: false).login(id, nickname); // UserModel에 저장
      //Provider.of<UserModel>(context,listen: false).login(id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('성공적으로 로그인되었습니다!')),
      );

      // 로그인 성공 시 usermain으로 이동
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserMain(userId: id,)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('아이디나 패스워드를 다시 확인해주세요.')),
      );
    }
  }
}