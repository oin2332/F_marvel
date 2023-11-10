import 'package:flutter/material.dart';

class FilterFeel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.blue,
              ),
              SizedBox(width: 10.0),
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Text(
                  '분위기',
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