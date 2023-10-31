import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MaterialApp(
  title: 'Home',
  home: Profile(),
  debugShowCheckedModeBanner: false,
));

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  double averageRating = 4.4;
  bool isFollowing = false;

  void _openInstagramProfile() async {
    const instagramProfileUrl = 'https://www.instagram.com/';
    String instagramUsername = 'sangyeop_1027';

    if (await canLaunch('$instagramProfileUrl$instagramUsername')) {
      await launch('$instagramProfileUrl$instagramUsername');
    } else {
      throw 'Could not launch ${instagramProfileUrl}${instagramUsername}';
    }
  }

  void _openPopupMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final width = overlay.size.width;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        Offset(width - 40, kToolbarHeight + 30), // x, y 좌표를 조절하여 위치를 조정합니다.
        Offset(width, kToolbarHeight + 60), // x, y 좌표를 조절하여 위치를 조정합니다.
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'block',
          child: ListTile(
            title: Text('사용자 차단'),
            onTap: () {
              Navigator.of(context).pop(); // 메뉴 닫기
              _confirmBlockUser(context);
            },
          ),
        ),
        PopupMenuItem<String>(
          value: 'report',
          child: ListTile(
            title: Text('사용자 신고'),
            onTap: () {
              Navigator.of(context).pop(); // 메뉴 닫기
              _confirmReportUser(context);
            },
          ),
        ),
      ],
    );
  }
  void _confirmBlockUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("사용자 차단 확인"),
          content: Text("이 사용자를 차단하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                // 사용자 차단 작업 수행
              },
              child: Text("확인"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text("취소"),
            ),
          ],
        );
      },
    );
  }

  void _confirmReportUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("사용자 신고 확인"),
          content: Text("이 사용자를 신고하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                // 사용자 신고 작업 수행
              },
              child: Text("확인"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text("취소"),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text("프로필", style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _openPopupMenu(context);
            },
            child: Icon(Icons.more_horiz, color: Colors.grey),
          ),
          SizedBox(width: 10,)
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Row(
            children: [
              SizedBox(width: 15,),
              // 프로필 이미지 (왼쪽에 배치)
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/1.jpg'),
              ),
              SizedBox(width: 16), // 각 요소 사이의 간격 조절
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 사용자 닉네임
                  Text(
                    'sangyeop_1027',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text('팔로잉 ',style: TextStyle(fontSize: 12),),
                      Text(' 120 | ',style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(' 팔로워  ',style: TextStyle(fontSize: 12)),
                      Text(' 140',style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  // 팔로우, 팔로잉, 인스타그램 연결 버튼
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _openInstagramProfile();
                          // 인스타그램 연결 버튼 클릭 시 동작
                        },
                        child: Container(
                          width: 40, // 버튼의 가로 크기
                          height: 40, // 버튼의 세로 크기
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // 원 모양으로 설정
                            color: Colors.transparent, // 배경색을 투명하게 설정
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/main/insta-removebg-preview.png', // 이미지 파일의 경로
                              width: 40, // 이미지의 가로 크기 설정
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // 팔로잉 및 팔로워 수
          SizedBox(height: 10,),
          // 자기 소개
          Text(
            'Let me introduce my self. what`s going on?',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isFollowing = !isFollowing; // 팔로우 상태를 변경합니다.
              });
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFFF6347), // 배경색을 ff8347로 설정
              minimumSize: Size(350, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), // radius 값을 조절하여 버튼의 모서리를 둥글게 만듭니다.
              ),// 버튼의 최소 크기를 조절
            ),
            child: Text(isFollowing ? '팔로잉 취소' : '팔로우'),
          ),
          // 게시물 목록 (ListView 또는 GridView를 사용하여 추가)
          Container(
            color: Colors.black12, // 회색(그레이) 색상 설정
            height: 7, // 세로 크기 (두께) 조절
            margin: EdgeInsets.symmetric(vertical: 16), // 위아래 여백 설정
          ),
          Row(
            children: [
              SizedBox(width: 13),
              Text("평균 별점",),
              SizedBox(width: 15),
              StarRating(averageRating),
            ],
          ),
          Container(
            color: Colors.black12, // 회색(그레이) 색상 설정
            height: 3, // 세로 크기 (두께) 조절
            margin: EdgeInsets.symmetric(vertical: 16), // 위아래 여백 설정
          ),
          Row(
            children: [
              SizedBox(width: 13),
              Text("음식취향"),
              SizedBox(width: 15,),
              Text("아직 설정되지않음",style: TextStyle(color: Colors.grey))
            ],
          ),
          Container(
            color: Colors.black12, // 회색(그레이) 색상 설정
            height: 7, // 세로 크기 (두께) 조절
            margin: EdgeInsets.symmetric(vertical: 16), // 위아래 여백 설정
          ),
          Row(
            children: [
              SizedBox(width: 13),
              Text("컬렉션",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(width: 25),
              Text("0",style: TextStyle(color: Colors.grey),)
            ],
          ),
          Column(
            children: [
              SizedBox(height: 15,),
              Text("공개된 컬렉션이 없음",style: TextStyle(color: Colors.grey))
            ],
          )
        ],
      ),
    );
  }
}
class StarRating extends StatelessWidget {
  final double rating; // 평균 별점 (0부터 5까지의 값)

  StarRating(this.rating);

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor(); // 소수점을 버리고 몫을 가져옴
    double remaining = rating - fullStars; // 나머지 부분을 계산

    return Row(
      children: [
        Text(
          rating.toStringAsFixed(1), // 평점 값을 문자열로 변환하고 소수점 1자리까지 나타냅니다.
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10), // 값과 별 사이의 간격 조절
        Row(
          children: List.generate(5, (index) {
            if (index < fullStars) {
              return Icon(
                CupertinoIcons.star_fill,
                color: Color(0xFFFF6347),
              );
            } else if (index == fullStars) {
              if (remaining >= 0.7) {
                return Icon(
                  CupertinoIcons.star_fill,
                  color: Color(0xFFFF6347),
                );
              } else if (remaining >= 0.3) {
                return Icon(
                  CupertinoIcons.star_lefthalf_fill,
                  color: Color(0xFFFF6347),
                );
              } else {
                // 0.3 미만인 경우 반 별 아이콘 표시하지 않음
                return Icon(
                  CupertinoIcons.star,
                  color: Colors.grey,
                );
              }
            } else {
              return Icon(
                CupertinoIcons.star,
                color: Colors.grey,
              );
            }
          }),
        ),
      ],
    );
  }
}