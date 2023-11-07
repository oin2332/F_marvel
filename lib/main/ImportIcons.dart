import 'package:flutter/material.dart';

import '../shop/bestPage.dart';
import '../shop/recommendPage.dart';
import '../shop/storePage.dart';

class ButtonData {
  final String image;
  final String text;
  ButtonData(this.image, this.text);
}

class ImportIcons extends StatefulWidget {

  @override
  State<ImportIcons> createState() => _ImportIconsState();
}

class _ImportIconsState extends State<ImportIcons> {
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

  void navigateToPage(int index) { // 카테고리 버튼 인덱스
    final pages = [
      BestPage(),
      RecommenedPage(),
      StorePage('오마카세'),
      StorePage('스테이크'),
      StorePage('카페'),
      StorePage('한식'),
      StorePage('중식'),
      StorePage('일식'),
      StorePage('양식'),
      StorePage('아시안'),
      StorePage('치킨'),
      StorePage('피자'),
      StorePage('햄버거'),
      StorePage('분식'),
      StorePage('포장마차'),
    ];

    if (index >= 0 && index < pages.length) { //카테고리 버튼
      Navigator.push(context, MaterialPageRoute(builder: (context) => pages[index]));
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.asMap().entries.map((entry){
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == entry.key
                    ? Colors.red
                    : Colors.grey,
              ),
            );
          }).toList(),
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
      ],
    );
  }
}
