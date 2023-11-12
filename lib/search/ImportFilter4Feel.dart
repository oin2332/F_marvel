import 'package:flutter/material.dart';

class FilterFeel extends StatefulWidget {
  @override
  _FilterFeel createState() => _FilterFeel();
}

class _FilterFeel extends State<FilterFeel> {
  Set<String> selectedLocations = Set<String>();

  List<String> locations = ['이국적인', '소박한', '아늑한','착한가격','특별한날',
    '데이트','숨은맛집'];



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
                  'assets/main/smile-removebg-preview.png',
                  width: 30,
                  height: 30,
                  color: Colors.black,
                ),
                SizedBox(width: 3.0,),
                Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Text(
                    '분위기',
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
              title: Text('분위기 선택(3가지 까지 선택가능)'),
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
                    SizedBox(width: 10), // Add spacing between buttons
                    ElevatedButton(
                      onPressed: () {
                        if (tempSelectedLocations.length > 3) {
                          Navigator.pop(context);
                          _showWarningDialog(context, '선택은 3가지만 가능합니다.');
                        } else {
                          Navigator.pop(context, tempSelectedLocations);
                        }
                      },style: ElevatedButton.styleFrom(
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

  void _showWarningDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('갈!'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('넹 ㅜ'),
            ),
          ],
        );
      },
    );
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

