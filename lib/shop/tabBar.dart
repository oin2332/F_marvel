import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/shop/underlindeBox.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../board/function/Board.dart';
import '../reservation/soloreservation.dart';
import 'loading.dart';

class TabBarEx extends StatefulWidget {
  final int initialTabIndex;
  final  List<Map<String, dynamic>> shopInfo;
  final Map<String, dynamic> memuMap;
  final  List<String> imgPathList;
  final List<String> menuImgList;

  TabBarEx({
    required this.initialTabIndex,
    required this.shopInfo,
    required this.imgPathList,
    required this.menuImgList,
    required this.memuMap,
  });


  @override
  _TabBarExState createState() => _TabBarExState();
}

class _TabBarExState extends State<TabBarEx> {
  late List<Map<String, dynamic>> StoreDataList;
  late List<Map<String, dynamic>> userBoard;
  late Map<String, dynamic> memuMap;
  List<String> Path = [];
  List<String> menuImg = [];
  List<String> Star = [];
  late List<VBarChartModel> bardata;
  late double average;
  late String shopid;

  int tabIndex = 1;
  double countOfOnly5Stars  = 0;
  double countOfOnly4Stars  = 0;
  double countOfOnly3Stars  = 0;
  double countOfOnly2Stars  = 0;
  double countOfOnly1Stars  = 0;

  @override
  void initState() {
    super.initState();
    tabIndex = widget.initialTabIndex;
    StoreDataList = widget.shopInfo;  // 이미 widget으로부터 전달받은 값으로 초기화
    memuMap = widget.memuMap;  // 이미 widget으로부터 전달받은 값으로 초기화
    Path = widget.imgPathList;  // 이미 widget으로부터 전달받은 값으로 초기화
    menuImg = widget.menuImgList;  // 이미 widget으로부터 전달받은 값으로 초기화
    Star = widget.shopInfo[0]['STARlist'];  // 이미 widget으로부터 전달받은 값으로 초기화
    List<String> starList = widget.shopInfo[0]['STARlist']; // 별점을 나타내는 문자열 리스트


    List<double> numericStarList = starList.map((star) => double.parse(star)).toList();


    double sum = numericStarList.fold(0, (prev, star) => prev + star);


    average = (sum / (numericStarList.length-1));

    List<String> num5 = Star.where((element) => element == '5').toList();
    List<String> num4 = Star.where((element) => element == '4').toList();
    List<String> num3 = Star.where((element) => element == '3').toList();
    List<String> num2 = Star.where((element) => element == '2').toList();
    List<String> num1 = Star.where((element) => element == '1').toList();

    double cnt5 = num5.length.toDouble();
    double cnt4 = num4.length.toDouble();
    double cnt3 = num3.length.toDouble();
    double cnt2 = num2.length.toDouble();
    double cnt1 = num1.length.toDouble();

    cnt5 ??= 0;
    cnt4 ??= 0;
    cnt3 ??= 0;
    cnt2 ??= 0;
    cnt1 ??= 0;

    bardata = [
      VBarChartModel(
        index: 0,
        label: "5점",
        colors: [Colors.orange, Colors.deepOrange],
        jumlah: cnt5,
        tooltip: "(${num5.length})",
      ),
      VBarChartModel(
        index: 1,
        label: "4점",
        colors: [Colors.orange, Colors.deepOrange],
        jumlah: cnt4,
        tooltip: "(${num4.length})",
      ),
      VBarChartModel(
        index: 2,
        label: "3점",
        colors: [Colors.orange, Colors.deepOrange],
        jumlah: cnt3,
        tooltip: "(${num3.length})",
      ),
      VBarChartModel(
        index: 3,
        label: "2점",
        colors: [Colors.orange, Colors.deepOrange],
        jumlah: cnt2,
        tooltip: "(${num2.length})",
      ),
      VBarChartModel(
        index: 4,
        label: "1점",
        colors: [Colors.orange, Colors.deepOrange],
        jumlah: cnt1,
        tooltip: "(${num1.length})",
      ),
    ];
  }

