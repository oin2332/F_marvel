import 'package:flutter/material.dart';

class ConnectNumber extends StatefulWidget {
  const ConnectNumber({super.key});

  @override
  State<ConnectNumber> createState() => _ConnectNumberState();
}

class _ConnectNumberState extends State<ConnectNumber> {

  bool isPhoneEnabled = false; //연락처 연결 하기
  bool isMineShow = false; //내 계정 보여 주기

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('연락처 연결하기',style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('연락처 연결하기', style: TextStyle(fontSize: 17)),
                  Switch(
                    value: isPhoneEnabled,
                    onChanged: (value) {
                      setState(() {
                        isPhoneEnabled = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text('· 회원님의 연락처를 불러와서, 푸드마블을 사용 중인 친구를 찾아드립니다.', style: TextStyle(color: Colors.grey[600]!,fontSize: 12), textAlign: TextAlign.left),
              SizedBox(height: 20),
              Container(height: 1, width: 400, color: Colors.grey),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('내 계정 보여주기', style: TextStyle(fontSize: 17)),
                  Switch(
                    value: isMineShow,
                    onChanged: (value) {
                      setState(() {
                        isMineShow = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text('· 나의 전화번호를 등록한 사람이 내 계정을 찾을 수 있도록 합니다.', style: TextStyle(color: Colors.grey[600]!,fontSize: 13), textAlign: TextAlign.left),
            ],
          ),
        ),
      ),
    );
  }
}
