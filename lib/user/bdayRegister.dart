import 'package:flutter/material.dart';
import 'package:food_marvel/user/bdayRegisterDetail.dart';
import 'package:food_marvel/user/userModel.dart';
import 'package:provider/provider.dart';

import 'function/Day.dart';

class BdayRegister extends StatelessWidget {
  const BdayRegister({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    String? userId = userModel.userId;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('생일/기념일 등록하기', style: TextStyle(color: Colors.black)), elevation: 0),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            buildBdayList(userId!),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => BdayRegisterDetail()));
                },
                child: Container(
                  // 할까 말까?
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.grey), // 보더 색상 지정
                  //   borderRadius: BorderRadius.circular(8.0), // 보더의 둥근 정도 지정
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.add_circle, color: Colors.deepOrange[400]!,)),
                      Text('기념일 추가하기')
                    ],
                  ),
                ),
              ),
            ),
            // 이부분에 기념일 리스트 출력

          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200]!,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_outlined, color: Colors.deepOrange[400]!, size: 14),
                        SizedBox(width: 10),
                        Text('기념일은 나만 볼 수 있어요', style: TextStyle(fontSize: 15, color: Colors.deepOrange, fontWeight: FontWeight.bold))
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 6),
                        SizedBox(width: 15),
                        Text('등록한 기념일은 마이페이지에서 나만 볼 수 있어요.', style: TextStyle())
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 6),
                        SizedBox(width: 15),
                        Text('등록한 기념일이 다가오면 푸드마블에서 알려드려요.', style: TextStyle())
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
