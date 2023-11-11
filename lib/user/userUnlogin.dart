import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_marvel/user/join.dart';
import 'package:food_marvel/user/loginPage.dart';
import 'package:food_marvel/shop/Addshop/storejoin.dart';
import 'package:food_marvel/user/userMain.dart';
import 'package:food_marvel/main/importbottomBar.dart';
import 'package:food_marvel/user/userModel.dart';
import 'package:provider/provider.dart';

import '../board/timeLine.dart';
import '../main/mainPage.dart';
import '../reservation/RtabBar.dart';
import '../search/navSearch.dart';

class UserUnlogin extends StatefulWidget {
  const UserUnlogin({super.key});

  @override
  State<UserUnlogin> createState() => _UserUnloginState();
}

class _UserUnloginState extends State<UserUnlogin> {


  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    String? uId = userModel.userId;
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 140, // 원하는 높이
                child: Image.asset('assets/main/loading.png'),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 50),
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
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), ),),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[100]!),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text('기존 계정으로 로그인 하기', style: TextStyle(color: Colors.black)),
                    )
                ),
                SizedBox(height: 20),
                TextButton(
                    onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => Join()));},
                    child: Text('회원 가입 ', style: TextStyle(decoration: TextDecoration.underline, color: Colors.black38,),

                    )
                ),
                TextButton(
                    onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => StoreJoin()));},
                    child: Text('가게 등록 ', style: TextStyle(decoration: TextDecoration.underline, color: Colors.black38,),

                    )
                )

              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50,
            color: Color.fromRGBO(255, 255, 255, 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                  },child: Icon(Icons.home_outlined,size: 30),),
                InkWell(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => NavSearch()));
                  },child: Icon(Icons.search_outlined, size: 30),),
                InkWell(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TimeLine()));
                },  child: Icon(Icons.message_outlined, size: 28),),
                InkWell(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResTabBar()));
                }, child: Icon(Icons.calendar_today_outlined, size: 28),),
                InkWell(onTap: () {
                  if (userModel.isLogin) {
                    Navigator.pop(context);
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserUnlogin()));
                  }
                }, child: Icon(Icons.person, size: 30),),
              ],
            ),
          ),
        ),

      ),
    );
  }
}
