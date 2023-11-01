import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/main/importbottomBar.dart';
import 'package:food_marvel/main/mainPage.dart';
import 'package:food_marvel/search/ImportRestaurant.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}



class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}


class _SearchState extends State<Search> {
  final FirebaseFirestore _searchval = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  List<String> recentSearches = [];


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String value) async {
    String searchText = _searchController.text;
    setState(() {
      recentSearches.insert(0, searchText);
      if (recentSearches.length > 6) {
        recentSearches.removeAt(6);
      }
    });

    try {
      await _searchval.collection('T3_SEARCH_TBL').add({
        'searchvalue': _searchController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('성공!!')),
      );



    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    _searchController.clear();
  }

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }


  Future<void> _loadRecentSearches() async {
    final snapshot = await _searchval.collection('T3_SEARCH_TBL')
        .orderBy('timestamp', descending: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      List<String> loadedSearches = snapshot.docs.map((doc) => doc['searchvalue'].toString()).toList();
      if (loadedSearches.length > 6) {
        loadedSearches = loadedSearches.sublist(0, 6);
      }
      setState(() {
        recentSearches = loadedSearches;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF7070),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(
              MaterialPageRoute(
                builder: (context) => MainPage(),
              ),
            );
          },
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
                hintText: "지역/음식/매장명 검색",
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
            ImportRestaurant(),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavBar(),
    );
  }
}