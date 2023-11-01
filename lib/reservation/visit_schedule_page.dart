// 방문완료

import 'package:flutter/material.dart';

class Visit_schedule_page extends StatefulWidget {
  const Visit_schedule_page({super.key});

  @override
  State<Visit_schedule_page> createState() => _Visit_schedule_pageState();
}

class _Visit_schedule_pageState extends State<Visit_schedule_page> {

  List<Map<String, dynamic>> myMap = [ //이건 db 연결전 더미데이터
    {
      '사진' : '44.jfif',
      '가게Id': '',
      '유저Id': 'test',
      '이름' : '가게제목1',
      '날짜' : '10/17 (화)',
      '주소' : '주소 ',
      '시간' : '12:00  ',
      '취소' : 'n'
    },
    {
      '사진' : '44.jfif',
      '가게Id': '',
      '유저Id': 'test2',
      '이름' : '가게제목2',
      '날짜' : '11/17 (수)',
      '주소' : '주소 ',
      '시간' : '13:00  ',
      '취소' : 'n'
    },

  ];

  @override
  Widget build(BuildContext context) {
    if (myMap.isNotEmpty) {
      return schedule();
    } else {
      return Container(
        height: 80,
        child: Center(
          child: Text(
            '히스토리가 없습니다',
            style: TextStyle(fontSize: 20,color: Colors.grey),
          ),
        ),
      );
    }

  }

  Widget schedule(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 590,
      child:
      ListView.builder(
        itemCount: myMap.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 20),
                Container(
                  width: 80,
                  height: 120, // 원하는 높이 설정
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Image.asset(
                    'assets/${myMap[index]['사진']}',
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(width: 13),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 250,
                              child: Text(
                                myMap[index]['이름'],
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 250,
                          child: Text(
                            myMap[index]['주소'],
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ),
                        Container(
                            width: 250,
                            height: 35,
                            child: Row(
                              children: [
                                Text(
                                  myMap[index]['날짜'],
                                  style: TextStyle(
                                    fontSize:20,
                                    color: Color(0xFFFF6347),
                                  ),
                                ),
                              ],
                            )

                        ),
                        Container(
                            width: 250,
                            height: 30,
                            child: Row(
                              children: [
                                Text(
                                  myMap[index]['시간'],
                                  style: TextStyle(
                                    fontSize:20,
                                    color: Color(0xFFFF6347),
                                  ),
                                ),


                              ],
                            )

                        )

                      ],
                    ),

                    SizedBox(height: 20),

                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
