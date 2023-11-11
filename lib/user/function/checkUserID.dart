
import 'package:flutter/material.dart';
import '../userUnlogin.dart'; // UserUnlogin 파일 import

void CheckUserID(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '로그인이 필요합니다',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 20),
            Divider(
              color: Colors.grey[300]!,
              thickness: 1,
              height: 1,
            ),
            SizedBox(height: 16),
            Text(
              '로그인이 필요한 기능입니다.',
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              '로그인을 하시겠습니까?.',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(175, 50)), // 너비 120, 높이 50
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                      return Colors.white; // 배경색을 흰색으로 설정
                    }),
                    side: MaterialStateProperty.all(
                      BorderSide(color: Colors.grey, width: 1), // 회색 보더 설정
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // 모달 닫기
                  },
                  child: Text(
                    '취소',
                    style: TextStyle(
                      color: Colors.black, // 검정 글자색
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(175, 50)), // 너비 120, 높이 50
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                      return Color(0xFFFF6347); // 배경색을 ff6347로 설정
                    }),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // 모달 창 닫기
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserUnlogin())); // UserUnlogin 페이지로 이동
                  },
                  child: Text('로그인하러가기'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}