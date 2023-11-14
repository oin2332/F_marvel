import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/FCM/message.dart';
import 'package:food_marvel/main/ImportEvent.dart';
import 'package:food_marvel/main/ImportIcons.dart';
import 'package:food_marvel/reservation/function/cancelReservation.dart';
import 'package:food_marvel/search/navSearch.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:food_marvel/reservation/RtabBar.dart';
import '../FCM/fcmex.dart';
import '../board/list.dart';
import '../board/timeLine.dart';
import '../firebase/firebase_options.dart';
import '../search/headSearch.dart';
import '../shop/storePage.dart';
import 'package:http/http.dart' as http;

import '../user/userMain.dart';
import '../user/userModel.dart';
import '../user/userSetting.dart';
import '../user/userUnlogin.dart';
import 'ImportWhere.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('ko_KR', null);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }


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
      themeMode: ThemeMode.system,
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // Handle the background message
  print('Handling a background message ${message.messageId}');
}

class _MainPageState extends State<MainPage> {
  String? initialMessage;
  bool _resolved = false;
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then(
          (value) => setState(
            () {
          _resolved = true;
          initialMessage = value?.data.toString();
        },
      ),
    );

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(
        context,
        '/message',
        arguments: MessageArguments(message, true),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    String? uId = userModel.userId;

    void sendReservationNotification() async {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? fcmToken = await messaging.getToken();
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAH6_c1yw:APA91bEJTMrIJhVjJa4MBP76N_XncTlXQvXnOQB4aBv_9nrqEJP6dbJbiLZi-DQMGfg3PAXkXJwZHcxlJjW6PLLjaLGz34LBpXxYONkF9Xqlltb4FBqpW8P99ua-8opTVXUKeaQGZjPK',
        },
        body: jsonEncode({
          'notification': {
            'title': '예약 알림',
            'body': '예약이 성공적으로 완료되었습니다.',
          },
          'to': fcmToken,
        }),
      );
    }

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
              SizedBox(height: 5,),
              ImportEvent(),

              SizedBox(height: 10,),
              ImportIcons(),

              SizedBox(height: 20,),
              Container(height: 5, width: 400, color: Colors.grey[300]!),
              SizedBox(height: 20,),

              ImportWhere(),
              // Container(height: 5, width: 400, color: Colors.grey[300]!),
              // SizedBox(height: 20,),
              //
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     SizedBox(width: 15,),
              //     Text("타임라인 게시판",
              //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
              //   ],
              // ),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => Temp()));
              },  child: Icon(Icons.message_outlined, size: 28),),
              InkWell(onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResTabBar()));
              }, child: Icon(Icons.calendar_today_outlined, size: 28),),
              InkWell(onTap: () {
                if (userModel.isLogin) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserMain(userId: uId,)));
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