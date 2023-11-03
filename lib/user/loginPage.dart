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
        title: Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Image.asset('assets/main/loading.png'),
            SizedBox(height: 30),
            TextField(
              controller: _id,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!,
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
                fillColor: Colors.grey[200]!,
                hintText: '패스워드',
                hintStyle: TextStyle(color: Colors.black38),
                border: InputBorder.none, // 밑줄 없애기
              ),
            ),
            SizedBox(height: 80),
            Column(
              children: [
                ElevatedButton(
                  onPressed: _login,
                  child: Text('로그인'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Join()));
                  },
                  child: Text('회원가입'),
                ),
              ],
            ),
          ],
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
      Provider.of<UserModel>(context,listen: false).login(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('성공적으로 로그인되었습니다!')),
      );
      // 로그인 성공 시 usermain으로 이동
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserMain()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('아이디나 패스워드를 다시 확인해주세요.')),
      );
    }
  }
}