import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  title: 'Search',
  home: Search(),
  debugShowCheckedModeBanner: false,
));

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = TextEditingController();
  List<String> recentSearches = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      recentSearches.insert(0, value);
      if (recentSearches.length > 6) {
        recentSearches.removeAt(6);
      }
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF7070),
        leading: Align(
          alignment: Alignment.center,
          child: Icon(Icons.chevron_left, color: Colors.white),
        ),
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.grey,
          ),
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: _searchController,
              onSubmitted: _onSearchSubmitted,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white),
                hintText: "지역, 음식, 매장명 검색",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 100.0),
                hintStyle: TextStyle(
                  height: 1,
                  color: Colors.white,
                ),
              ),
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "최근 검색어",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
            Wrap(
              children: [
                for (var search in recentSearches)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.all(15.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Text(
                              search,
                              style: TextStyle(
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  recentSearches.remove(search);
                                });
                              },
                              child: Icon(
                                Icons.clear,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "관심 급상승 음식점",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
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