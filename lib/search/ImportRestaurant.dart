import 'package:flutter/material.dart';
import 'dart:math';

class ImportRestaurant extends StatelessWidget {
  final List<int> shuffledIndices = [0, 1, 2, 3, 4, 5, 6];

  ImportRestaurant() {
    shuffledIndices.shuffle(Random());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            final shuffledIndex = shuffledIndices[index];
            if (shuffledIndex == 0) {
              return _buildItemWithImage(
                image: 'assets/searchIMG/searchimg0.jpg',
                title: "#주차가능매장",
              );//주석
            } else if (shuffledIndex == 1) {
              return _buildItemWithImage(
                image: 'assets/searchIMG/searchimg1.jpg',
                title: "#포장가능",
                content: "#내용2",
              );
            } else if (shuffledIndex == 2) {
              return _buildItemWithImage(
                image: 'assets/searchIMG/searchimg2.jpg',
                title: "#엘레베이터",
                content: "#엘레베이터 있어요",
              );
            } else if (shuffledIndex == 3) {
              return _buildItemWithImage(
                image: 'assets/searchIMG/searchimg3.jpg',
                title: "#2차로 가기 \n 좋은",
                content: "#내용4",
              );
            } else if (shuffledIndex == 4) {
              return _buildItemWithImage(
                image: 'assets/searchIMG/searchimg4.jpg',
                title: "#분위기 좋은",
                content: "#내용5",
              );
            } else if (shuffledIndex == 5) {
              return _buildItemWithImage(
                image: 'assets/searchIMG/searchimg5.jpg',
                title: "#1층매장",
                content: "#내용6",
              );
            } else if (shuffledIndex == 6) {
              return _buildItemWithImage(
                image: 'assets/searchIMG/searchimg6.jpg',
                title: "#키즈존",
                content: "#내용7",
              );
            } else {
              return _buildItemWithoutImage(index);
            }
          },
        ),
      ],
    );
  }

  Widget _buildItemWithImage({
    String? image,
    String? title,
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
              image: AssetImage(image!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: 10,
          right: 10,
          child: Text(
            title!,
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

  Widget _buildItemWithoutImage(int index) {
    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey,
      ),
      child: Center(
        child: Text(
          "Item $index",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: Scaffold(
    appBar: AppBar(title: Text('Restaurant')),
    body: ImportRestaurant(),
  ),
));