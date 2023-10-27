import 'package:flutter/material.dart';
import 'package:food_marvel/search/headSearch.dart';
import 'package:food_marvel/shop/bestPage.dart';

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
                context, MaterialPageRoute(builder: (context) => BestPage()));
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
                      child: TextField(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Search()));
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.black),
                          hintText: "지역, 음식, 매장명 검색",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 100.0),
                          hintStyle: TextStyle(
                            height: 1,
                            color: Colors.black,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
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
                          padding:
                              const EdgeInsets.only(bottom: 5.0, left: 15.0),
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
                            padding:
                                const EdgeInsets.only(left: 10.0, bottom: 10.0),
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
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "어떤 레스토랑 찾으세요??",
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
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 70,
          color: Color.fromRGBO(180, 180, 180, 0.7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {},
                child: Icon(Icons.home),
              ),
              InkWell(
                onTap: () {},
                child: Icon(Icons.search),
              ),
              InkWell(
                onTap: () {},
                child: Icon(Icons.message),
              ),
              InkWell(
                onTap: () {},
                child: Icon(Icons.calendar_today_rounded),
              ),
              InkWell(
                onTap: () {},
                child: Icon(Icons.person),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
