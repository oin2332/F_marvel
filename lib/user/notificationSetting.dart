import 'package:flutter/material.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  bool isReservationNotificationEnabled = false; //예약 내역 알림
  bool isReservationNotificationOpen = false; //예약 오픈 알림
  bool isActiveNotificationOpen = false; //활동 알림
  bool isAllNotificationOpen = false; //전체 알림 받기
  bool isPushNotificationOpen = false; //푸시 알림
  bool isSmsNotificationOpen = false; //SMS
  bool isEmailNotificationOpen = false; //이메일

  void updateAllNotifications(bool value) {
    setState(() {
      isAllNotificationOpen = value;
      isPushNotificationOpen = value;
      isSmsNotificationOpen = value;
      isEmailNotificationOpen = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {Navigator.pop(context);},
          ),
          title: Text('알림 설정', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white,elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            SizedBox(height: 15),
            //
            Text('서비스 알림', style: TextStyle(fontWeight: FontWeight.bold,)),
            SizedBox(height: 5),
            Text('신청한 정보의 알림과 활동 소식 알림 등의 정보를 푸시로 안내해 드립니다.', style: TextStyle(fontSize: 12, color: Colors.grey[600]!)),
            SizedBox(height: 10),
            Container(height: 1, width: 170, color: Colors.grey, margin: EdgeInsets.only(left: 8.0)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('예약 내역 알림', style: TextStyle(fontWeight: FontWeight.bold,)),
                    SizedBox(height: 5),
                    Text('예약한 매장 방문에 필요한 정보를 안내해 드립니다.', style: TextStyle(fontSize: 12, color: Colors.grey[600]!)),
                  ],
                ),
                Switch(
                  value: isReservationNotificationEnabled,
                  onChanged: (value) {
                    setState(() {
                      isReservationNotificationEnabled = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('예약 오픈 알림', style: TextStyle(fontWeight: FontWeight.bold,)),
                    SizedBox(height: 5),
                    Text('예약 오픈 한 시간 전 안내해 드립니다.', style: TextStyle(fontSize: 12, color: Colors.grey[600]!)),
                  ],
                ),
                Switch(
                  value: isReservationNotificationOpen,
                  onChanged: (value) {
                    setState(() {
                      isReservationNotificationOpen = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('활동 알림', style: TextStyle(fontWeight: FontWeight.bold,)),
                    SizedBox(height: 5),
                    Text('팔로우, 댓글등 내 활동에 대한 반응을 안내해 드립니다.', style: TextStyle(fontSize: 12, color: Colors.grey[600]!)),
                  ],
                ),
                Switch(
                  value: isActiveNotificationOpen,
                  onChanged: (value) {
                    setState(() {
                      isActiveNotificationOpen = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(height: 5, width: 170, color: Colors.grey, margin: EdgeInsets.only(left: 8.0)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('광고성 정보 알림', style: TextStyle(fontWeight: FontWeight.bold,)),
                    SizedBox(height: 5),
                    Text('이벤트, 할인 등 다양한 혜택을 빠르게 안내해 드립니다.', style: TextStyle(fontSize: 12, color: Colors.grey[600]!)),
                  ],
                ),
                Text('약관 보기', style: TextStyle(fontSize: 8, color: Colors.blue))
              ],
            ),
            SizedBox(height: 20),
            Container(height: 1, width: 170, color: Colors.grey, margin: EdgeInsets.only(left: 8.0)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('전체 알림받기', style: TextStyle(fontWeight: FontWeight.bold)),
                Switch(
                  value: isAllNotificationOpen,
                  onChanged: (value) {
                    updateAllNotifications(value);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('푸시 알림'),
                Switch(
                  value: isPushNotificationOpen,
                  onChanged: (value) {
                    setState(() {
                      isPushNotificationOpen = value;
                      if (!value) {
                        isAllNotificationOpen = false;
                      }
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SMS'),
                Switch(
                  value: isSmsNotificationOpen,
                  onChanged: (value) {
                    setState(() {
                      isSmsNotificationOpen = value;
                      if (!value) {
                        isAllNotificationOpen = false;
                      }
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('이메일'),
                Switch(
                  value: isEmailNotificationOpen,
                  onChanged: (value) {
                    setState(() {
                      isEmailNotificationOpen = value;
                      if (!value) {
                        isAllNotificationOpen = false;
                      }
                    });
                  },
                ),
              ],
            ),
            Text('저장한 매장 소식', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('푸시 알림'),
                Switch(
                  value: isPushNotificationOpen,
                  onChanged: (value) {
                    setState(() {
                      isPushNotificationOpen = value;
                      if (!value) {
                        isAllNotificationOpen = false;
                      }
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SMS'),
                Switch(
                  value: isSmsNotificationOpen,
                  onChanged: (value) {
                    setState(() {
                      isSmsNotificationOpen = value;
                      if (!value) {
                        isAllNotificationOpen = false;
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
