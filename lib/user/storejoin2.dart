import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../board/boardAdd.dart';
import '../firebase/firebase_options.dart';
import 'loginPage.dart';

class StoreJoin2 extends StatefulWidget {
  final String storeDocumentId;
  StoreJoin2(String documentId, {super.key, required this.storeDocumentId});

  @override
  State<StoreJoin2> createState() => _JoinState();
}

class _JoinState extends State<StoreJoin2> {


  final TextEditingController _FLOOR = TextEditingController();
  final TextEditingController S_MENU1 = TextEditingController();
  final TextEditingController S_MENU1_1 = TextEditingController();
  final TextEditingController S_MENU2 = TextEditingController();
  final TextEditingController S_MENU2_1 = TextEditingController();
  final TextEditingController S_MENU3 = TextEditingController();
  final TextEditingController S_MENU3_1 = TextEditingController();
  final TextEditingController S_MENU4 = TextEditingController();
  final TextEditingController S_MENU4_1 = TextEditingController();



  String? gender;
  void _addcollection() async {
    if (S_MENU1.text.isNotEmpty && _FLOOR.text.isNotEmpty) {
      FirebaseFirestore fs = FirebaseFirestore.instance;
      DocumentReference storeDocument = fs.collection("T3_STORE_TBL").doc(widget.storeDocumentId);

      // 서브컬렉션 생성
      CollectionReference CONVENIENCE = storeDocument.collection("T3_CONVENIENCE_TBL");
      CollectionReference TIME = storeDocument.collection("T3_TIME_TBL");
      CollectionReference MENU = storeDocument.collection("T3_MENU_TBL");

      // 이제 CONVENIENCE, TIME, MENU 컬렉션에 데이터를 추가할 수 있습니다.
      await CONVENIENCE.add({
        'S_ELEVA': S_ELEVA,
        'S_FLOOR': _S_FLOOR,
        'S_GROUP': _S_GROUP,
        'S_KID': _S_KID,
        'S_NOKID': _S_NOKID,
        'S_PARKING': _S_PARKING,
        'S_STAIRS': _S_STAIRS,
        'S_TOILET': _S_TOILET,
        'S_WR': _S_WR,
        'S_FLOORtext': _FLOOR,
      });

      await TIME.add({
        'S_RE_TIME1' : _Time1,
        'S_RE_TIME2' : _Time2,
        'S_RE_TIME3' : _Time3,
        'S_RE_TIME4' : _Time4,
        'S_RE_TIME5' : _Time5,
        'S_RE_TIME6' : _Time6,
        'S_RE_TIME7' : _Time7,
        'S_RE_TIME8' : _Time8,
        'S_RE_TIME9' : _Time9,
        'S_RE_TIME10' : _Time10,
        'S_RE_TIME11' : _Time11,
        'S_RE_TIME12' : _Time12,
        'S_RE_TIME13' : _Time13,
        'S_RE_TIME14' : _Time14,
        'S_RE_TIME15' : _Time15,

      });
      await MENU.add({
        'S_MENU1' : S_MENU1,
        'S_MENU1-1' : S_MENU1_1,
        'S_MENU2' : S_MENU2,
        'S_MENU2-1' : S_MENU2_1,
        'S_MENU3' : S_MENU3,
        'S_MENU3-1' : S_MENU3_1,
        'S_MENU4' : S_MENU4,
        'S_MENU4-1' : S_MENU4_1,

      });
    } else {
      print("제목 또는 내용을 입력해주세요.");
    }
  }


