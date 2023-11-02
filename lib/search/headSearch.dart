import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/main/importbottomBar.dart';
import 'package:food_marvel/main/mainPage.dart';
import 'package:food_marvel/search/ImportEmptySearch.dart';
import 'package:food_marvel/search/ImportRestaurant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_marvel/search/ImportSuddenpopular.dart';
import '../firebase/firebase_options.dart';
import 'ImportSearchResult.dart';

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
  String searchQuery = "";


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _removeSearch(String search) {
    setState(() {
      recentSearches.remove(search);
    });
    _searchval.collection('T3_SEARCH_TBL').where('searchvalue', isEqualTo: search).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete().then((value) => _loadRecentSearches());
      });
    }).catchError((error) {
      print("Error removing document: $error");
    });
  }

  void _onRecentSearchTapped(String search) {
    setState(() {
      _searchController.text = search;
    });


  }


  void _onSearchSubmitted(String value) async {
    String searchText = _searchController.text;
    setState(() {

      if (recentSearches.contains(searchText)) {
        recentSearches.remove(searchText);
      }
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() {
      searchQuery = searchText;
    });

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
                    "내 최근 검색어",
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
                      InkWell(
                        onTap: () {
                          _onRecentSearchTapped(search);
                        },
                        child: Container(
                          margin: EdgeInsets.all(15.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  _removeSearch(search);
                                },
                                child: Icon(
                                  Icons.clear,
                                  size: 18,
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
            SizedBox(height: 10, child: Container(color: Colors.grey)),
            if (searchQuery.isNotEmpty) ImportSearchResult(),
            if (searchQuery.isNotEmpty) ImportEmptySearch(searchQuery: searchQuery),
            if (searchQuery.isEmpty)
              Column(
                children: [
                  ImportSuddenPopular(),
                  ImportRestaurant(),
                ],
              ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavBar(), // 바텀바 부분 임포트
    );
  }
}