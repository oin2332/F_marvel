import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/main/ImportEvent.dart';
import 'package:food_marvel/main/ImportIcons.dart';
import 'package:food_marvel/main/importbottomBar.dart';
import 'package:food_marvel/reservation/function/deleteReservation.dart';
import 'package:food_marvel/reservation/reservationEx.dart';
import 'package:food_marvel/map/maptotal.dart';
import 'package:food_marvel/search/navSearch.dart';
import 'package:food_marvel/shop/bestPage.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:food_marvel/reservation/RtabBar.dart';
import '../board/timeLine.dart';
import '../firebase/firebase_options.dart';
import '../search/headSearch.dart';
import '../shop/recommendPage.dart';
import '../shop/storePage.dart';

import '../user/userMain.dart';
import '../user/userModel.dart';
import '../user/userSetting.dart';
import '../user/userUnlogin.dart';
import '13_tapBar.dart';
import '20_Move.dart';
import '4_NameCard.dart';
import 'ImportWhere.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => ModalData()),
        ChangeNotifierProvider(create: (context) => ReservationDataProvider()),


      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      theme: ThemeData(fontFamily: 'GmarketSansTTFMedium'),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.white,
        leading: ClipOval(
          child: Container(
            width: 20,height: 20,
            child: Image.asset('assets/main/logo3.jpg', width: 10,height: 10,),
          ),
        ),
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.grey[200]!,
          ),
          child: SizedBox(
              height: 40,
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey[400]!,
                      ),
                    ),
                    Text(
                      "지역, 음식, 매장명 검색",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[400]!,
                      ),
                    ),
                  ],
                ),
              )
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications, color: Colors.grey),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserSetting()));
            },
            icon: Icon(Icons.brightness_5, color: Colors.grey),
          ),
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(height: 10,),
              ImportEvent(),

              SizedBox(height: 10,),
             ImportIcons(),

              SizedBox(height: 20,),
              Container(height: 5, width: 400, color: Colors.grey[300]!),
              SizedBox(height: 20,),

              ImportWhere(),
              Container(height: 5, width: 400, color: Colors.grey[300]!),
              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 15,),
                  Text("타임라인 게시판",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
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
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));},
                  child: Icon(Icons.home,size: 30),),
              InkWell(
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => NavSearch()));
                }, child: Icon(Icons.search_outlined, size: 30),),
              InkWell(onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TimeLine()));
              },  child: Icon(Icons.message_outlined, size: 28),),
              InkWell(onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResTabBar()));
              }, child: Icon(Icons.calendar_today_outlined, size: 28),),
              InkWell(onTap: () {
                if (userModel.isLogin) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserMain()));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserUnlogin()));
                }
              }, child: Icon(Icons.person_outline_outlined, size: 30),),
            ],
          ),
        ),
      ),
    );
  }
}