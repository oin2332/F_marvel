import 'package:flutter/material.dart';

class ImportEmptySearch extends StatelessWidget {
  final String searchQuery;

  ImportEmptySearch({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              "'$searchQuery' 에(의) 대한 \n검색 결과가 없습니다.",
              style: TextStyle(
                fontSize: 20, // 폰트 크기 조정
                fontWeight: FontWeight.bold,
              ),

            ),
          ),
          SizedBox(height: 50,),
        ],
      ),
    );
  }
}