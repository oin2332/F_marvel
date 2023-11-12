import 'package:flutter/material.dart';

class FilterAddr extends StatefulWidget {

  @override
  FilterAddrState createState() => FilterAddrState();
}

class FilterAddrState extends State<FilterAddr> {
  Set<String> selectedLocations = Set<String>();
  List<String> locations = ['서울', '경기', '인천'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              _openLocationSelection(context);
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/main/gps-removebg-preview1.png',
                  width: 30,
                  height: 30,
                  color: Colors.black,
                ),
                SizedBox(width: 3.0,),
                Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Text(
                    '지역검색',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
          Text(
            selectedLocations.isEmpty ? '미선택' : selectedLocations.join(', '),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  void _openLocationSelection(BuildContext context) {
    Set<String> tempSelectedLocations = Set<String>.from(selectedLocations);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('지역 선택'),
              content: Column(
                children: locations.map((location) {
                  return Column(
                    children: [
                      _buildLocationButton(context, location, tempSelectedLocations, setState),
                      SizedBox(height: 10.0),
                    ],
                  );
                }).toList(),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 40, right: 40),
                      ),
                      child: Text(
                        '이전',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, tempSelectedLocations);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrange[400],
                        padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 40, right: 40),
                      ),
                      child: Text(
                        '선택',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      if (value != null && value is Set<String>) {
        setState(() {
          selectedLocations = value;
        });
      }
    });
  }

  Widget _buildLocationButton(BuildContext context, String location, Set<String> tempSelectedLocations, StateSetter setState) {
    bool isSelected = tempSelectedLocations.contains(location);

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (isSelected) {
                  tempSelectedLocations.remove(location);
                } else {
                  tempSelectedLocations.add(location);
                }
              });
            },
            style: ElevatedButton.styleFrom(
              primary: isSelected ? Colors.deepOrange[400] : Colors.white54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(16),
            ),
            child: Text(
              location,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}