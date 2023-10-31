import 'package:flutter/material.dart';
import 'package:food_marvel/map/circleboundary.dart';
import 'package:food_marvel/map/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class Place {
  final String name;
  final String address;
  final Future<LatLng?> location; // 위치를 비동기로 받음

  Place({required this.name, required this.address})
      : location = getLocationFromAddress(address);
}

List<Place> places = [
  Place(name: '칸다소바', address: '인천 부평구 부평대로36번길 5'),
  Place(name: '인브스키친', address: '인천 부평구 부평대로 39-6'),
  Place(name: '에픽', address: '인천 부평구 경원대로1363번길 8'),
  Place(name: '크라이치즈버거', address: '경기도 부천시 원미구 심곡2동 신흥로52번길 35'),
  Place(name: '타키', address: '인천광역시 서구 신석로77번길 12'),
  // 다른 더미 데이터들도 동일한 방식으로 추가할 수 있음
];

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  LatLng _center = LatLng(37.4895, 126.7220); // 초기 지도 중심 좌표 및 확대 수준 설정
  double _zoomLevel = 14.0; // 줌 레벨 변수 추가 및 초기값 설정

  Set<Marker> _markers = {};
  Set<Circle> _circles = {}; // 원을 표시하기 위한 Set 변수 추가

  String _searchQuery = ""; // 검색어를 저장할 변수
  String _selectedCategory = ''; // 선택된 카테고리를 저장하는 변수

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentMyLocation(); // Get current location when the app starts
    _addMarkers();
  }

  Future<void> _addMarkers() async {
    for (var place in places) {
      LatLng? location = await place.location;
      if (location != null) {
        _markers.add(
          Marker(
            markerId: MarkerId(place.name),
            position: location,
            infoWindow: InfoWindow(
              title: place.name,
              snippet: place.address,
            ),
          ),
        );
      }
    }
    setState(() {}); // 마커를 추가한 후 화면을 갱신하여 지도에 마커를 표시
  }

  // 검색어를 사용하여 장소를 필터링하는 함수
  void _filterPlaces(String query) {
    setState(() {
      _searchQuery = query;
      _addMarkers(); // 검색어가 변경될 때마다 장소를 다시 필터링하여 마커를 추가합니다.
    });
  }

  Future<void> _getCurrentMyLocation() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        LatLng myLocation = LatLng(position.latitude, position.longitude);

        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: myLocation,
              zoom: 17.0, // 현재 줌 레벨 사용
            ),
          ),
        );

        // 추가: 사용자의 위치를 마커로 표시
        _markers.add(
          Marker(
            markerId: MarkerId('my_location'),
            position: myLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue), // 파란색 마커 아이콘 사용
            infoWindow: InfoWindow(
              title: 'My Location',
              snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
            ),
          ),
        );

        // 사용자 위치 주변에 원을 표시
        Circle circleBoundary =
            getCircleBoundary(myLocation, 200); // 반지름 2000m의 원
        _circles.clear(); // 원을 추가하기 전에 기존 원을 지움
        _circles.add(circleBoundary);

        setState(() {}); // 위젯을 리빌드하여 마커를 지도에 표시
      } catch (e) {
        print('Error: $e');
      }
    } else {
      // 위치 권한이 거부된 경우
      print('User denied permissions to access the device\'s location.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: _zoomLevel,
              ),
              markers: _markers,
              circles: _circles,
            ),
            Positioned(
              top: 50.0,
              left: 0.0,
              right: 20.0,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          // 뒤로가기 버튼을 눌렀을 때 수행할 동작을 구현하세요.
                        },
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: TextField(
                            onChanged: _filterPlaces,
                            decoration: InputDecoration(
                              hintText: '장소 검색...',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(8.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0), // 간격 추가

                  // 카테고리 버튼들
                  // 카테고리 버튼들을 스크롤 가능하게 만듭니다.
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Row(
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedCategory = '한식';
                              });
                            },
                            child: Text(
                              '한식',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400
                              ), // 텍스트 색상을 검은색으로 설정
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white, // 버튼 배경색을 흰색으로 설정
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0), // 버튼 모서리를 더 둥글게 만듭니다.
                                side: BorderSide(color: Colors.grey), // 버튼 테두리를 회색으로 설정
                              ),
                              elevation: 5, // 그림자 효과를 추가합니다.
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 버튼 내부 패딩을 조절합니다.
                            ),
                          ),
                          SizedBox(width: 10.0), // 버튼 간의 간격을 조절합니다.
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedCategory = '중식';
                              });
                            },
                            child: Text(
                              '중식',
                              style: TextStyle(color: Colors.black), // 텍스트 색상을 검은색으로 설정
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white, // 버튼 배경색을 흰색으로 설정
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0), // 버튼 모서리를 더 둥글게 만듭니다.
                                side: BorderSide(color: Colors.grey), // 버튼 테두리를 회색으로 설정
                              ),
                              elevation: 5, // 그림자 효과를 추가합니다.
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 버튼 내부 패딩을 조절합니다.
                            ),
                          ),
                          SizedBox(width: 10.0), // 버튼 간의 간격을 조절합니다.
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedCategory = '일식';
                              });
                            },
                            child: Text(
                              '일식',
                              style: TextStyle(color: Colors.black), // 텍스트 색상을 검은색으로 설정
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white, // 버튼 배경색을 흰색으로 설정
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0), // 버튼 모서리를 더 둥글게 만듭니다.
                                side: BorderSide(color: Colors.grey), // 버튼 테두리를 회색으로 설정
                              ),
                              elevation: 5, // 그림자 효과를 추가합니다.
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 버튼 내부 패딩을 조절합니다.
                            ),
                          ),
                          SizedBox(width: 10.0), // 버튼 간의 간격을 조절합니다.
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedCategory = '카페';
                              });
                            },
                            child: Text(
                              '카페',
                              style: TextStyle(color: Colors.black), // 텍스트 색상을 검은색으로 설정
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white, // 버튼 배경색을 흰색으로 설정
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0), // 버튼 모서리를 더 둥글게 만듭니다.
                                side: BorderSide(color: Colors.grey), // 버튼 테두리를 회색으로 설정
                              ),
                              elevation: 5, // 그림자 효과를 추가합니다.
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 버튼 내부 패딩을 조절합니다.
                            ),
                          ),
                          SizedBox(width: 10.0), // 버튼 간의 간격을 조절합니다.
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedCategory = '포장마차';
                              });
                            },
                            child: Text(
                              '포장마차',
                              style: TextStyle(color: Colors.black), // 텍스트 색상을 검은색으로 설정
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white, // 버튼 배경색을 흰색으로 설정
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0), // 버튼 모서리를 더 둥글게 만듭니다.
                                side: BorderSide(color: Colors.grey), // 버튼 테두리를 회색으로 설정
                              ),
                              elevation: 5, // 그림자 효과를 추가합니다.
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 버튼 내부 패딩을 조절합니다.
                            ),
                          ),
                          SizedBox(width: 10.0), // 버튼 간의 간격을 조절합니다.
                        ],

                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _getCurrentMyLocation,
          child: Icon(Icons.my_location),
          backgroundColor: Colors.blue[700],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
