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
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
            primary: Color(0xFFFF6347),
          ),
          child: Text(
            '적용',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        OutlinedButton(
          onPressed: onClosePressed,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: BorderSide(color: Colors.grey),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          ),
          child: Text(
            '닫기',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}