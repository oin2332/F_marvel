import 'package:flutter/material.dart';
import 'package:food_marvel/user/bdayRegisterDetail.dart';

class BdayRegister extends StatelessWidget {
  const BdayRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('생일/기념일 등록하기')),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => BdayRegisterDetail()));
          }, icon: Icon(Icons.add_circle)),
          Text('기념일 추가하기')
        ],
      ),
    );
  }
}
