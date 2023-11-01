// 방문예정 페이지


import 'package:flutter/material.dart';

class Visit_completed_page extends StatefulWidget {
  const Visit_completed_page({super.key});

  @override
  State<Visit_completed_page> createState() => _Visit_schedule_pageState();
}

class _Visit_schedule_pageState extends State<Visit_completed_page> {

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
      return completed();
    } else {
      return Container(
        height: 300,
        child: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '방문예정이 없습니다.',
                style: TextStyle(fontSize: 20,color: Colors.grey),
              ),
              SizedBox(height: 8,),
              Text(
                '푸드마블을 통해 편리하게 예약해보세요!',
                style: TextStyle(fontSize: 20,color: Colors.grey),
              ),
            ],
          )
        ),
      );
    }
  }

  Widget completed() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 590,
      child:  ListView.builder(
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
                  height: 150, // 원하는 높이 설정
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
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('예약취소'),
                                      content: Text('정말로 취소하시겠습니까?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // 다이얼로그 닫기
                                          },
                                          child: Text('취소'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // 여기에 확인 버튼을 눌렀을 때 수행할 작업을 추가
                                            Navigator.of(context).pop(); // 다이얼로그 닫기
                                          },
                                          child: Text('확인'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.close, color: Colors.red),
                            )
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
