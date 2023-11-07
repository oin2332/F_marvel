import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Testimg extends StatefulWidget {
  final String docId; // docId를 받을 변수 추가

  Testimg({required this.docId});

  @override
  State<Testimg> createState() => _TestimgState();
}

class _TestimgState extends State<Testimg> {
  //String doc = 'upx55IlYcUeYoFvC0L8T';
  int currentPage = 0;
  final PageController _pageController = PageController();
  List<String> imagePaths = []; // 이미지 경로를 저장할 리스트

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    setState(() {
      currentPage = _pageController.page!.toInt();
    });
  }


  Future<List<Widget>?> _fetchAllUserData1(String docId) async {
    try {
      DocumentSnapshot storeSnapshot = await FirebaseFirestore.instance
          .collection('T3_STORE_TBL')
          .doc(docId)
          .get();

      if (storeSnapshot.exists) {
        QuerySnapshot storeImgList = await FirebaseFirestore.instance
            .collection('T3_STORE_TBL')
            .doc(docId)
            .collection('T3_STOREIMG_TBL')
            .get();


        if (storeImgList.docs.isNotEmpty) {
          for (var storeImgDoc in storeImgList.docs) {
            Map<String, dynamic> storeImgData = storeImgDoc.data() as Map<String, dynamic>;
            List<String> imgList = storeImgData.values.cast<String>().toList();
            imagePaths.addAll(imgList);
          }
        }
      } else {
        print('해당 문서를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('데이터를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<void>(
        future: _fetchAllUserData1(widget.docId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                CircularProgressIndicator(),
              ],
            ); // Display a loading indicator if the future is not resolved yet.
          } else {
            return Scaffold(
              body: Stack(
                children: [
                  Container(
                    height: 400,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: imagePaths.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          'assets/storePageIMG/${imagePaths[index]}',
                          width: 400,
                          height: 200,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Center(
                      child: Container(
                        height: 30,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              '${currentPage + 1}/${imagePaths.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}