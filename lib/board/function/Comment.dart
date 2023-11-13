import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../user/userModel.dart';


//리뷰 게시글에 댓글을 작성
//BOARD_COMMENTS_TBL 컬렉션에 문서 ID는 해당 댓글 작성한 사용자 ID 그리고 댓글내용은 comment 필드에 입력, 그리고 작성날짜가 date 필드에 입력됨
//BOARD_COMMENTS_TBL 컬렉션은 T3_REVIEW_TBL 내부에 서브 컬렉션으로서 존재함


// 댓글 작성 + 목록 조회
class CommentList extends StatelessWidget {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    String? userId = userModel.userId;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // 댓글 입력 필드
          TextField(
            controller: _commentController, // 새로 추가
          ),
          SizedBox(height: 5),
          ElevatedButton(
            onPressed: () {
              submitComment(userId!); // 댓글 작성 버튼
            },
            child: Text('댓글 작성'),
          ),
        ],
      ),
    );
  }

  // 댓글 작성 -> T3_REVIEW_TBL -> BOARD_COMMENTS_TBL 입력
  void submitComment(String userId) async {
    String commentText = _commentController.text; // 실제 입력된 댓글 내용으로 변경
    String commenterId = userId; // 댓글 작성자의 ID를 사용하여 commenterId 설정

    // T3_REVIEW_TBL 컬렉션에서 U_ID 필드 값이 USERID와 일치하는 문서를 찾기
    QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
        .collection('T3_REVIEW_TBL')
        .where('u_id', isEqualTo: userId)
        .get();

    // 일치하는 문서가 있는지 확인 후 댓글 추가
    if (reviewSnapshot.docs.isNotEmpty) {
      String reviewId = reviewSnapshot.docs.first.id;


      await FirebaseFirestore.instance
          .collection('T3_REVIEW_TBL')
          .doc(reviewId)
          .collection('BOARD_COMMENTS_TBL')
          .doc(commenterId) // 댓글 작성자 ID
          .set({
        'COMMENT': commentText,
        'DATE': FieldValue.serverTimestamp(),
      });
    } else {
      print('일치하는 리뷰가 없습니다.');
    }
  }


// 해당 리뷰 게시글에 댓글이 없다면 동작안함
// 해당 리뷰 게시글에 댓글이 있다면 출력
//   Widget selectCommentList({required String reviewId}) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('T3_REVIEW_TBL')
//           .where('id', isEqualTo: userId)
//           .collection('BOARD_COMMENTS_TBL')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return CircularProgressIndicator();
//         }
//
//         var comments = snapshot.data!.docs;
//         return Column(
//           children: comments.map((comment) {
//             var commentText = comment['COMMENT'] ?? '';
//             var date = comment['DATE']?.toDate() ?? DateTime.now();
//
//             return ListTile(
//               title: Text(commentText),
//               subtitle: Text('작성일: $date'),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }
}