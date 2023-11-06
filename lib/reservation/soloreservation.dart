import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_marvel/user/userModel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';



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
    String? usernick = userModel.nickname;

    // Firebase에 예약 정보 저장
    await FirebaseFirestore.instance.collection('reser_test').add({
      'storeName': widget.storeInfo.name,
      'storeAddress': widget.storeInfo.address,
      'reservationYear': selectedDate.year,
      'reservationMonth': selectedDate.month,
      'reservationDay': selectedDate.day,
      'reservationHour': selectedHour,
      'reservationMinute': selectedMinute,
      'numberOfPeople': numberOfPeople,
      'Peopleid': userId,
      'Peoplenickname': usernick,
    });

    // 예약 완료 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('예약이 완료되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    String? UserId = userModel.userId;
    String? usernick = userModel.nickname;
    return Scaffold(
      appBar: AppBar(
        title: Text('예약하기'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text("예약자 $UserId "),
            // Text("유저 닉네임 $usernick" ),
            Text('예약 날짜: ${DateFormat('yyyy년 MM월 dd일').format(selectedDate.toLocal())}'),
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
              child: Text('날짜 선택'),
            ),
            Text('예약 시간: ${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CupertinoButton(
                  child: Icon(Icons.remove),
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
                  child: Icon(Icons.add),
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
                  child: Icon(Icons.remove),
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
                ),
                CupertinoButton(
                  child: Icon(Icons.add),
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
              onPressed: () => _saveReservation(userModel),
              child: Text('예약 완료'),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreInfo {
  final String name;
  final String address;

  StoreInfo({required this.name, required this.address});
}
