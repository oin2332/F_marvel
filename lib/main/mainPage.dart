import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/main/importbottomBar.dart';
import 'package:food_marvel/search/navSearch.dart';
import 'package:food_marvel/shop/bestPage.dart';
import 'dart:async';

import '../firebase/firebase_options.dart';
import '../search/headSearch.dart';
import '../shop/storePage.dart';
import '../user/userSetting.dart';
import '13_tapBar.dart';
import '20_Move.dart';
import '4_NameCard.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController(initialPage: 0);
  PageController _horizontalPageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<String> images = [
    'assets/main/fine.jpg',
    'assets/main/gong.jpg',
    'assets/main/steak.jpg',
    'assets/main/whine.jpg',
    'assets/main/whisky.png',
  ];

  final List<String> horizontalImages = [
    'assets/main/fine.jpg',
    'assets/main/gong.jpg',
    'assets/main/steak.jpg',
    // 여기에 추가 이미지 경로를 추가할 수 있습니다.
  ];
  final List<Widget> horizontalPages = [
    Sample13(),
    Sample13(),
    Sample13(),
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

  Timer? _timer;

  void initState() {
    super.initState();
    _timer?.cancel();
    _timer  = Timer.periodic(Duration(seconds: 5), (Timer timer) {
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
    _horizontalPageController = PageController(initialPage: 0);
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
      BestPage(),
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
      int totalPages = pages.length;
      Navigator.push(context, MaterialPageRoute(builder: (context) => pages[index]));

      // 페이지가 자동으로 슬라이드되도록 타이머 설정
      Timer? autoSlideTimer;
      autoSlideTimer = Timer.periodic(Duration(seconds: 6), (timer) {
        if (_currentPage < totalPages - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );

        // 타이머 취소
        if (_currentPage == 0) {
          autoSlideTimer?.cancel();
        }
      });
    }
  }
  void navigatePlacePage(int index) {
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
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(height: 10,),
              Container(
                height: 250,
                width: double.infinity,
                child: PageView.builder(
                    itemCount: images.length,
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: (){
                            navigateEventPage(index);
                          },
                          child: Stack(
                            children: [
                              Image.asset(
                                images[index],
                                height: 250.0,
                                fit: BoxFit.cover,),
                              Positioned(
                                  top: 20,
                                  left: 20,
                                  child: Container(
                                    color: Colors.white.withAlpha(150),
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      'BEST & NEW', style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  )
                              ),Positioned(
                                  top: 50,
                                  left: 20,
                                  child: Container(
                                    color: Colors.black54,
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      '이번주의 맛집 칼럼을 확인하세요', style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  )
                              ),
                            ],
                          )
                      );
                    }),
              ),
              SizedBox(height: 20,),
              GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: buttonsData.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        navigateToPage(index);
                      },
                      child: Column(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              buttonsData[index].image,
                              fit: BoxFit.cover,
                              width: 52,
                              height: 52,),
                          ),
                          Text(buttonsData[index].text,
                            style: TextStyle(fontSize: 16),)
                        ],
                      ),
                    );
                  }),
              SizedBox(height: 20,),
              Container(height: 5, width: 400, color: Colors.grey[300]!),
              SizedBox(height: 20,),
              Row(

                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 15,),
                  Text("어디로 가시나요?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                ],
              ),
              SizedBox(height: 10,),
              Container(
                height: 200,
                width: double.infinity,
                child: SingleChildScrollView(
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
                ),
              )

            ],
          ),
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