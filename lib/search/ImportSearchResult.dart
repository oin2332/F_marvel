import 'package:flutter/material.dart';

class ImportSearchResult extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0,left: 10.0,bottom: 15.0),
                child: Text(
                  "검색결과",
                  style: TextStyle(
                    fontSize: 20, // 폰트 크기 조정
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}