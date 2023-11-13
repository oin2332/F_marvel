import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/shop/underlindeBox.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../board/function/Board.dart';
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


    average = sum / numericStarList.length;

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
                IconButton(onPressed: (){
                  Navigator.of(context).pop();
                }, icon: Icon(Icons.arrow_back_sharp),color: Colors.black,),
                Text('가게이름',style: TextStyle(color: Colors.black),)
              ],
            ),
            backgroundColor: Color(0xFFFFffff),
            bottom: TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.black,
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
                Tab(text: '리뷰 ${Star.length}'),
              ],
            ),
          ),
          body: TabBarView(
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
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // 이미지 클릭 시 다이얼로그 표시
                                      _showImageDialog(context, menuImg[0]);
                                    },
                                    child: CachedNetworkImage(
                                      width: 250,
                                      height: 330,
                                      placeholder: (context, url) => LoadingSpinner3(),
                                      imageUrl: menuImg[0],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // 이미지 클릭 시 다이얼로그 표시
                                      _showImageDialog(context, menuImg[1]);
                                    },
                                    child: CachedNetworkImage(
                                      width: 250,
                                      height: 330,
                                      placeholder: (context, url) => LoadingSpinner3(),
                                      imageUrl: menuImg[1],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // 이미지 클릭 시 다이얼로그 표시
                                      _showImageDialog(context, '${menuImg[2]}');
                                    },
                                    child: CachedNetworkImage(
                                      width: 250,
                                      height: 330,
                                      placeholder: (context, url) => LoadingSpinner3(),
                                      imageUrl: menuImg[2],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // 이미지 클릭 시 다이얼로그 표시
                                      _showImageDialog(context, '${menuImg[3]}');
                                    },
                                    child: CachedNetworkImage(
                                      width: 250,
                                      height: 330,
                                      placeholder: (context, url) => LoadingSpinner3(),
                                      imageUrl: menuImg[3],
                                    ),
                                  ),
                                  // 다른 이미지들도 동일한 방식으로 처리
                                ],
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
                                  Text(' ${Star.length}개의 리뷰 별점 평균'),
                                  SizedBox(height: 12,),
                                  Icon(Icons.star, color: Colors.yellow[600], size: 50,),
                                  Text('${average.toStringAsFixed(1)}', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),)
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

                    ],
                  ),
                ),
              )


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
                    onPressed: () {},
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