import 'package:flutter/material.dart';
import 'package:food_marvel/user/userModel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'function/Day.dart';

class BdayRegisterDetail extends StatefulWidget {
  const BdayRegisterDetail({super.key});

  @override
  State<BdayRegisterDetail> createState() => _BdayRegisterDetailState();
}

class _BdayRegisterDetailState extends State<BdayRegisterDetail> {

  String selectedType = '기념일 유형을 선택해 주세요'; // 기본값으로 '내 생일' 선택
  String selectedDate = ''; // 선택된 날짜 저장

  final TextEditingController _memo = TextEditingController();

  Future<void> _showDatePickerDialog() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      // 날짜 형식 변환
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);

      setState(() {
        selectedDate = formattedDate;
      });
    }
  }

  void _showTypeDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            RadioListTile<String>(
              title: Text('내 생일'),
              value: '내 생일',
              groupValue: selectedType,
              onChanged: (String? value) {
                setState(() {
                  selectedType = value!;
                  Navigator.pop(context);
                });
              },
            ),
            RadioListTile<String>(
              title: Text('결혼 기념일'),
              value: '결혼 기념일',
              groupValue: selectedType,
              onChanged: (String? value) {
                setState(() {
                  selectedType = value!;
                  Navigator.pop(context);
                });
              },
            ),
            RadioListTile<String>(
              title: Text('다른 사람 생일'),
              value: '다른 사람 생일',
              groupValue: selectedType,
              onChanged: (String? value) {
                setState(() {
                  selectedType = value!;
                  Navigator.pop(context);
                });
              },
            ),
            RadioListTile<String>(
              title: Text('기타'),
              value: '기타',
              groupValue: selectedType,
              onChanged: (String? value) {
                setState(() {
                  selectedType = value!;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    String? userId = userModel.userId;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('생일/기념일 등록하기', style: TextStyle(color: Colors.black)), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text('기념일 유형'),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepOrange[300]!)),
              onPressed: _showTypeDialog,
              child: Container(
                width: double.infinity, // 버튼의 너비를 화면 너비로 설정
                padding: EdgeInsets.symmetric(horizontal: 20.0), // 좌우 패딩을 추가
                child: Text(selectedType, textAlign: TextAlign.center),
              ),
            ),
            SizedBox(height: 20),
            Text('날짜'),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepOrange[300]!)),
              onPressed: _showDatePickerDialog,
              child: Container(
                width: double.infinity, // 버튼의 너비를 화면 너비로 설정
                padding: EdgeInsets.symmetric(horizontal: 20.0), // 좌우 패딩을 추가
                child: Text(selectedDate.isNotEmpty ? selectedDate : '날짜를 선택해주세요', style: TextStyle(), textAlign: TextAlign.center),
              ),
            ),
            SizedBox(height: 20),
            Text('메모'),
            TextField(
                controller: _memo,
                decoration: InputDecoration(labelText: '기념일에 대한 내용을 적어주세요')
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.deepOrange[400]!)),
              onPressed: () async {
                String type = selectedType;
                DateTime date = selectedDate.isNotEmpty ? DateTime.parse(selectedDate) : DateTime.now(); // 선택된 날짜가 없을 경우 현재 날짜 사용
                String memo = _memo.text; // 여기에서 메모 데이터를 얻어오는 코드를 추가

                // 데이터를 Firestore에 저장
                await setDay(userId!, type!, date!, memo!);

                // 화면 닫기
                Navigator.pop(context, {'type': type, 'date': date});
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('등록', textAlign: TextAlign.center,),
              ),
            )
          ],
        ),
      )
    );
  }
}
