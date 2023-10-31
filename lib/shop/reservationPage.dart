import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  int selectedNumber = 2;
  String selectedTime = '12';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('가게이름 예약가능 날짜'),),
      body: SingleChildScrollView(
        child:  Container(
            child: Column(
              children: [
                Container(
                  height: 60,
                  child: InkWell(
                    onTap: (){
                      _showModalBottomSheet(context);
                    },
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 3,),
                        Text('$selectedNumber인'), // 이 부분을 선택된 인원수로 업데이트
                        Icon(Icons.keyboard_arrow_down_sharp,size: 18,color: Color(0xFFFF6347),),
                        SizedBox(width: 13,),
                      ],
                    ),
                  ),
                ),
                underlineBox(0.9),

                Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text('오늘',style: TextStyle(color: Color(0xFFFF6347), fontSize: 18),),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.30,),
                            IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios_sharp)),
                            Text('10월 3주차'),
                            IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_sharp)),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      _dayTimes('일'),
                      SizedBox(height: 20,),
                      _dayTimes('월'),
                      SizedBox(height: 20,),
                      _dayTimes('화'),
                      SizedBox(height: 20,),
                      _dayTimes('수'),
                      SizedBox(height: 20,),
                      _dayTimes('목'),
                      SizedBox(height: 20,),
                      _dayTimes('금'),
                      SizedBox(height: 20,),
                      _dayTimes('토'),
                      SizedBox(height: 20,),



                    ],
                  ),
                )


              ],
            ),
          ),
      ),
    );
  }
  Widget _dayTimes(String day) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Padding(
              padding:
              const EdgeInsets.only(left: 10.0, bottom: 10.0),
              child: Text(day,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
          ),
          SizedBox(width: 10),

          SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _numberTime('12'),
                    SizedBox(width: 8,),
                    _numberTime('13'),
                    SizedBox(width: 8,),
                    _numberTime('14'),
                    SizedBox(width: 8,),
                    _numberTime('15'),
                    SizedBox(width: 8,),
                    _numberTime('18'),
                    SizedBox(width: 8,),
                    _numberTime('19'),
                    SizedBox(width: 8,),
                    _numberTime('20'),
                    SizedBox(width: 8,),
                    _numberTime('21'),
                    SizedBox(width: 8,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget underlineBox(x) {
    return SizedBox(
      width: double.infinity,
      height: x,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 100,
          child: Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 12,),
                  for (int i = 1; i <= 10; i++)
                    _numberpeople(i.toString()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _numberpeople(String num) {
    bool isSelected = selectedNumber == int.parse(num); // 현재 숫자가 선택된 숫자와 같은지 확인
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedNumber = int.parse(num);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  '$num 명',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(Size(40, 40)),
                backgroundColor: MaterialStateProperty.all(
                  isSelected ? Color(0xFFFF6347) : Colors.white,
                ),
                side: MaterialStateProperty.all(
                  BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _numberTime(String num) {
    bool isSelected = selectedTime == num;

    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedTime = num;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  '$num:00',
                  style: TextStyle(
                    color: Colors.white, // 글자색을 흰색으로 설정
                  ),
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(Size(60, 40)),
                backgroundColor: MaterialStateProperty.all(
                  isSelected ? Color(0xFFFF6347) : Color(0xFFFF6347), // 선택되었을 때와 선택되지 않았을 때 모두 Color(0xFFFF6347)
                ),
                side: MaterialStateProperty.all(
                  BorderSide(
                    color: Colors.black,
                    width: 1,
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
