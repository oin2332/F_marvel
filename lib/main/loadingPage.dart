import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../FCM/fcmex.dart';
import '../FCM/firebase_options.dart';
import '../reservation/function/Alarm.dart';
import '../shop/storePage.dart';
import '../user/userModel.dart';
import 'mainPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await initializeDateFormatting('ko_KR', null);
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


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

// void main() => runApp(MaterialApp(
//   title: 'Home',
//   home: LoadingPage(),
//   debugShowCheckedModeBanner: false,
// ));

class LoadingPage extends StatefulWidget {
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    // 3초 후에 MainPage로 이동
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.fade, // 페이지 전환 효과 설정
          child: MainPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/main/loading.png'), // loading.png 이미지를 중앙에 표시
      ),
    );
  }
}