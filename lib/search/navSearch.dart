import 'package:flutter/material.dart';
import 'package:food_marvel/main/importbottomBar.dart';
import 'package:food_marvel/search/headSearch.dart';
import 'package:food_marvel/shop/bestPage.dart';
import 'package:food_marvel/search/ImportRestaurant.dart';
import 'package:food_marvel/search/ImportSuddenpopular.dart';
import 'package:provider/provider.dart';

import '../board/timeLine.dart';
import '../main/mainPage.dart';
import '../reservation/RtabBar.dart';
import '../user/userMain.dart';
import '../user/userModel.dart';
import '../user/userUnlogin.dart';

void main() => runApp(MaterialApp(
  title: 'NavSearch',
  home: NavSearch(),
  debugShowCheckedModeBanner: false,
));

class NavSearch extends StatefulWidget {
  const NavSearch({Key? key});

  @override
  State<NavSearch> createState() => _NavSearchState();
}

class _NavSearchState extends State<NavSearch> {
  TextEditingController _searchController = TextEditingController();
  List<String> recentSearches = [];
  bool isFilterVisible = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void openModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          // 모달 내용을 구현하십시오.
        );
      },
    );
  }

  Widget _menubutton(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: ElevatedButton(
        onPressed: () {
          if (text == 'Best맛집') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BestPage()),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          primary: Colors.white,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _menuButtonList() {
    List<String> buttons = ['내주변', 'Best맛집', '음식 종류', '가격', '분위기', '몰라'];

    return Container(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: buttons.map((text) {
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: _menubutton(text),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[400],
        title: Text(
          "검색하기",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: InkWell(
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Search()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0, left: 15.0),
                              child: Text(
                                "지역/음식/매장명 검색",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0, left: 15.0),
                          child: Text(
                            "날짜/시간/인원 선택",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // 검색 버튼을 눌렀을 때 수행할 동작 추가
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            primary: Colors.blue,
                          ),
                          child: Text(
                            "검색하기",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                            child: Icon(
                              Icons.tune_outlined,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 2,
                            height: 40,
                            color: Colors.grey,
                            margin: EdgeInsets.only(bottom: 10.0),
                            padding: EdgeInsets.only(left: 30.0),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _menuButtonList(),
                          ),
                        ],
                      ),
                    ),
                    ImportSuddenPopular(), // 관심 급상승 음식점 부분 임포트
                  ],
                ),
              ),
            ),
            ImportRestaurant(), // 어떤맛집 찾으세요 부분 임포트
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar:  BottomAppBar(
        child: Container(
          height: 50,
          color: Color.fromRGBO(255, 255, 255, 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                  },child: Icon(Icons.home_outlined,size: 30),),
              InkWell(
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => NavSearch()));},
                child: Icon(Icons.search, size: 30),),
              InkWell(onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TimeLine()));
              },  child: Icon(Icons.message_outlined, size: 28),),
              InkWell(onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResTabBar()));
              }, child: Icon(Icons.calendar_today_outlined, size: 28),),
              InkWell(onTap: () {
                if (userModel.isLogin) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserMain()));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserUnlogin()));
                }
              }, child: Icon(Icons.person_outline_outlined, size: 30),),
            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );

  }
}