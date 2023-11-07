import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/main/importbottomBar.dart';
import 'package:food_marvel/main/mainPage.dart';
import 'package:food_marvel/search/ImportEmptySearch.dart';
import 'package:food_marvel/search/ImportRestaurant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_marvel/search/ImportSuddenpopular.dart';
import 'package:food_marvel/search/ImportSearchlist.dart';
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
  List<Map<String, dynamic>> searchResults = [];


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> updateT3UserTable() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;

        // T3_USER_TBL 컬렉션에서 'id' 필드 값을 가져옴
        String userIdFromT3UserTable = '';

        QuerySnapshot userTableSnapshot = await FirebaseFirestore.instance
            .collection('T3_USER_TBL')
            .where('userID', isEqualTo: user.uid) // 사용자 ID로 필터링
            .get();

        if (userTableSnapshot.docs.isNotEmpty) {
          userIdFromT3UserTable = userTableSnapshot.docs.first['id'];
        }

        if (userIdFromT3UserTable.isNotEmpty) {
          print('T3_USER_TBL에서 가져온 사용자 ID: $userIdFromT3UserTable');

          // T3_USER_TBL 컬렉션의 문서 ID를 사용하여 필드 업데이트
          await FirebaseFirestore.instance.collection('T3_USER_TBL').doc(userIdFromT3UserTable).set({
            'userID': userIdFromT3UserTable,
            // 다른 필드들을 추가하거나 업데이트할 수 있습니다.
          }, SetOptions(merge: true));

          print('T3_USER_TBL에 ID 필드 업데이트 완료');
        } else {
          print('T3_USER_TBL에서 사용자 ID를 찾을 수 없습니다.');
        }
      } else {
        print('사용자가 로그인되지 않았습니다');
      }
    } catch (e) {
      print('사용자 ID 업데이트 중 에러 발생: $e');
    }
  }

  void _onSearchSubmitted(String value) async {
    String searchText = _searchController.text;
    String userId = await getUserIdFromT3UserTable();
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
    await updateT3UserTable();
  }

  Future<String> getUserIdFromT3UserTable() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;
        print('로그인한 사용자의 ID: $userId');

        QuerySnapshot userTableSnapshot = await FirebaseFirestore.instance
            .collection('T3_USER_TBL')
            .where('id', isEqualTo: userId)
            .get();

        if (userTableSnapshot.docs.isNotEmpty) {
          String userIdFromT3UserTable = userTableSnapshot.docs.first.id;
          return userIdFromT3UserTable;
        } else {
          return 'T3_USER_TBL에서 사용자 ID를 찾을 수 없습니다';
        }
      } else {
        return '사용자가 로그인되지 않았습니다';
      }
    } catch (e) {
      print('사용자 ID를 가져오는 중 에러 발생: $e');
      return '에러가 발생했습니다';
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
    final snapshot = await _searchval.collection('T3_SEARCH_TBL')
        .orderBy('S_TIMESTAMP', descending: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      List<String> loadedSearches = snapshot.docs.map((doc) => doc['S_SEARCHVALURE'].toString()).toList();
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
      bottomNavigationBar: BottomNavBar(), // 바텀바 부분 임포트
    );
  }
}