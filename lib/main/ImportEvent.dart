import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '13_tapBar.dart';
import '20_Move.dart';

class ImportEvent extends StatefulWidget {

  @override
  State<ImportEvent> createState() => _ImportEventState();
}

class _ImportEventState extends State<ImportEvent> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      child: Column(
        children: [
      CarouselSlider(
      items: images.map((image) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0),
        child: InkWell(
          onTap: () {
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0), // 원하는 borderRadius 값을 설정
            child: Stack(
            children: [
            Image.asset(
            image,
            height: 300.0,
            fit: BoxFit.cover,
          ),
          Positioned(
          top: 17,
          left: 40,
          child: Container(
          color: Colors.white.withAlpha(150),
          padding: EdgeInsets.all(8),
          child: Text(
          'BEST & NEW',
          style: TextStyle(
          color: Colors.red,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          ),
          ),
          ),
          ),
          Positioned(
          top: 50,
          left: 40,
          child: Container(
          color: Colors.black54,
          padding: EdgeInsets.all(8),
          child: Text(
          '이번주 매거진을 확인하세요',
          style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          ),
          ),
          ),
          ),
          ],
          ),
          ),
          ),
          );
          }).toList(),
          options: CarouselOptions(
          height: 240,
          aspectRatio: 16 / 9,
          enlargeCenterPage: false, // 가운데 페이지 확대
          enableInfiniteScroll: true,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 7),
          onPageChanged: (index, reason) {
          setState(() {
          _currentPage = index;
          });
          },
          ),
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == entry.key ? Colors.red : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
