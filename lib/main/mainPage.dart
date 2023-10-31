import 'package:flutter/material.dart';
import 'package:food_marvel/main/importbottomBar.dart';
import 'package:food_marvel/search/navSearch.dart';
import 'dart:async';

import '../search/headSearch.dart';
import '../shop/storePage.dart';
import '../user/userSetting.dart';
import '13_tapBar.dart';
import '20_Move.dart';
import '4_NameCard.dart';


void main() => runApp(MaterialApp(
  title: 'Home',
  home: MainPage(),
  debugShowCheckedModeBanner: false,
));

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<String> images = [
    'assets/main/fine.jpg',
    'assets/main/gong.jpg',
    'assets/main/steak.jpg',
    'assets/main/whine.jpg',
    'assets/main/whisky.png',
  ];

  final List<ButtonData> buttonsData = [
    ButtonData('assets/main/top10.png', 'BEST'),
    ButtonData('assets/main/recommend-removebg-preview.png', '추천'),
    ButtonData('assets/main/JapanFood.png', '오마카세'),
    ButtonData('assets/main/steak.png', '스테이크'),
    ButtonData('assets/main/cafe.png', '카페'),
    ButtonData('assets/main/KFood.png', '한식'),
    ButtonData('assets/main/ChinessFood.png', '중식'),
    ButtonData('assets/main/JFood.png', '일식'),
    ButtonData('assets/main/pasta.png', '양식'),
    ButtonData('assets/main/AsianFood.png', '아시안'),
    ButtonData('assets/main/chicken.png', '치킨'),
    ButtonData('assets/main/pizza.png', '피자'),
    ButtonData('assets/main/burger.png', '버거'),
    ButtonData('assets/main/bunsick.png', '분식'),
    ButtonData('assets/main/pojang.png', '포장마차'),
  ];

  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 6), (Timer timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  Widget buildIconWithText(String imagePath, String text, VoidCallback onTap) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(5),
          child: Material(
            color: Colors.grey,
            child: InkWell(
              onTap: onTap,
              child: Image.asset(imagePath, fit: BoxFit.cover, width: 110, height: 80),
            ),
          ),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  void navigateToPage(int index) {
    final pages = [
      Sample4(),
      Sample4(),
      StorePage(),
      StorePage(),
      StorePage(),
      StorePage(),
      StorePage(),
      StorePage(),
      StorePage(),
      StorePage(),
      StorePage(),
      StorePage(),
      StorePage(),
      StorePage(),
      StorePage(),
    ];

    if (index >= 0 && index < pages.length) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => pages[index]));
    }
  }
  void navigateEventPage(int index) {
    final pages = [
      Sample20(),
      Sample20(),
      Sample20(),
      Sample20(),
      Sample20(),
      Sample20(),
    ];

    if (index >= 0 && index < pages.length) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => pages[index]));
    }
  } void navigatePlacePage(int index) {
    final pages = [
      Sample13(),
      Sample13(),
      Sample13(),
      Sample13(),
      Sample13(),
      Sample13(),
    ];

    if (index >= 0 && index < pages.length) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => pages[index]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.white,
        leading: ClipOval(
          child: Container(
            width: 20,height: 20,
            child: Image.asset('assets/main/logo3.jpg', width: 10,height: 10,),
          ),
        ),
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.grey[200]!,
          ),
          child: SizedBox(
            height: 40,
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey[400]!,
                    ),
                  ),
                  Text(
                    "지역, 음식, 매장명 검색",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[400]!,
                    ),
                  ),
                ],
              ),
            )
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications, color: Colors.grey),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserSetting()));
            },
            icon: Icon(Icons.brightness_5, color: Colors.grey),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    navigateEventPage(index);
                  },
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      images[index],
                      height: 300.0,
                      width: 500.0,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: buttonsData.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    navigateToPage(index);
                  },
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          buttonsData[index].image,
                          fit: BoxFit.cover,
                          width: 52,
                          height: 52,
                        ),
                      ),
                      Text(
                        buttonsData[index].text,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 15),
          Text(
            "  어디로 갈래?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF6347)),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                buildIconWithText('assets/main/gps-removebg-preview.png', '내주변', () {
                  navigatePlacePage(5);
                }),
                buildIconWithText('assets/main/incheon.jpg', '인천/부평', () {
                  navigatePlacePage(0);
                }),
                buildIconWithText('assets/main/incheon2.jpg', '인천/연수', () {
                  navigatePlacePage(1);
                }),
                buildIconWithText('assets/main/seoul.jpg', '서울/동암', () {
                  navigatePlacePage(2);
                }),
                buildIconWithText('assets/main/seoul2.jpg', '서울/중구', () {
                  navigatePlacePage(3);
                }),
                buildIconWithText('assets/main/seoul3.jpg', '서울/남동구', () {
                  navigatePlacePage(4);
                }),
              ],
            ),
          ),SizedBox(height: 10),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class ButtonData {
  final String image;
  final String text;

  ButtonData(this.image, this.text);
}