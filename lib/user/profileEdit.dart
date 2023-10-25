import 'package:flutter/material.dart';

class ProfileEdit extends StatelessWidget {
  const ProfileEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('프로필 수정')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.portrait_rounded, size: 80,)),
            SizedBox(height: 50,),
            Align(
              alignment: Alignment.topLeft,
              child: Text('닉네임'),
            ),
            Container(
              width: 350, //TextField 너비 설정
              height: 50, //TextField 높이 설정
              child: TextField(decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red, // 테두리 색상 설정
                    width: 2.0, // 테두리 두께 설정
                  ),
                ),
              )),
            ),
            SizedBox(height: 20),
            Text('자기소개'),
            Container(
              width: 350, //TextField 너비 설정
              height: 100, //TextField 높이 설정
              child: TextField(decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 50),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red, // 테두리 색상 설정
                    width: 2.0, // 테두리 두께 설정
                  ),
                ),
              )),
            ),
            SizedBox(height: 20),
            Text('활동지역'),
            Container(
              width: 350, //TextField 너비 설정
              height: 50, //TextField 높이 설정
              child: TextField(decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red, // 테두리 색상 설정
                    width: 2.0, // 테두리 두께 설정
                  ),
                ),
              )),
            ),
            SizedBox(height: 20),

            Container(height: 1, width: 400, color: Colors.grey[300]!),
            Container(
              height: 300,
              child: ListView(
                children: [
                  TextButton(
                      onPressed: (){},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('SNS 설정하기', style: TextStyle(color: Colors.grey[500]!)),
                          Icon(Icons.keyboard_arrow_right_outlined, color: Colors.grey[500]!)
                        ],
                      )
                  ),
                  TextButton(
                      onPressed: (){},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('내 취향 선택하기', style: TextStyle(color: Colors.grey[500]!)),
                          Icon(Icons.keyboard_arrow_right_outlined, color: Colors.grey[500]!)
                        ],
                      )
                  ),
                  TextButton(
                      onPressed: (){},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('생일기념일 등록하기', style: TextStyle(color: Colors.grey[500]!)),
                          Icon(Icons.keyboard_arrow_right_outlined, color: Colors.grey[500]!)
                        ],
                      )
                  )
                ],
              ),
            )
          ],
        ),
      ),
      );
  }
}
