import 'package:flutter/material.dart';

class FilterFacility extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/main/sofa-removebg-preview.png',
                width: 30, // 이미지의 너비와 높이를 조정할 수 있습니다.
                height: 30,
              ),
              SizedBox(width: 3.0),
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Text(
                  '편의시설',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          Text(
            '미선택',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}