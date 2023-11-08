import 'package:flutter/material.dart';
import 'package:food_marvel/main/mainPage.dart';

import 'bestList.dart';
import 'list.dart';

void main() => runApp(MaterialApp(
  title: 'Home',
  home: RecommenedPage(),
  debugShowCheckedModeBanner: false,
));

class RecommenedPage extends StatefulWidget {
  const RecommenedPage({super.key});

  @override
  State<RecommenedPage> createState() => _RecommenedPageState();
}
 
class _RecommenedPageState extends State<RecommenedPage> {
  void showSortingMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context)!.context
        .findRenderObject() as RenderBox;
    final width = overlay.size.width;
    final position = RelativeRect.fromLTRB(
      width - 80,
      kToolbarHeight * 1.8,
      width,
      0,
    );

    showMenu(
      context: context,
      position: position,
      color: Color(0xFF343434),
      items: <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: 1,
          child: Text(
            '전국 푸드마블 사용자들의 추천 스토어, 스토어의 일 평균 방문횟수와, 별점, 찜목록, 리뷰수가 포함된 랭킹입니다.',
            style: TextStyle(color: Colors.white), // 텍스트 색상 변경
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("유저 추천 스토어", style: TextStyle(
            fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainPage()));
          },
        ),
        actions: [
          GestureDetector(
            onTap: () => showSortingMenu(context),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [    Text("랭킹 기준", style: TextStyle(fontSize: 12, color: Colors.black)),
                  Icon(Icons.help_outline, color: Colors.black),
                ],
              ),
            ),
          )
        ],

      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Center(
            child: GestureDetector(
              onTap: () {
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Color(0xFFFCECD8),  // 원하는 배경색 설정
                  borderRadius: BorderRadius.circular(5),  // 원하는 모양의 테두리 설정
                ),
                padding: EdgeInsets.all(5),  // 내부 패딩 설정
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 15,),
                        Text('푸드마블 정식 오픈!',
                          style: TextStyle(color: Colors.black,fontSize: 20,),),
                        Image.asset(
                          'assets/main/쿼카-removebg-preview1.png', // 이미지 경로
                          width: 65, // 이미지의 너비 설정
                          height: 65, // 이미지의 높이 설정
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('유저',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                        SizedBox(width: 10,),
                        Text('추천 맛집 대공개!',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 20),),
                      ],
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: BestListShop("전국~")),
        ],
      ),
    );
  }
}