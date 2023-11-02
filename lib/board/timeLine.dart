import 'package:flutter/material.dart';
import 'package:food_marvel/user/notification.dart';

class TimeLine extends StatefulWidget {
  const TimeLine({super.key});

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('타임라인'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationPage()));
          }, icon: Icon(Icons.notifications))
        ],
        bottom:  PreferredSize(
          preferredSize: Size.fromHeight(60.0), // 버튼의 높이 조절
          child: SingleChildScrollView( // 스크롤 가능한 뷰로 변경
            scrollDirection: Axis.horizontal, // 가로 슬라이드 설정
            child: Row(
              children: [
                SizedBox(width: 5), // 좌측 여백
                _menubutton('Button 1'),
                SizedBox(width: 5), // 각 버튼 사이의 간격 조절
                _menubutton('Button 2'),
                SizedBox(width: 5), // 각 버튼 사이의 간격 조절
                _menubutton('Button 3'),
                SizedBox(width: 5), // 각 버튼 사이의 간격 조절
                _menubutton('Button 3'),
                SizedBox(width: 5),
                _menubutton('Button 3'),
                SizedBox(width: 5),
                _menubutton('Button 3'),
                SizedBox(width: 5),
                _menubutton('Button 3'),
                SizedBox(width: 5),
                _menubutton('Button 3'),
                SizedBox(width: 5),
                // 필요한 만큼의 버튼을 추가할 수 있습니다.
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/user/basic.jpg',
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('식도성역류염', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('리뷰1개, 평균 별점 5') // 수정 필요한 부분
                        ],
                      ),
                      SizedBox(width: 145),
                      ElevatedButton(
                          onPressed: (){},
                          child: Text('팔로우')
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Image.asset('assets/user/review.jpg'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.star),
                      Text('1일전')
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                      child: Text('우대갈비 폼 미쳤다')
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(onPressed: (){}, icon: Icon(Icons.favorite)),
                        SizedBox(width: 30),
                        IconButton(onPressed: (){}, icon: Icon(Icons.messenger))
                      ],
                    ),
                  ),
                  Container(height: 10, width: 410, color: Colors.grey[300]!),
                  SizedBox(height: 10),
                  //2번째
                  Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/user/basic.jpg',
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('식도성역류염', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('리뷰1개, 평균 별점 5') // 수정 필요한 부분
                        ],
                      ),
                      SizedBox(width: 145),
                      ElevatedButton(
                          onPressed: (){},
                          child: Text('팔로우')
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Image.asset('assets/user/review2.jpg'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.star),
                      Text('1일전')
                    ],
                  ),
                  SizedBox(height: 10),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('산도롱 맨도롱 맛도롱 ')
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(onPressed: (){}, icon: Icon(Icons.favorite)),
                        SizedBox(width: 30),
                        IconButton(onPressed: (){}, icon: Icon(Icons.messenger))
                      ],
                    ),
                  ),
                  Container(height: 10, width: 410, color: Colors.grey[300]!)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //카테고리 선택 버튼 widget
  Widget _menubutton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // 타원형 모양을 위한 값
        ),
        primary: Colors.white, // 배경색을 흰색으로 설정
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black, // 글씨를 검은색으로 설정
        ),
      ),
    );
  }
}