  Widget _textfield(Controller, String txt) {
    return Container(
      width: 200, // 원하는 너비 설정
      child: TextField(
        controller: Controller,
        decoration: InputDecoration(
          labelText: txt,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  //아이콘 편의기능
  bool S_ELEVA = false;
  String? _S_ELEVA;
  bool S_FLOOR = false;
  String? _S_FLOOR = '';
  bool S_GROUP = false;
  String? _S_GROUP;
  bool S_KID = false;
  String? _S_KID;
  bool S_NOKID = false;
  String? _S_NOKID;
  bool S_PARKING = false;
  String? _S_PARKING;
  bool S_STAIRS = false;
  String? _S_STAIRS;
  bool S_TOILET = false;
  String? _S_TOILET;
  bool S_WR = false;
  String? _S_WR;
  //시간선택
  bool Time1 = false;
  String? _Time1 = '11:00';
  bool Time2 = false;
  String? _Time2 = '12:00';
  bool Time3 = false;
  String? _Time3 = '13:00';
  bool Time4 = false;
  String? _Time4 = '14:00';
  bool Time5 = false;
  String? _Time5 = '15:00';
  bool Time6 = false;
  String? _Time6 = '16:00';
  bool Time7 = false;
  String? _Time7 = '17:00';
  bool Time8 = false;
  String? _Time8 = '18:00';
  bool Time9 = false;
  String? _Time9 = '19:00';
  bool Time10 = false;
  String? _Time10 = '20:00';
  bool Time11 = false;
  String? _Time11 = '21:00';
  bool Time12 = false;
  String? _Time12 = '22:00';
  bool Time13 = false;
  String? _Time13 = '23:00';
  bool Time14 = false;
  String? _Time14 = '24:00';
  bool Time15 = false;
  String? _Time15 = '24시간';


  Widget _butlist(bool valch, String? valuetext, String valueiconText, String text, Function(bool, String?) onChanged) {
    return Row(
      children: [
        Checkbox(
          value: valch,
          onChanged: (value) {
            onChanged(value!, valueiconText); // onChanged 콜백 호출
          },
          activeColor: Colors.deepOrange[300]!,
        ),
        TextButton(
          onPressed: (){},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text, style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ),
        Icon(Icons.keyboard_arrow_right, color: Colors.black)
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white,elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('가게 데이터 넣기',style: TextStyle(color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Column(
              children: [
                Text('편의기능체크'),
                  _butlist(S_ELEVA, _S_ELEVA, 'elevator.png', '엘리베이터', (value, iconText) {
                  setState(() {
                  S_ELEVA = value;
                  _S_ELEVA = value ? iconText : null;
                  });
                  }),
                _butlist(S_GROUP, _S_GROUP, 'group.png', '단체가능/불가', (value, iconText) {
                  setState(() {
                    S_GROUP = value;
                    _S_GROUP = value ? iconText : null;
                  });
                }),
                _butlist(S_KID, _S_KID, 'kid.png', '키즈존', (value, iconText) {
                  setState(() {
                    S_KID = value;
                    _S_KID = value ? iconText : null;
                  });
                }),
                _butlist(S_NOKID, _S_NOKID, 'nokid.png', 'no키즈존', (value, iconText) {
                  setState(() {
                    S_NOKID = value;
                    _S_NOKID = value ? iconText : null;
                  });
                }),
                _butlist(S_PARKING, _S_PARKING, 'parking.png', '주차장', (value, iconText) {
                  setState(() {
                    S_PARKING = value;
                    _S_PARKING = value ? iconText : null;
                  });
                }),
                _butlist(S_TOILET, _S_TOILET, 'toilet.png', '화장실유무', (value, iconText) {
                  setState(() {
                    S_TOILET = value;
                    _S_TOILET = value ? iconText : null;
                  });
                }),
                _butlist(S_WR, _S_WR, 'takeout.png', '포장', (value, iconText) {
                  setState(() {
                    S_WR = value;
                    _S_WR = value ? iconText : null;
                  });
                }),
                _butlist(S_FLOOR, _S_FLOOR, 'floor.png', '층수 체크후 아래 적어주세요', (value, iconText) {
                  setState(() {
                    S_FLOOR = value;
                    _S_FLOOR = value ? iconText : null;
                  });
                }),


                Text('층수', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: _FLOOR,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '가게층수 EX) 1층or 지하1층',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),

                //시간
                _butlist(Time1, _Time1, '11:00', '11시', (value, iconText) {
                  setState(() {
                    Time1 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time2, _Time1, '12:00', '12시', (value, iconText) {
                  setState(() {
                    Time2 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time3, _Time1, '13:00', '13시', (value, iconText) {
                  setState(() {
                    Time3 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time4, _Time1, '14:00', '14시', (value, iconText) {
                  setState(() {
                    Time4 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time5, _Time1, '15:00', '15시', (value, iconText) {
                  setState(() {
                    Time5 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time6, _Time1, '16:00', '16시', (value, iconText) {
                  setState(() {
                    Time6 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time7, _Time1, '17:00', '17시', (value, iconText) {
                  setState(() {
                    Time7 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time8, _Time1, '18:00', '18시', (value, iconText) {
                  setState(() {
                    Time8 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time9, _Time1, '19:00', '19시', (value, iconText) {
                  setState(() {
                    Time9 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time10, _Time1, '20:00', '20시', (value, iconText) {
                  setState(() {
                    Time10 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time11, _Time1, '21:00', '21시', (value, iconText) {
                  setState(() {
                    Time11 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time12, _Time1, '22:00', '22시', (value, iconText) {
                  setState(() {
                    Time12 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time13, _Time1, '23:00', '23시', (value, iconText) {
                  setState(() {
                    Time13 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time14, _Time1, '24:00', '24시', (value, iconText) {
                  setState(() {
                    Time14 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time15, _Time1, '24시간', '24시간', (value, iconText) {
                  setState(() {
                    Time15 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),


              ],
            ),
            Column(
              children: [
                SizedBox(height: 5),
                Text('메뉴', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: S_MENU1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '메뉴이름',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 5),
                Text('가격', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: S_MENU1_1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '5만원 or 30,000 ~ 500,000원 ',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),

                SizedBox(height: 5),
                Text('메뉴', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: S_MENU2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '메뉴이름',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 5),
                Text('가격', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: S_MENU2_1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '5만원 or 30,000 ~ 500,000원 ',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),

                SizedBox(height: 5),
                Text('메뉴', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: S_MENU3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '메뉴이름',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 5),
                Text('가격', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: S_MENU3_1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '5만원 or 30,000 ~ 500,000원 ',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),

                SizedBox(height: 5),
                Text('메뉴', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: S_MENU4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '메뉴이름',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 5),
                Text('가격', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: S_MENU4_1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '5만원 or 30,000 ~ 500,000원 ',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),


              ],
            ),






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
              onPressed: (){_addcollection();},
              child: Text('다음'),
            )
          ],
        ),
      ),
    );
  }
}