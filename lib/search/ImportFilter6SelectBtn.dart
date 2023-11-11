import 'package:flutter/material.dart';

class FilterSelectBtn extends StatelessWidget {
  final VoidCallback onSearchPressed;
  final VoidCallback onClosePressed;

  FilterSelectBtn({
    required this.onSearchPressed,
    required this.onClosePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onSearchPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // 20에서 25로 변경
            ),
            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10), // 15에서 20으로 변경
            primary: Color(0xFFFF6347), // 배경색을 주황색으로 변경
          ),
          child: Text(
            '적용',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16, // 폰트 사이즈를 18에서 22로 변경
              fontWeight: FontWeight.bold, // 텍스트를 볼드로 변경
            ),
          ),
        ),
        OutlinedButton(
          onPressed: onClosePressed,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // 20에서 25로 변경
            ),
            side: BorderSide(color: Colors.grey), // 테두리를 회색으로 변경
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10), // 15에서 20으로 변경
          ),
          child: Text(
            '닫기',
            style: TextStyle(
              color: Colors.black, // 텍스트 색상을 검정색으로 변경
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}