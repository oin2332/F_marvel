import 'package:flutter/material.dart';
import 'package:food_marvel/search/headSearch.dart';

void main() => runApp(MaterialApp(
  title: 'NavSearch',
  home: NavSearch(),
  debugShowCheckedModeBanner: false,
));

class NavSearch extends StatefulWidget {
  const NavSearch({super.key});

  @override
  State<NavSearch> createState() => _NavSearchState();
}

class _NavSearchState extends State<NavSearch> {
  TextEditingController _searchController = TextEditingController();
  List<String> recentSearches = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                shadows: [],
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
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Search()),
                          );
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.black),
                          hintText: "지역, 음식, 매장명 검색",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
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
                    SizedBox(height: 10,),
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
                            "날짜 선택",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Search()),
                  );
                },
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