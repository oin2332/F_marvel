import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_marvel/shop/widthScroll.dart';
import 'package:food_marvel/user/userModel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../user/function/checkUserID.dart';
import '../user/userUnlogin.dart';


class ReservationPage extends StatefulWidget {
  final StoreInfo storeInfo;

  ReservationPage({required this.storeInfo});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {

  late DateTime selectedDate;
  late int selectedHour;
  late int selectedMinute;
  int numberOfPeople = 1;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedHour = 10; // 초기 시간 설정
    selectedMinute = 0; // 초기 분 설정
  }

  Future<void> _saveReservation(UserModel userModel) async {
    String? userId = userModel.userId;
    String? userName = userModel.name;

    String formattedDate = DateFormat('yyyy-MM-dd', 'ko_KR').format(selectedDate.toLocal());
    String formattedTime = DateFormat('HH:mm').format(DateTime(2000, 1, 1, selectedHour, selectedMinute));

    // print(formattedDate);
    // print(formattedTime);
    // Firebase에 예약 정보 저장
    await FirebaseFirestore.instance.collection('T3_STORE_RESERVATION').add({
      'R_S_ID': widget.storeInfo.name, // 가게이름
      'R_S_ADDR': widget.storeInfo.address, // 가게주소
      'R_DATE': formattedDate, // 예약일
      'R_TIME': formattedTime, // 시간
      'R_number': numberOfPeople, // 예약인원
      'R_id': userId, // 유저 아이디
      'R_name': userName, // 유저 닉네임
      'R_state': null,
    });
    // 알림을 Firestore "alarm_test" 컬렉션에 추가합니다.
    await FirebaseFirestore.instance.collection('alarm_test').add({
      'message': '예약이 완료되었습니다.',
      'timestamp': FieldValue.serverTimestamp(),
      'R_id': userId, // 유저 아이디
      'R_S_ID': widget.storeInfo.name, // 가게이름
      'R_DATE': formattedDate, // 예약일
      // 다른 필요한 정보들을 추가하세요.
    });


    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? fcmToken = await messaging.getToken();
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAH6_c1yw:APA91bEJTMrIJhVjJa4MBP76N_XncTlXQvXnOQB4aBv_9nrqEJP6dbJbiLZi-DQMGfg3PAXkXJwZHcxlJjW6PLLjaLGz34LBpXxYONkF9Xqlltb4FBqpW8P99ua-8opTVXUKeaQGZjPK', // FCM 서버 키를 넣어주세요
      },
      body: jsonEncode({
        'notification': {
          'title': '푸드마블 ',
          'body': '예약이 성공적으로 완료되었습니다.',
        },
        'to': fcmToken,
      }),
    );

    // 예약 완료 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('예약이 완료되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {

    UserModel userModel = Provider.of<UserModel>(context);
    // String? UserId = userModel.userId;
    // String? UserName = userModel.name;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xFFFF6347),
        title: Text('예약하기'),
      ),
      body: Column(
          children: <Widget>[
            SizedBox(height: 5,),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Color(0xFFFCECD8),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 15),
                            Text('푸드마블 정식 오픈!', style: TextStyle(color: Colors.black, fontSize: 20),),
                            Image.asset('assets/main/쿼카-removebg-preview1.png', width: 65, height: 65,),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('전국', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold,),),
                            SizedBox(width: 10),
                            Text('웨이팅을 실시간으로 !', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20,),),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
            ),
            SizedBox(height: 15,),
            Card(
              elevation: 1, // 카드 그림자 높이
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // 카드 테두리 모양
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          imageUrl: widget.storeInfo.image, // 이미지 URL
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.storeInfo.name}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.storeInfo.submemo}',maxLines: 5, // 표시할 최대 라인 수
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${widget.storeInfo.address}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          // Text('${widget.storeInfo.time}',
                          //     style: TextStyle(fontSize: 11, color: Colors.grey,),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


            SizedBox(height: 20),
            // Text("예약자 $UserId "),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365 * 2)),
                    ).then((pickedDate) {
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    });
                  },
                  child: Text('날짜 선택',style: TextStyle(color: Colors.white),),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFFF6347),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),),
                // Text("유저 닉네임 $usernick" ),
                SizedBox(width: 5,),
                Column(
                  children: [
                    SizedBox(height: 5,),
                    Text('예약 날짜: ${DateFormat('yyyy-MM-dd (E)' ,'ko_KR').format(selectedDate.toLocal())}'),
                    SizedBox(height: 5,),
                    Text('예약 시간: ${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}'),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CupertinoButton(
                  child: Icon(Icons.remove, color: Color(0xFFFF6347)),
                  onPressed: () {
                    setState(() {
                      if (selectedHour > 10) {
                        selectedHour--;
                        if (selectedMinute >= 30) {
                          selectedMinute = 0;
                        } else {
                          selectedMinute = 30;
                        }
                      }
                    });
                  },
                ),
                CupertinoSlider(
                  value: (selectedHour - 10) * 2 + selectedMinute / 30,
                  min: 0,
                  max: 26,
                  divisions: 26,
                  onChanged: (value) {
                    setState(() {
                      int hour = 10 + (value ~/ 2);
                      int minute = (value.toInt() % 2) * 30;
                      selectedHour = hour;
                      selectedMinute = minute;
                    });
                  },
                ),
                CupertinoButton(
                  child: Icon(Icons.add, color: Color(0xFFFF6347)),
                  onPressed: () {
                    setState(() {
                      if (selectedHour < 23) {
                        selectedHour++;
                        if (selectedMinute >= 30) {
                          selectedMinute = 0;
                        } else {
                          selectedMinute = 30;
                        }
                      }
                    });
                  },
                ),
              ],
            ),
            Text('예약 인원: $numberOfPeople 명'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CupertinoButton(
                  child: Icon(Icons.remove, color: Color(0xFFFF6347)),
                  onPressed: () {
                    setState(() {
                      if (numberOfPeople > 1) {
                        numberOfPeople--;
                      }
                    });
                  },
                ),
                CupertinoSlider(
                  value: numberOfPeople.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (value) {
                    setState(() {
                      numberOfPeople = value.round();
                    });
                  },
                  activeColor: Color(0xFFFF6347),
                ),
                CupertinoButton(
                  child: Icon(Icons.add, color: Color(0xFFFF6347)),
                  onPressed: () {
                    setState(() {
                      if (numberOfPeople < 10) {
                        numberOfPeople++;
                      }
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (userModel.isLogin) {
                  _saveReservation(userModel);
                } else {
                  CheckUserID(context);
                }
              },
              child: Text('예약 완료', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFF6347),
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 15,),
                Text("여기는 어떠신가요?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
              ],
            ),
            SizedBox(height: 1,),
            Expanded(child: WidthScroll("전국~")),
          ],
        ),
    );
  }
}

class StoreInfo {
  final String image;
  final String name;
  final String address;
  final String? submemo;
  final String? time;


  StoreInfo({
    required this.image,
    required this.name,
    required this.address,
    required this.submemo,
    required this.time,
  });
}
