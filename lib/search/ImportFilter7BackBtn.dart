import 'package:flutter/material.dart';

class FilterBackBtn extends StatelessWidget {
  final VoidCallback onSearchPressed;
  final VoidCallback onClosePressed;

  FilterBackBtn({
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
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
          child: Text(
            '이전',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
        OutlinedButton(
          onPressed: onClosePressed,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            side: BorderSide(color: Colors.blue),
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
          child: Text(
            '닫기',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}