import 'package:flutter/material.dart';

class FlavorChoice extends StatefulWidget {
  const FlavorChoice({super.key});

  @override
  State<FlavorChoice> createState() => _FlavorChoiceState();
}

class _FlavorChoiceState extends State<FlavorChoice> {
  List<String> selectedFlavors = [];
  String selectedPriceRange = '';

  void toggleFlavor(String flavor) {
    setState(() {
      if (selectedFlavors.contains(flavor)) {
        selectedFlavors.remove(flavor);
      } else {
        if (selectedFlavors.length < 5) {
          selectedFlavors.add(flavor);
        }
      }
    });
  }
  void clearSelectedFlavors() {
    setState(() {
      selectedFlavors.clear();
      selectedPriceRange = '';
    });
  }

  Color getButtonColor(String flavor) {
    return selectedFlavors.contains(flavor) ? Colors.green : Colors.blue;
  }

  void _showConfirmationDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('내 취향 선택을 그만 하시겠어요?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
              SizedBox(height: 20),
              Divider(
                color: Colors.grey[300]!,
                thickness: 1,
                height: 1,
              ),
              SizedBox(height: 16),
              Text('취향선택을 완료하시면 취향에 맞게 추천해드려요!',
                style: TextStyle(color: Colors.grey),),
              SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // 모달 닫기
                      Navigator.pop(context); // 현재 페이지 닫기
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text('그만두기'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // 모달 닫기
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text('계속하기'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override

  Widget build(BuildContext context) {
    final flavors = [
      '한식', '중식', '일식', '양식',
      '퓨전', '디저트', '간식', '분식',
      '베이커리', '햄버거', '피자', '카페',
      '술집', '기타',
    ];

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:  Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text('취향 선택',style: TextStyle(color: Colors.black),),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _showConfirmationDialog,
            ),
            bottom: TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: [
                Tab(text: '음식종류'),
                Tab(text: '가격범위')
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('어떤 음식을 좋아하시나요?'),
                    Text('최대 5개를 선택하실 수 있습니다.'),
                    Text(
                      '(${selectedFlavors.length}/5)개 선택됨', // 선택된 항목의 수를 표시
                      style: TextStyle(
                        color: Colors.red, // 빨간색 텍스트
                      ),
                    ),
                    SizedBox(height: 40),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: flavors.map((flavor) {
                        final isSelected = selectedFlavors.contains(flavor);
                        return ElevatedButton(
                          onPressed: () {
                            toggleFlavor(flavor);
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                                Size(192, 50)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // 모서리 둥글기 조절
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                              if (isSelected) {
                                return Color(0xFFFF6347); // 선택된 경우의 배경색
                              } else {
                                return Colors.white; // 선택되지 않은 경우의 배경색
                              }
                            }),
                            side: MaterialStateProperty.all(
                              BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          child: Text(
                            '$flavor${isSelected ? ' (선택됨)' : ''}',
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 130,),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 190,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                  return Colors.white; // 흰 배경색
                                }),
                                side: MaterialStateProperty.all(
                                  BorderSide(color: Colors.grey, width: 1), // 검정 테두리
                                ),
                              ),
                              onPressed: () {
                                clearSelectedFlavors();// 취소 작업을 수행
                              },
                              child: Text(
                                '취소',
                                style: TextStyle(
                                  color: Colors.black, // 검정 글자색
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 190,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                  return Colors.white30; // 흰 배경색
                                }),
                                side: MaterialStateProperty.all(
                                  BorderSide(color: Colors.white30, width: 1), // 검정 테두리
                                ),
                              ),
                              onPressed: () {
                                // 완료 작업을 수행
                              },
                              child: Text(
                                '완료',
                                style: TextStyle(
                                  color: Colors.black54, // 글자색
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('프로필에는 노출되지 않습니다',
                        style: TextStyle(color: Colors.deepOrange)),
                    Text('식당 방문 시 주로 고려하시는 가격대를'),
                    Text('선택해주세요 (1인 기준 가격입니다).'),
                    SizedBox(height: 16,),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        // 가격 범위 버튼들
                        _buildPriceRangeButton('3만원 - 10만원'),
                        _buildPriceRangeButton('5만원 - 10만원'),
                        _buildPriceRangeButton('5만원 - 15만원'),
                        _buildPriceRangeButton('5만원 이하'),
                        _buildPriceRangeButton('10만원 이하'),
                        _buildPriceRangeButton('15만원 이하'),
                        _buildPriceRangeButton('5만원 이상'),
                        _buildPriceRangeButton('10만원 이상'),
                        _buildPriceRangeButton('15만원 이상'),
                        _buildPriceRangeButton('20만원 이상'),
                        _buildPriceRangeButton('직접 선택'),

                        // 다른 가격대 버튼들을 추가할 수 있습니다.
                      ],
                    ),
                    SizedBox(height: 335,),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 190,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                  return Colors.white; // 흰 배경색
                                }),
                                side: MaterialStateProperty.all(
                                  BorderSide(color: Colors.grey, width: 1), // 검정 테두리
                                ),
                              ),
                              onPressed: () {
                                clearSelectedFlavors();// 취소 작업을 수행
                              },
                              child: Text(
                                '취소',
                                style: TextStyle(
                                  color: Colors.black, // 검정 글자색
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 190,
                            height: 50,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                  return Colors.white30; // 흰 배경색
                                }),
                                side: MaterialStateProperty.all(
                                  BorderSide(color: Colors.white30, width: 1), // 검정 테두리
                                ),
                              ),
                              onPressed: () {
                                // 완료 작업을 수행
                              },
                              child: Text(
                                '완료',
                                style: TextStyle(
                                  color: Colors.black54, // 검정 글자색
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPriceRangeButton(String label) {
    final isSelected = selectedPriceRange == label;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedPriceRange = label;
        });
      },
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(125, 50)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (isSelected) {
            return Color(0xFFFF6347); // 선택된 경우의 배경색
          } else {
            return Colors.white; // 선택되지 않은 경우의 배경색
          }
        }),
        side: MaterialStateProperty.all(
          BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      child: Text(
        '$label${isSelected ? '' : ''}',
        style: TextStyle(
          fontSize: 14,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

}
