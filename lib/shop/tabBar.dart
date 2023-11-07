import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/shop/underlindeBox.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';


class TabBarEx extends StatefulWidget {
  final int initialTabIndex;
  final String docId;
  TabBarEx({
    required this.initialTabIndex,
    required this.docId,
  });


  @override
  _TabBarExState createState() => _TabBarExState();
}

class _TabBarExState extends State<TabBarEx> {

  late List<VBarChartModel> bardata;
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

  List<Map<String, dynamic>> userDataList = [];
  Map<String, dynamic> memuMap = {};

  Future<List<Widget>?> _fetchAllUserData(String docId) async {
    try {
      DocumentSnapshot storeSnapshot = await FirebaseFirestore.instance
          .collection('T3_STORE_TBL')
          .doc(docId)
          .get();

      if (storeSnapshot.exists) {
        Map<String, dynamic> storeData = storeSnapshot.data() as Map<String, dynamic>;

        // 해당 상점의 별점 정보 가져오기
        QuerySnapshot starSnapshot = await FirebaseFirestore.instance
            .collection('T3_STORE_TBL')
            .doc(docId)
            .collection('T3_STAR_TBL')
            .get();

        //메뉴 가져오기
        QuerySnapshot menuSnapshot = await FirebaseFirestore.instance
            .collection('T3_STORE_TBL')
            .doc(docId)
            .collection('T3_MENU_TBL')
            .get();
        if (menuSnapshot.docs.isNotEmpty) {
          memuMap = menuSnapshot.docs.first.data() as Map<String, dynamic>;
        }


        List<String> starList = [];
        double x = 0;
        int y = 0;

        if (starSnapshot.docs.isNotEmpty) {
          for (var starDoc in starSnapshot.docs) {
            Map<String, dynamic> starData = starDoc.data() as Map<String, dynamic>;
            starData.forEach((key, value) {
              if (value is String) {
                double? numericValue = double.tryParse(value);
                if (numericValue != null) {
                  starList.add(value);
                  x += numericValue;
                  y++;
                }
              }
            });
          }



        } else {
          starList.add('0');
        }

        if (y > 0) {
          x = x / y;
        }
        print('4 $storeData');
        storeData['STARlength'] = y;
        storeData['STARage'] = x.toStringAsFixed(1);
        storeData['STARlist'] = starList;
        storeData['docId'] = docId;
        userDataList.add(storeData);
        Star.addAll(starList);
      } else {
        print('해당 문서를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('데이터를 불러오는 중 오류가 발생했습니다: $e');
    }
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


  int tabIndex = 1;
  double countOfOnly5Stars  = 0;
  double countOfOnly4Stars  = 0;
  double countOfOnly3Stars  = 0;
  double countOfOnly2Stars  = 0;
  double countOfOnly1Stars  = 0;
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
                  FutureBuilder<List<Widget>?>(
                  future: _fetchAllUserData(widget.docId),
                  builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('별별별 : $Star');

                  return Column(
                  children: [
                  CircularProgressIndicator(),
                  ],
                  ); // Display a loading indicator if the future is not resolved yet.
                  } else {
                      return ListView(
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
                                                _showImageDialog(context, 'assets/storePageIMG/BEKMIWOO/${menuImg[0]['img1']}');
                                              },
                                              child: Image.asset(
                                                'assets/storePageIMG/${menuImg[0]['img1']}',
                                                width: 250,
                                                height: 330,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                // 이미지 클릭 시 다이얼로그 표시
                                                _showImageDialog(context, 'assets/storePageIMG/${menuImg[0]['img2']}');
                                              },
                                              child: Image.asset(
                                                'assets/storePageIMG/${menuImg[0]['img2']}',
                                                width: 250,
                                                height: 330,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                // 이미지 클릭 시 다이얼로그 표시
                                                _showImageDialog(context, 'assets/storePageIMG/${menuImg[0]['img3']}');
                                              },
                                              child: Image.asset(
                                                'assets/storePageIMG/${menuImg[0]['img3']}',
                                                width: 250,
                                                height: 330,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                // 이미지 클릭 시 다이얼로그 표시
                                                _showImageDialog(context, 'assets/storePageIMG/${menuImg[0]['img4']}');
                                              },
                                              child: Image.asset(
                                                'assets/storePageIMG/${menuImg[0]['img4']}',
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
                                          Text('${memuMap['S_MENU1']}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                                          SizedBox(height: 12,),
                                          Text('${memuMap['S_MENU1-1']}',style: TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                    ),
                                    UnderLindeBox().underlineBox(1.0),
                                    Container(
                                      padding: EdgeInsets.all(30),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${memuMap['S_MENU2']}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                                          SizedBox(height: 12,),
                                          Text('${memuMap['S_MENU2-1']}',style: TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                    ),
                                    UnderLindeBox().underlineBox(1.0),
                                    Container(
                                      padding: EdgeInsets.all(30),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${memuMap['S_MENU3']}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                                          SizedBox(height: 12,),
                                          Text('${memuMap['S_MENU3-1']}',style: TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                    ),
                                    UnderLindeBox().underlineBox(1.0),
                                    Container(
                                      padding: EdgeInsets.all(30),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${memuMap['S_MENU4']}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                                          SizedBox(height: 12,),
                                          Text('${memuMap['S_MENU4-1']}',style: TextStyle(fontSize: 20)),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ],
                        );
                  }}),


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
                                  'assets/storePageIMG/${Path[index]}',
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
                          'assets/storePageIMG/${Path[index]}',
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




