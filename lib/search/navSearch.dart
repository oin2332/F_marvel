import 'package:flutter/material.dart';
import 'package:food_marvel/main/importbottomBar.dart';
import 'package:food_marvel/search/headSearch.dart';
import 'package:food_marvel/shop/bestPage.dart';
import 'package:food_marvel/search/ImportRestaurant.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "검색하기",
          style: TextStyle(
            color: Colors.black,
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
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "관심 급상승 음식점",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              children: [
                                for (int i = 1; i <= 5; i++)
                                  Container(
                                    margin: EdgeInsets.all(15.0),
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "$i",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            height: 1.5,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 15.0),
                                          child: Text(
                                            "음식점",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              children: [
                                for (int i = 6; i <= 10; i++)
                                  Container(
                                    margin: EdgeInsets.all(15.0),
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          "$i",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            height: 1.5,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 15.0),
                                          child: Text(
                                            "음식점",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ImportRestaurant(),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavBar(),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}