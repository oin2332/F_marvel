import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase/firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   ); // Firebase 앱을 초기화합니다.
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedPlace = ''; // 선택된 장소를 저장할 변수

  void _handleRadioValueChange(String? value) {
    setState(() {
      selectedPlace = value;
    });
  }

  Future<void> _addPlaceToFirestore() async {
    if (selectedPlace != null && selectedPlace!.isNotEmpty) {
      String documentName = FieldValue.serverTimestamp().toString(); // 원하는 문서 이름으로 지정할 수 있습니다.
      Map<String, dynamic> place = {
        'name': selectedPlace,
        'address': '장소의 주소 또는 설명',
      };

      DocumentReference documentReference = _firestore.collection('son_test').doc(documentName);
      await documentReference.set(place);

      print('Place added to Firestore: $place');
    } else {
      print('Please select a place first.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RadioListTile<String>(
              title: Text('칸다소바'),
              value: '칸다소바',
              groupValue: selectedPlace,
              onChanged: _handleRadioValueChange,
            ),
            RadioListTile<String>(
              title: Text('인브스키친'),
              value: '인브스키친',
              groupValue: selectedPlace,
              onChanged: _handleRadioValueChange,
            ),
            RadioListTile<String>(
              title: Text('에픽'),
              value: '에픽',
              groupValue: selectedPlace,
              onChanged: _handleRadioValueChange,
            ),
            RadioListTile<String>(
              title: Text('크라이치즈버거'),
              value: '크라이치즈버거',
              groupValue: selectedPlace,
              onChanged: _handleRadioValueChange,
            ),
            RadioListTile<String>(
              title: Text('타키'),
              value: '타키',
              groupValue: selectedPlace,
              onChanged: _handleRadioValueChange,
            ),
            ElevatedButton(
              onPressed: _addPlaceToFirestore,
              child: Text('Add Selected Place to Firestore'),
            ),
          ],
        ),
      ),
    );
  }
}