import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'loading.dart';

class Testimg extends StatefulWidget {
  final String docId; // docId를 받을 변수 추가

  Testimg({required this.docId});

  @override
  State<Testimg> createState() => _TestimgState();
}

class _TestimgState extends State<Testimg> {
  @override
  void initState() {
    super.initState();
    _fetchAllUserData1(widget.docId); // 데이터 미리 불러오기
  }

  int currentPage = 0;
  final PageController _pageController = PageController();

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

  List<String> imagePaths = []; // 이미지 경로를 저장할 리스트

  Future<void> _fetchAllUserData1(String docId) async {
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
          List<dynamic> rImgUrlsList = storeImgList.docs[0].get('r_img_urls'); // 첫 번째 문서의 r_img_urls 필드에서 데이터 가져오기

          // r_img_urls의 각 항목을 imagePaths에 추가
          List<String> paths = [];
          rImgUrlsList.forEach((imageUrl) {
            if (imageUrl is String) {
              paths.add(imageUrl);
            }
          });

          setState(() {
            imagePaths = paths;
          });
        } else {
          print('이미지 목록이 비어 있습니다.');
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
      child: imagePaths == null
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingSpinner2(),
        ],
      )
          : Scaffold(
        body: Stack(
          children: [
            Center(
              child: Container(
                height: 400,
                child: PageView.builder(
                  itemCount: imagePaths.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      width: 400,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const LoadingSpinner3(),
                      imageUrl: imagePaths[index],
                    );
                  },
                ),
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
      ),
    );
  }
}