import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/main/importbottomBar.dart';
import 'package:food_marvel/main/mainPage.dart';
import 'package:food_marvel/search/ImportEmptySearch.dart';
import 'package:food_marvel/search/ImportRestaurant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_marvel/search/ImportSuddenpopular.dart';
import 'package:food_marvel/search/ImportSearchlist.dart';
import 'package:provider/provider.dart';
import '../firebase/firebase_options.dart';
import '../user/userModel.dart';
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
  List<Map<String, dynamic>> searchResults = [];


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<String> getUserIdFromT3UserTable() async {

    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('T3_USER_TBL')
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        UserModel userModel = Provider.of<UserModel>(context, listen: false);
        String? userId = userModel.userId;
        print('$userId');

        if (userId != null) {
          print('아이디를알려조: $userId');
        }



        await _searchval.collection('T3_SEARCH_TBL').add({
          'S_SEARCHVALURE': _searchController.text,
          'S_TIMESTAMP': FieldValue.serverTimestamp(),
          'S_USERID': userId,
        });
        print('아니시발 왜되는데 $userId');
        return userId ?? '미확인 사용자';
      } else {
        return '기본 사용자 ID';
      }
    } catch (e) {
      print('사용자 ID를 가져오는 중 에러 발생: $e');
      return '에러 발생';
    }

  }

  void _removeSearch(String search) {
    setState(() {
      recentSearches.remove(search);
    });

    _searchval.collection('T3_SEARCH_TBL').where('S_SEARCHVALURE', isEqualTo: search).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['S_SEARCHVALURE'] == search) {
          doc.reference.delete().then((value) => _loadRecentSearches());
        }
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
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    String? userId = userModel.userId;
    searchResults = [];
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
        'S_SEARCHVALURE': _searchController.text,
        'S_TIMESTAMP': FieldValue.serverTimestamp(),
        'S_USERID': userId,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류: $e')),
      );
    }



    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('T3_STORE_TBL')
        .get();

    List<Map<String, dynamic>> results = [];
    for (var doc in userSnapshot.docs) {
      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      if (matchesSearchText(userData, searchText)) {
        results.add(userData);
      }
    }

    setState(() {
      searchQuery = searchText;
      searchResults = results;
    });

    _searchController.clear();
  }


  bool matchesSearchText(Map<String, dynamic> userData, String searchText) {
    if (searchText.isEmpty) {
      return true;
    }

    List<String> searchFields = ['S_ADDR1', 'S_ADDR2', 'S_ADDR3', 'S_INFO1', 'S_NAME'];

    for (String field in searchFields) {
      if (userData[field] != null && userData[field].toString().contains(searchText)) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    String? userId = userModel.userId;

    print('후아아아아 $userId');

    final snapshot = await _searchval.collection('T3_SEARCH_TBL')
        .where('S_USERID', isEqualTo: userId)
        .get();
        if (userId == null) {
          _searchController.clear();
          return;
         }

    if (snapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> sortedDocs = snapshot.docs..sort((a, b) {
        final aTimestamp = a['S_TIMESTAMP'] as Timestamp;
        final bTimestamp = b['S_TIMESTAMP'] as Timestamp;
        return bTimestamp.compareTo(aTimestamp);
      });

      List<String> loadedSearches = sortedDocs.map((doc) => doc['S_SEARCHVALURE'].toString()).toList();
      if (loadedSearches.length > 6) {
        loadedSearches = loadedSearches.sublist(0, 6);
      }
      loadedSearches = loadedSearches.toSet().toList();
      setState(() {
        recentSearches = loadedSearches;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[400],
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
            if (searchResults.isNotEmpty) (
                Container(
                  height: 500,
                  child: SearchListShop(
                    searchResults: searchResults
                        .where((result) => matchesSearchText(result, searchQuery))
                        .toList(),
                  ),
                )
            )else if(searchQuery.isNotEmpty)
              ImportEmptySearch(searchQuery: searchQuery),
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
      bottomNavigationBar: BottomNavBar(),
    );
  }
}