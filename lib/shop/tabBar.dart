import 'package:flutter/material.dart';
import 'package:food_marvel/shop/underlindeBox.dart';
import 'package:flutter/material.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';

import 'averageChart.dart';
import 'detailpage.dart';

class TabBarEx extends StatefulWidget {
  final int initialTabIndex;
  TabBarEx({required this.initialTabIndex});

  @override
  _TabBarExState createState() => _TabBarExState();
}

class _TabBarExState extends State<TabBarEx> {

  @override
  void initState() {
    super.initState();
    tabIndex = widget.initialTabIndex;
    for (var value in img[0].values) {
      if (value is String && value.endsWith('.jpeg')) {
        Path.add(value);
      }
    }

    double total = 0.0; // 숫자를 더할 변수

    for (var value in starlist[0].values) {
      if (value is String) {
        int starValue = int.parse(value);
        if (starValue != null) {
          total += starValue;
          Star.add(value); // Star 리스트에 value를 추가
        }
      }
    }

    average = total / Star.length;
    countOfOnly5Stars = Star.where((star) => star == '5').length.toDouble();
    countOfOnly5Stars = Star.where((star) => star == '4').length.toDouble();
    countOfOnly5Stars = Star.where((star) => star == '3').length.toDouble();
    countOfOnly5Stars = Star.where((star) => star == '2').length.toDouble();
    countOfOnly5Stars = Star.where((star) => star == '1').length.toDouble();

  }

  List<Map<String, dynamic>> menuImg = [
    {
      'img1': 'BEKMIWOO_MENU1.jpg',
      'img2': 'BEKMIWOO_MENU2.jpg',
      'img3': 'BEKMIWOO_MENU3.jpg',
      'img4': 'BEKMIWOO_MENU4.jpg',
      'S_MENU1' : 'HANWOO',
      'S_MENU1-1' : '59,000~360,000원',
      'S_MENU2' : 'APPETIZER',
      'S_MENU2-1' : '15,000~49,000원',
      'S_MENU3' : 'DISH',
      'S_MENU3-1' : '9,000~25,000원',
      'S_MENU4' : 'BANJOO',
      'S_MENU4-1' : '15,000~40,000원',
      'S_MENU5' : 'DRINK',
      'S_MENU5-1' : '55,000~28,000,000원',

    },
  ];
  List<Map<String, dynamic>> img = [
    {
      'S_IMG1' : 'BEKMIWOO1.jpeg',
      'S_IMG2' : 'BEKMIWOO2.jpeg',
      'S_IMG3' : 'BEKMIWOO3.jpeg',
      'S_IMG4' : 'BEKMIWOO4.jpeg',
      'S_IMG5' : 'BEKMIWOO5.jpeg',
      'S_IMG6' : 'BEKMIWOO6.jpeg',
      'S_IMG7' : 'BEKMIWOO7.jpeg',
      'S_IMG8' : 'BEKMIWOO8.jpeg',
      'S_IMG9' : 'BEKMIWOO9.jpeg',
      'S_IMG10' : 'BEKMIWOO10.jpeg',
      'S_IMG11' : 'BEKMIWOO11.jpeg',
      'S_IMG12' : 'BEKMIWOO12.jpeg',
    }
  ];

  List<Map<String, dynamic>> starlist = [
    {
      'star1' : '5',
      'star2' : '5',
      'star3' : '3',
      'star4' : '3',
      'star5' : '5',
      'star6' : '1',
      'star7' : '4',
      'star8' : '5',
      'star9' : '4',
      'star10' : '4',
      'star11' : '2',
      'star12' : '2',
      'star13' : '5',
      'star14' : '4',
    }
  ];

  List<VBarChartModel> bardata = [
    VBarChartModel(
      index: 0,
      label: "5점",
      colors: [Colors.orange, Colors.deepOrange],
      jumlah: 5,
      tooltip: "5", // 툴팁도 수정
    ),
    VBarChartModel(
      index: 1,
      label: "4점",
      colors: [Colors.orange, Colors.deepOrange],
      jumlah: 3,
      tooltip: "3",

    ),
    VBarChartModel(
      index: 2,
      label: "3점",
      colors: [Colors.orange, Colors.deepOrange],
      jumlah: 2,
      tooltip: "2",
    ),
    VBarChartModel(
      index: 3,
      label: "2점",
      colors: [Colors.orange, Colors.deepOrange],
      jumlah: 1,
      tooltip: "1",
    ),
    VBarChartModel(
      index: 4,
      label: "1점",
      colors: [Colors.orange, Colors.deepOrange],
      jumlah: 2,
      tooltip: "2",
    ),
  ];

