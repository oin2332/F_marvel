import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BoardView extends StatefulWidget {
  final DocumentSnapshot document;

  BoardView({required this.document});

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  final TextEditingController _commentController = TextEditingController();

  Stream<QuerySnapshot>? _commentsStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _commentsStream = FirebaseFirestore.instance
        .collection('comments')
        .doc(widget.document.id)
        .collection('comments')
        .snapshots();
  }

  //댓글 (comment) 작성
  void _addComment() async {
    if (_commentController.text.isNotEmpty) {
      CollectionReference comments = FirebaseFirestore.instance
          .collection('comments')
          .doc(widget.document.id)
          .collection('comments');

      await comments.add({'comment': _commentController.text});
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.document.data() as Map<String, dynamic>;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(data['title'])),
        body: Center(
          child: Column(
            children: [
              Text("제목 : ${data['title']}"),
              Text(
                  "작성일 : ${DateFormat('yyyy-MM-dd HH:mm:ss').format(data['timestamp'].toDate())}"),
              Text("내용 : ${data['content']}"),
              SizedBox(height: 20),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: "댓글 추가",
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: _addComment,
                child: Text("댓글 작성"),
              ),
              SizedBox(height: 20),
              Expanded(
                child: StreamBuilder(
                  stream: _commentsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    return ListView(
                      children: snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          Map<String, dynamic> commentData =
                              document.data() as Map<String, dynamic>;
                          return ListTile(
                            title: Text(commentData['comment']),
                            subtitle: Text(
                                "작성일 : ${DateFormat('yyyy-MM-dd HH:mm:ss').format(data['timestamp'].toDate())}"),
                            trailing: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete), //clear 아이콘
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('댓글 삭제'),
                                            content: Text('해당 댓글을 삭제하시겠습니까?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('취소'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text('삭제'),
                                                onPressed: () async {
                                                  Navigator.of(context).pop();

                                                  // 해당 댓글의 Document ID
                                                  String commentId = document.id;

                                                  // 댓글 삭제
                                                  await FirebaseFirestore.instance
                                                      .collection('comments')
                                                      .doc(widget.document.id)
                                                      .collection('comments')
                                                      .doc(commentId)
                                                      .delete();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
