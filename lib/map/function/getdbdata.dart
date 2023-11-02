import 'package:cloud_firestore/cloud_firestore.dart';
import '../maptotal.dart';

Future<List<Place>> getData() async {
  print("Fetching data from Firestore");
  List<Place> places = [];

  try {
    CollectionReference placesCollection = FirebaseFirestore.instance.collection('son_test');
    QuerySnapshot querySnapshot = await placesCollection.get();

    querySnapshot.docs.forEach((doc) {
      String name = doc['name'];
      String address = doc['address'];
      Place place = Place(name: name, address: address, category: '');
      places.add(place);
      //print('Fetched Place: $name, $address');
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