  int tabIndex = 1;
  double countOfOnly5Stars  = 0;
  double countOfOnly4Stars  = 0;
  double countOfOnly3Stars  = 0;
  double countOfOnly2Stars  = 0;
  double countOfOnly1Stars  = 12;
  List<String> Path = [];
  List<String> Star = [];
  double average = 0.0;


  Widget _buildGrafik(List<VBarChartModel> bardata) {
    return Container(
      width: 200, // 원하는 가로 크기
      height: 250, // 원하는 세로 크기
      color: Colors.transparent,
      child: VerticalBarchart(
        maxX: Star.length.toDouble(),
        data: bardata,
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
          child: Image.asset(imagePath), // 이미지 표시
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
                Tab(text: '홈'),
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
              ListView.builder(
                  itemCount: menuImg.length,
                  itemBuilder: (context, index) {
                    return Column(
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
                                    _showImageDialog(context, 'assets/storePageIMG/BEKMIWOO/${menuImg[index]['img1']}');
                                  },
                                  child: Image.asset(
                                    'assets/storePageIMG/BEKMIWOO/${menuImg[index]['img1']}',
                                    width: 250,
                                    height: 330,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // 이미지 클릭 시 다이얼로그 표시
                                    _showImageDialog(context, 'assets/storePageIMG/BEKMIWOO/${menuImg[index]['img2']}');
                                  },
                                  child: Image.asset(
                                    'assets/storePageIMG/BEKMIWOO/${menuImg[index]['img2']}',
                                    width: 250,
                                    height: 330,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // 이미지 클릭 시 다이얼로그 표시
                                    _showImageDialog(context, 'assets/storePageIMG/BEKMIWOO/${menuImg[index]['img3']}');
                                  },
                                  child: Image.asset(
                                    'assets/storePageIMG/BEKMIWOO/${menuImg[index]['img3']}',
                                    width: 250,
                                    height: 330,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // 이미지 클릭 시 다이얼로그 표시
                                    _showImageDialog(context, 'assets/storePageIMG/BEKMIWOO/${menuImg[index]['img4']}');
                                  },
                                  child: Image.asset(
                                    'assets/storePageIMG/BEKMIWOO/${menuImg[index]['img4']}',
                                    width: 250,
                                    height: 330,
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
                              Text('${menuImg[index]['S_MENU1']}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                              SizedBox(height: 12,),
                              Text('${menuImg[index]['S_MENU1-1']}',style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                        UnderLindeBox().underlineBox(1.0),
                        Container(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${menuImg[index]['S_MENU2']}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                              SizedBox(height: 12,),
                              Text('${menuImg[index]['S_MENU2-1']}',style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                        UnderLindeBox().underlineBox(1.0),
                        Container(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${menuImg[index]['S_MENU3']}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                              SizedBox(height: 12,),
                              Text('${menuImg[index]['S_MENU3-1']}',style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                        UnderLindeBox().underlineBox(1.0),
                        Container(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${menuImg[index]['S_MENU4']}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                              SizedBox(height: 12,),
                              Text('${menuImg[index]['S_MENU4-1']}',style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                        UnderLindeBox().underlineBox(1.0),
                        Container(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${menuImg[index]['S_MENU5']}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                              SizedBox(height: 12,),
                              Text('${menuImg[index]['S_MENU5-1']}',style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),


                      ],
                    );
                  }),

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
                                child: Image.asset(
                                  'assets/storePageIMG/BEKMIWOO/${Path[index]}',
                                  fit: BoxFit.contain, // 이미지를 화면에 꽉 채워 표시
                                ),
                              ),

                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Image.asset(
                          'assets/storePageIMG/BEKMIWOO/${Path[index]}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),

              ),

              //리뷰-------------------------------------------------------------------//
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child:Column(
                                children: [
                                  Text(' ${Star.length}개의 리뷰 별점 평균'),
                                  SizedBox(height: 12,),
                                  Icon(Icons.star,color: Colors.yellow[600],size: 50,),
                                  Text('${average.toStringAsFixed(1)}',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),)

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



                  ],
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

  //--------------------------------------------------------------//
}