  Future<void> boardList() async {
    try {
      // 'T3_REVIEW_TBL' 컬렉션의 데이터 가져오기
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('T3_REVIEW_TBL')
          .where('s_id', isEqualTo: StoreDataList[0]['S_ID']) // 's_id' 필드가 'shopid'와 일치하는 문서들만 가져옴
          .get();

      // 가져온 데이터를 사용
      userBoard = querySnapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> document) {
        // 각 문서의 데이터에 접근
        return document.data()!;
      }).toList();

      // 확인용 출력
      print('User Board: $userBoard');
    } catch (e) {
      print('데이터를 불러오는 중 오류 발생: $e');
    }
  }

//사진 이미지
  Widget _buildImageSlider(List<String> imageUrls) {
    return Container(
      height: 400,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: 380,
              child: ClipRRect( // ClipRRect를 사용하여 이미지의 경계를 둥글게 함
                borderRadius: BorderRadius.circular(10), // 원하는 값을 설정
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }




  Widget _buildGrafik(List<VBarChartModel> bardata) {
    return Container(
      width: 200, // 원하는 가로 크기
      height: 250, // 원하는 세로 크기
      color: Colors.transparent,
      child: VerticalBarchart(
        maxX: Star.length.toDouble(),
        data: bardata,
        labelColor: Color(0xFFFF6347),
        tooltipColor: Color(0xff8e97a0),
        showLegend: true,
        showBackdrop: true,
        barStyle: BarStyle.DEFAULT,
        alwaysShowDescription: true,
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: CachedNetworkImage(
            placeholder: (context, url) => LoadingSpinner3(),
            imageUrl: imagePath,
          ), // 이미지 표시
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        initialIndex: tabIndex,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_sharp),
                  color: Colors.black,
                ),
                Text(
                  '가게이름',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
            backgroundColor: Color(0xFFFFffff),
            bottom: TabBar(
              physics: NeverScrollableScrollPhysics(),
              isScrollable: false,
              labelColor: Colors.black,
              indicatorColor: Color(0xFFFF6347), // 바닥줄 색상 변경
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                fontSize: 17, // 글씨 크기 조절
                fontWeight: FontWeight.bold, // 글씨 굵기 설정
              ),
              tabs: [
                Tab(

                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('홈',style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.bold),),
                  ),
                ),
                Tab(text: '메뉴'),
                Tab(text: '사진 ${Path.length}'),
                Tab(text: '리뷰 ${Star.length-1}'),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Text("홍"),
              // 메뉴 ---------------------------------------------------------//
              ListView(
                children: <Widget>[
                  ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  menuImg.length,
                                      (index) => GestureDetector(
                                    onTap: () {
                                      // 이미지 클릭 시 다이얼로그 표시
                                      _showImageDialog(context, menuImg[index]);
                                    },
                                    child: CachedNetworkImage(
                                      width: 250,
                                      height: 330,
                                      placeholder: (context, url) => LoadingSpinner3(),
                                      imageUrl: menuImg[index],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          UnderLindeBox().underlineBox(1.0),
                          Container(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${memuMap!['S_MENU1']}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                                SizedBox(height: 12,),
                                Text('${memuMap!['S_MENU1-1']}',style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          ),
                          UnderLindeBox().underlineBox(1.0),
                          Container(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${memuMap!['S_MENU2']}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                                SizedBox(height: 12,),
                                Text('${memuMap!['S_MENU2-1']}',style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          ),
                          UnderLindeBox().underlineBox(1.0),
                          Container(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${memuMap!['S_MENU3']}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                                SizedBox(height: 12,),
                                Text('${memuMap!['S_MENU3-1']}',style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          ),
                          UnderLindeBox().underlineBox(1.0),
                          Container(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text('${memuMap!['S_MENU4']}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                                SizedBox(height: 12,),
                                  Text('${memuMap!['S_MENU4-1']}',style: TextStyle(fontSize: 20)),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
              // 사진----------------------------------------------------------------
              Container(
                padding: EdgeInsets.all(10),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: Path.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // 이미지를 누를 때 AlertDialog로 이미지 크게 보기
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Container(
                                width: double.maxFinite, // 화면 너비에 맞게 설정
                                child: CachedNetworkImage(
                                  width: 250,
                                  height: 300,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => LoadingSpinner3(),
                                  imageUrl: Path[index],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: CachedNetworkImage(
                          width: 250,
                          height: 330,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => LoadingSpinner3(),
                          imageUrl: Path[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
              //리뷰-------------------------------------------------------------------//
              Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text(' ${Star.length-1}개의 리뷰 별점 평균'),
                                  SizedBox(height: 12,),
                                  Icon(Icons.star, color: Colors.yellow[600], size: 50,),
                                  Text('${average.isNaN ? 0 : average.toStringAsFixed(1)}', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                _buildGrafik(bardata),
                              ],
                            ),
                          ],
                        ),
                      ),
                      UnderLindeBox().underlineBox(2.0),
                      SizedBox(height: 18,),
                      FutureBuilder<void>(
                        future: boardList(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LoadingSpinner(),
                              ],
                            );
                          } else {
                            // userBoard가 null이거나 비어 있으면 빈 상태를 표시
                            if (userBoard == null || userBoard.isEmpty) {
                              return ListTile(
                                title: Center(child: Text('리뷰가 없습니다.',style: TextStyle(fontSize: 32,color: Colors.grey),),),
                              );
                            }
                            final length = userBoard.length;
                            // 최대 10개의 리뷰만 표시
                            int itemCount = length > 10 ? 10 : length;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: itemCount,
                          itemBuilder: (BuildContext context, int index) {
                          // userBoard[index]가 null이 아닌 경우에만 해당 부분을 표시
                          if (userBoard[index] != null) {
                            return Container(
                              padding: EdgeInsets.all(30),
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      // 프로필 사진
                                      Container(
                                        width: 50,
                                        height: 50,
                                        child: ClipOval(
                                          child: FutureBuilder<String?>(
                                            future: fetchProfileImageUrl(
                                                userBoard[index]['uId'] ?? ''),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator(); // 데이터를 기다리는 동안 로딩 표시
                                              } else if (snapshot.hasError) {
                                                return Text('오류 발생: ${snapshot
                                                    .error}');
                                              } else {
                                                String? imageUrl = snapshot.data;
                                                if (imageUrl != null) {
                                                  return Image.network(
                                                    imageUrl,
                                                    fit: BoxFit.cover,
                                                    width: 50,
                                                    height: 50,
                                                  );
                                                } else {
                                                  return Image.asset(
                                                      'assets/user/userProfile.png');
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(userBoard![index]['uId'] ?? '',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text('리뷰 23개, 별점3'),
                                        ],
                                      ),
                                      SizedBox(width: 80),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.deepOrange[400]!,
                                        ),
                                        child: Text('팔로우', style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  _buildImageSlider((userBoard[index]['r_img_urls'] as List<dynamic>).cast<String>()),
                                  SizedBox(height: 5),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(Icons.star, color: Colors.amber),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(userBoard[index]['content'] ?? ''),
                                  ),
                                  SizedBox(height: 10),

                                ],
                              ),
                            );
                              } else {
                                return Container(); // userBoard[index]가 null인 경우 빈 컨테이너 반환
                                }
                              }
                            );

                          }

                        },
                      )


                    ],
                  ),
                ),
              ),
            ],
          ),
          //------------------------------------------//
          bottomNavigationBar: BottomAppBar(
            child: Container(
              height: 63,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_border)),
                  TextButton(
                    onPressed: () {
                      StoreInfo storeInfo = StoreInfo(
                        image: widget.shopInfo[0]['S_IMG'],
                        name: widget.shopInfo[0]['S_NAME'],
                        address: '${widget.shopInfo[0]['S_ADDR1']} ${widget.shopInfo[0]['S_ADDR2']} ${widget.shopInfo[0]['S_ADDR3']}',
                        submemo: widget.shopInfo[0]['S_MEMO'],
                        time: widget.shopInfo[0]['S_TIME'],
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReservationPage(
                                storeInfo: storeInfo)
                        ),
                      );
                    },
                    child: Text(
                      '예약하기',
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    ),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(340, 53)),
                      backgroundColor: MaterialStateProperty.all(Color(0xFFFF6347)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}