import 'package:flutter/material.dart';
import 'package:food_marvel/main/mainPage.dart';

void main() => runApp(MaterialApp(
  title: 'Home',
  home: BestPage(),
  debugShowCheckedModeBanner: false,
));

class BestPage extends StatefulWidget {
  const BestPage({super.key});

  @override
  State<BestPage> createState() => _BestPageState();
}

class _BestPageState extends State<BestPage> {
  void showSortingMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
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
            '전국 푸드마블 웨이팅 맛집의 일 평균 방문횟수와, 별점, 찜목록, 리뷰수가 포함된 랭킹입니다.',
            style: TextStyle(color: Colors.white), // 텍스트 색상 변경
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("전국 BEST 맛집", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black),),
              Row(
                children: [
                  Text("랭킹 기준", style: TextStyle(fontSize: 12, color: Colors.black)),
                  GestureDetector(
                    onTap: () => showSortingMenu(context),
                    child: Icon(Icons.help_outline, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
            },
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: '전국'),
              Tab(text: '서울'),
              Tab(text: '인천'),
              Tab(text: '경기'),
              Tab(text: '제주'),
              Tab(text: '경상도'),
              Tab(text: '전라도'),
              Tab(text: '충청도'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text("전국 탭 내용")),
            Center(child: Text("서울 탭 내용")),
            Center(child: Text("인천 탭 내용")),
            Center(child: Text("경기 탭 내용")),
            Center(child: Text("제주 탭 내용")),
            Center(child: Text("경상도 탭 내용")),
            Center(child: Text("전라도 탭 내용")),
            Center(child: Text("충청도 탭 내용")),
          ],
        ),
      ),
    );
  }
}