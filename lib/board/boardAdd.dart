import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/board/boardView.dart';
import '../firebase/firebase_options.dart';
import '../main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BoardAdd(),
    );
  }
}

class BoardAdd extends StatefulWidget {
  const BoardAdd({super.key});

  @override
  State<BoardAdd> createState() => _BoardAddState();
}

class _BoardAddState extends State<BoardAdd> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _content = TextEditingController();
  String? _selectUser;

  bool isContentValid = false; // 리뷰 글 작성 감지

  //CRUD - Create,Add
  void _addBoard() async {
    if (_title.text.isNotEmpty && _content.text.isNotEmpty) {
      FirebaseFirestore fs = FirebaseFirestore.instance; // 싱글톤 구성
      CollectionReference board = fs.collection("board");

      await board.add({
        'title': _title.text,
        'content': _content.text,
        'timestamp' : FieldValue.serverTimestamp(),
      });

      _title.clear();
      _content.clear();
    } else {
      print("제목 또는 내용을 입력해주세요.");
    }
  }

  //CRUD - Update
  void _updateUser() async {
    if (_selectUser == null){
      print("수정할 사용자를 선택해주세요");
      return;
    }
    FirebaseFirestore fs = FirebaseFirestore.instance; // 싱글톤 구성
    CollectionReference users = fs.collection("board");

    // QuerySnapshot snap = await users.where('name', isEqualTo: '홍길동').get();
    // for(QueryDocumentSnapshot doc in snap.docs){
    //   users.doc(doc.id).update({'age' : 80});
    // }

    await users.doc(_selectUser).update({
      'title' : _title.text,
      'content' : _content,
    });
    _title.clear();
    _content.clear();
  }

  //CRUD - Delete, Remove
  void _deleteUser() async {
    if (_selectUser == null){
      print("삭제할 사용자를 선택해주세요");
      return;
    }
    FirebaseFirestore fs = FirebaseFirestore.instance;
    CollectionReference users = fs.collection("board");

    await users.doc(_selectUser).delete();
    _title.clear();
    _content.clear();

    setState(() {
      _selectUser = null;
    });
  }

  Widget _listUser() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("board").orderBy("timestamp", descending: true).snapshots(),
      ///////////////////users/////////////////////
      //게시글 정렬 후 출력 (orderBy(descending: ,))
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap){
        if(!snap.hasData) {
          return Transform.scale(
            scale: 0.1,
            child: CircularProgressIndicator(strokeWidth: 20),
          );
        }
        return ListView(
          children: snap.data!.docs.map(
                (DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return RadioListTile(
                title: Text(data['title']),
                subtitle: Text("내용 : ${data['content']}"),
                value: document.id, // 선택된 값을 Document ID로 설정
                groupValue: _selectUser,
                onChanged: (value) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => BoardView(document: document),),);
                  setState(() {
                    _selectUser = value;
                    _title.text = data['title'];
                    _content.text = data['content'].toString();
                  });
                },
              );
            },
          ).toList(),
        );
      },
    );
  }

  void _selectPic() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('앨범에서 선택'),
              onTap: () {
                // 앨범에서 선택하는 로직을 추가하세요
                // 예를 들어, 이미지 선택 코드를 넣어주세요.
                Navigator.pop(context); // 모달 바텀 시트 닫기
              },
            ),
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('카메라로 촬영'),
              onTap: () {
                // 카메라로 촬영하는 로직을 추가하세요
                Navigator.pop(context); // 모달 바텀 시트 닫기
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate, // 추가된 부분
        DefaultWidgetsLocalizations.delegate,
      ],
      home: Scaffold(
        appBar: AppBar(title: Text('리뷰 작성'),leading: IconButton(onPressed: (){},icon: Icon(Icons.arrow_back_ios))),
        body: Padding(
            padding: EdgeInsets.all(20.0),
            child: Builder(
              builder: (context) {
                return ListView(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 80,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: _selectPic,
                                icon: Icon(Icons.add_circle)
                            ),
                            Text('사진 추가'),
                            Text('0 / 15')
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _content,
                      onChanged: (text) {
                        setState(() {
                          isContentValid = text.isNotEmpty; // 입력값이 비어있지 않다면 true로 설정
                        });
                      },
                      decoration: InputDecoration(
                      hintText: "경험이나 정보를 자세히 작성할수록...",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 40),
                    ),
        ),

                    SizedBox(height: 5),
                    Text('FoodMarvel 리뷰 작성 정책을 위반하는 경우에는 숨김 처리 될 수 있습니다.', style: TextStyle(fontSize: 10)),
                    SizedBox(height: 20),
                    TextButton(
                        onPressed: (){},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('방문한 날짜', style: TextStyle(color: Colors.black)),
                            Icon(Icons.arrow_forward_ios, color: Colors.black)
                          ],
                        )),
                    ElevatedButton(
                      onPressed: isContentValid ? _addBoard : null, // 입력값이 유효할 때만 버튼 활성화
                      child: Text("작성 완료"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey; // 비활성화 상태일 때 배경색
                          }
                          return Theme.of(context).primaryColor; // 활성화 상태일 때 기본 테마의 primary color
                        }),
                        foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.white; // 비활성화 상태일 때 텍스트 색상
                          }
                          return Colors.white; // 활성화 상태일 때 텍스트 색상 (기본은 흰색)
                        }),
                      ),
                    ),
                  ],
                );
              }
            ),
        ),
      ),
    );
  }
}

