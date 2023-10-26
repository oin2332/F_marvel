import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


class DetailPage extends StatefulWidget {

   DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged); // 페이지 변경 리스너 추가
    initializeDateFormatting("ko_KR", null);
  }

  final List<Map<String, dynamic>> storeList = [
    {
      '제목' : '가게이름',
      '별점' : '4.8',
      '설명' : '가게가 착하고 사장님이 맛있어요\n 가게가 착하고 사장님이 맛있어요',
      '주소' : '성수',
      '카테고리' : '레스토랑'
    }
  ];

  final PageController _pageController = PageController();
  final List<String> imagePaths = [ //음식점 사진 리스트
    'assets/33.jpg',
    'assets/33.jpg',
    'assets/44.jfif',
  ];
  int currentPage = 0; // 현재 페이지 번호
  void _onPageChanged() {
    setState(() {
      currentPage = _pageController.page!.toInt(); // 현재 페이지 업데이트
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged); // 리스너 제거
    _pageController.dispose();
    super.dispose();
  }

  Widget underlineBox(x) {
    return SizedBox(
      width: double.infinity,
      height: x,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey[400],
        ),
      ),
    );
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 900, // 원하는 높이로 설정
          child: Container(
            child: Column(
              children: [
                Text('이곳에 모달 내용을 원하는 형식으로 배치합니다.'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 모달 닫기
                  },
                  child: Text('닫기'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String peopleCount = '2';

  String getToday() {
    final DateTime now = DateTime.now();
    final String day = DateFormat('E', 'ko_KR').format(now); // 현재 요일을 구합니다.
    return '오늘($day)';
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            // 뒤로 가거나 다른 작업 수행
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {
              // 뒤로 가거나 다른 작업 수행
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: storeList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: imagePaths.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          imagePaths[index],
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
                    )
                    ,
                  ),
                ],
              ),

              Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('${storeList[index]['카테고리']}   l',style: TextStyle(fontSize: 10,color: Colors.grey),),
                        SizedBox(width: 8,),
                        Text('${storeList[index]['주소']}',style: TextStyle(fontSize: 10,color: Colors.grey)),
                      ],
                    ),
                    Text('${storeList[index]['제목']}'),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow[600],size: 17,),
                        Icon(Icons.star, color: Colors.yellow[600],size: 17,),
                        Icon(Icons.star, color: Colors.yellow[600],size: 17,),
                        Icon(Icons.star, color: Colors.yellow[600],size: 17,),
                        Icon(Icons.star_half, color: Colors.yellow[600],size: 17,),
                        SizedBox(width: 7,),
                        Text('${storeList[index]['별점']}',style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(width: 3,),
                        Text('@개의 리뷰',style: TextStyle(fontSize: 10,color: Colors.grey)),
                      ],
                    ),
                    Text('${storeList[index]['설명']}'),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0), // 넓이 조절
                            child: Row(
                              children: [
                                Icon(Icons.call,size: 18,),
                                SizedBox(width: 3,),
                                Text('전화하기'),
                              ],
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white), // 배경색을 흰색으로 설정
                            side: MaterialStateProperty.all(BorderSide(color: Colors.black, width: 1)), // 테두리 설정
                          ),
                        ),
                        SizedBox(width: 5,),
                        TextButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0), // 넓이 조절
                            child:  Row(
                              children: [
                                Icon(Icons.call,size: 18,),
                                SizedBox(width: 3,),
                                Text('위치보기'),
                              ],
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white), // 배경색을 흰색으로 설정
                            side: MaterialStateProperty.all(BorderSide(color: Colors.black, width: 1)), // 테두리 설정
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              underlineBox(5.0),
              //예약 일시 부분

              Container(
                padding: const EdgeInsets.all(30.0),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('예약 일시' ,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    TextButton(
                      onPressed: () {
                        _showModalBottomSheet();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0), // 넓이 조절
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black),
                            SizedBox(width: 8),
                            Text(getToday(), style: TextStyle(color: Colors.black),),
                            Text('$peopleCount 명', style: TextStyle(color: Colors.black),),
                          ],
                        ),

                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white), // 배경색을 흰색으로 설정
                        side: MaterialStateProperty.all(BorderSide(color: Colors.black, width: 1)), // 테두리 설정
                      ),
                    ),


                  ],
                ),
              ),




            ],
          );
        }
      )
    );
  }
}
