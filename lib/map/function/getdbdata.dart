import 'package:cloud_firestore/cloud_firestore.dart';
import '../maptotal.dart';

Future<List<Place>> getData() async {
  print("Fetching data from Firestore");
  List<Place> places = [];

  try {
    CollectionReference placesCollection = FirebaseFirestore.instance.collection('T3_STORE_TBL');
    QuerySnapshot querySnapshot = await placesCollection.get();

    querySnapshot.docs.forEach((doc) {
      String name = doc['S_NAME'] ?? ''; // null 체크 및 기본값 설정

      // 데이터를 가져오고 null 체크
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // 필드가 존재하는지 확인하고 데이터 가져오기
      String address = '';
      if (data.containsKey('S_ADDR1')) {
        address += data['S_ADDR1'] ?? '';
      }
      if (data.containsKey('S_ADDR2')) {
        if (address.isNotEmpty) {
          address += ' ';
        }
        address += data['S_ADDR2'] ?? '';
      }
      if (data.containsKey('S_ADDR3')) {
        if (address.isNotEmpty) {
          address += ' ';
        }
        address += data['S_ADDR3'] ?? '';
      }

      // 데이터가 유효한지 확인 후 객체 생성
      if (name.isNotEmpty && address.isNotEmpty) {
        Place place = Place(name: name, address: address, category: '');
        places.add(place);
      }
    });
  } catch (e) {
    print('Error fetching data: $e');
  }

  return places;
}


//
// Future<void> saveDataToFirestore(String name, String address, String category) async {
//   CollectionReference placesCollection = FirebaseFirestore.instance.collection('son_test').doc("store1").collection('places');
//
//   await placesCollection.add({
//     'name': name,
//     'address': address,
//     'category': category,
//   });
//
//   print('Place added to Firestore: $name, $address, $category');
// }