import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MaterialApp(
  home: Scaffold(
    appBar: AppBar(title: Text('Restaurant')),
    body: ImportRestaurant(),
  ),
));

class ImportRestaurant extends StatelessWidget {
  final List<RestaurantItem> restaurantItems = [
    RestaurantItem(
      image: 'assets/searchIMG/searchimg0.jpg',
      title: "#주차가능매장",
      content: "내용0",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg1.jpg',
      title: "#데이트하기\n좋은",
      content: "내용1",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg2.jpg',
      title: "#엘리베이터\n있는",
      content: "내용2",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg3.jpg',
      title: "#재방문많은",
      content: "내용3",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg4.jpg',
      title: "#숨은맛집",
      content: "내용4",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg5.jpg',
      title: "#1층매장",
      content: "내용5",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg6.jpg',
      title: "#키즈존",
      content: "내용6",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg7.jpg',
      title: "#이국적인",
      content: "내용7",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg8.jpg',
      title: "#소박한",
      content: "내용8",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg9.jpg',
      title: "#아늑한",
      content: "내용9",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg10.jpg',
      title: "#착한가격",
      content: "내용10",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg11.jpg',
      title: "#특별한날",
      content: "내용11",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg12.jpg',
      title: "#신선한",
      content: "내용12",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg13.jpg',
      title: "#비오는날",
      content: "내용13",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg14.jpg',
      title: "#포장가능",
      content: "내용14",
    ),

  ];

  @override
  Widget build(BuildContext context) {
    restaurantItems.shuffle(Random());

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "어떤 맛집 찾으세요??",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
            ),
            itemCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final restaurantItem = restaurantItems[index];
              return _buildItemWithImage(
                image: restaurantItem.image,
                title: restaurantItem.title,
                content: restaurantItem.content,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemWithImage({
    required String image,
    required String title,
    String content = "",
  }) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(15.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: 10,
          right: 10,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Positioned(
          top: 130,
          left: 10,
          right: 10,
          child: Text(
            content,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.lightBlueAccent,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class RestaurantItem {
  final String image;
  final String title;
  final String content;

  RestaurantItem({
    required this.image,
    required this.title,
    this.content = "",
  });
}