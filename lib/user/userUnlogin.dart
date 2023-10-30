import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_marvel/user/join.dart';
import 'package:food_marvel/user/userJoin.dart';
import 'package:food_marvel/user/userMain.dart';
import 'package:food_marvel/user/userSetting.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:path/path.dart';

import '../firebase/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '로그인',
      home: UserUnlogin(),
    );
  }
}

class UserUnlogin extends StatefulWidget {
  const UserUnlogin({super.key});

  @override
  State<UserUnlogin> createState() => _UserUnloginState();
}

class _UserUnloginState extends State<UserUnlogin> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('foodmarvel')),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 130),
              TextButton(
                onPressed: ()  {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero, // 패딩을 제거하여 이미지에 꽉 차게 합니다.
                ),
                child: Container(
                  width: 350, // 이미지의 너비에 맞게 조정
                  height: 50, // 이미지의 높이에 맞게 조정
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/kakao/kakao_join_wide.png'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1, // 선의 높이
                    width: 170, // 선의 너비
                    color: Colors.grey, // 선의 색상
                    margin: EdgeInsets.only(right: 8.0),
                  ),
                  Text('또는', style: TextStyle(color: Colors.grey),),
                  Container(
                    height: 1, // 선의 높이
                    width: 170, // 선의 너비
                    color: Colors.grey, // 선의 색상
                    margin: EdgeInsets.only(left: 8.0),
                  ),
                ],
              ),
              SizedBox(height: 80),
              Text('이미 가입하셨나요?'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: (){},
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), ),),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[200]!),
                ),
                child: Padding(
                   padding: const EdgeInsets.all(18.0),
                   child: Text('기존 계정으로 로그인 하기', style: TextStyle(color: Colors.black)),
                  )
                ),
              SizedBox(height: 20),
              TextButton(
                  onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => Join()));},
                  child: Text('회원 가입 ', style: TextStyle(decoration: TextDecoration.underline),)
              )
              ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.home)),
              IconButton(onPressed: (){}, icon: Icon(Icons.search)),
              IconButton(onPressed: (){}, icon: Icon(Icons.chat)),
              IconButton(onPressed: (){}, icon: Icon(Icons.calendar_today_outlined)),
              IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => UserMain()));}, icon: Icon(Icons.person))
            ],
          ),
        ),
      ),
    );
  }
}
