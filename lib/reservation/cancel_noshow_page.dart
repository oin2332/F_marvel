//취소,노쇼 페이지
import 'package:flutter/material.dart';

class Noshow extends StatefulWidget {
  const Noshow({super.key});

  @override
  State<Noshow> createState() => _NoshowState();
}

class _NoshowState extends State<Noshow> {
  List<Map<String, dynamic>> myMap = [ //이건 db 연결전 더미데이터
   /* {
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
    },*/

  ];

  @override
  Widget build(BuildContext context) {
    if (myMap.isNotEmpty) {
      return schedule();
    } else {
      return Container(
        height: 500,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '취소/노쇼하신 예약이 없습니다.',
                style: TextStyle(fontSize: 20,color: Colors.grey),
              ),
              Text(
                '건강한 예약문화 만들기,',
                style: TextStyle(fontSize: 20,color: Colors.grey),
              ),
              Text(
                '앞으로도 함께해 주세요',
                style: TextStyle(fontSize: 20,color: Colors.grey),
              ),
              SizedBox(height: 30,),
              Text(
                '노쇼 누적시 불이익이 발생하실수 있습니다. ',
                style: TextStyle(fontSize: 20,color: Colors.red),
              )
            ],
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
