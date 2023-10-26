import 'package:flutter/material.dart';
import 'package:food_marvel/user/easyLogin.dart';
import 'package:food_marvel/user/nameEdit.dart';
import 'package:food_marvel/user/phoneEdit.dart';
import 'package:food_marvel/user/pwdEdit.dart';

class UserInfoEdit extends StatefulWidget {
  const UserInfoEdit({super.key});

  @override
  State<UserInfoEdit> createState() => _UserInfoEditState();
}

class _UserInfoEditState extends State<UserInfoEdit> {
  List<String> genderOptions = ['남성', '여성', '선택안함'];

  void _selectGender(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: ListView.builder(
            itemCount: genderOptions.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(genderOptions[index]),
                onTap: () {
                  // 여기에 선택된 항목에 대한 처리를 추가하세요.
                  Navigator.pop(context); // Bottom sheet를 닫습니다.
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('내 정보 수정')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => NameEdit()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('이름(실명)을 입력해주세요', style: TextStyle(color: Colors.grey[600]!)),
                      Text('미설정', style: TextStyle(color: Colors.grey[400]!, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colors.black),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => PhoneEdit()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('휴대폰 번호', style: TextStyle(color: Colors.grey[600]!)),
                      Text('01000001111', style: TextStyle(color: Colors.grey[400]!, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colors.black),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => PwdEdit()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('비밀번호', style: TextStyle(color: Colors.grey[600]!)),
                      Text('미설정', style: TextStyle(color: Colors.grey[400]!, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colors.black),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => EasyLogin()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('간편로그인 설정', style: TextStyle(color: Colors.grey[600]!)),
                      Text('카카오', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colors.black),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(height: 1, width: 180, color: Colors.grey,margin: EdgeInsets.only(left: 8.0),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                _selectGender(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('성별', style: TextStyle(color: Colors.grey[600]!)),
                      Text('선택안함', style: TextStyle(color: Colors.grey[400]!, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colors.black),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(height: 6, width: 180, color: Colors.grey[400]!, margin: EdgeInsets.only(left: 2.0)
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('알림설정', style: TextStyle(color: Colors.grey[600]!))
                    ],
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colors.black),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(height: 6, width: 180, color: Colors.grey[400]!, margin: EdgeInsets.only(left: 2.0)
          ),
          SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: (){},
                    child: Text('로그아웃', style: TextStyle(color: Colors.grey[400]!))),
              )
          ),
          Container(height: 6, width: 180, color: Colors.grey[400]!, margin: EdgeInsets.only(left: 2.0)
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('회원탈퇴를 하시려면', style: TextStyle(color: Colors.grey[400]!)),
              TextButton(onPressed: (){}, child: Text('여기', style: TextStyle(color: Colors.grey[400]!, fontWeight: FontWeight.bold))),
              Text('를 눌러주세요', style: TextStyle(color: Colors.grey[400]!))
            ],
          )
        ],
      ),
    );
  }
}