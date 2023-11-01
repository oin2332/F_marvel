import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: DataEntryForm(),
  ));
}
class DataEntryForm extends StatefulWidget {
  const DataEntryForm({super.key});

  @override
  State<DataEntryForm> createState() => _DataEntryFormState();
}

class _DataEntryFormState extends State<DataEntryForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  // Firestore 인스턴스 생성
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveDataToFirestore(String name, String address, String category) async {
    try {
      // Firestore에 데이터 추가
      await _firestore.collection('son_test').add({
        'name': name,
        'address': address,
        'category': category,
      });
    } catch (e) {
      // 에러 처리
      print('Error saving data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Material(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: '이름'),
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: '주소'),
              ),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: '카테고리'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  String name = _nameController.text;
                  String address = _addressController.text;
                  String category = _categoryController.text;

                  // Firestore에 데이터 저장
                  await saveDataToFirestore(name, address, category);

                  // Bottom Sheet 닫기
                  Navigator.of(context).pop();
                },
                child: Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}