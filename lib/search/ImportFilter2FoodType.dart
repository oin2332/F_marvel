import 'package:flutter/material.dart';

class FilterFoodtype extends StatefulWidget {
  @override
  _FilterFoodtype createState() => _FilterFoodtype();
}

class _FilterFoodtype extends State<FilterFoodtype> {
  Set<String> selectedLocations = Set<String>();
  List<String> foodTypes = [
    '한식', '중식', '일식', '양식', '아시안', '분식',
    '치킨', '햄버거', '피자', '카페', '스테이크', '포장마차', '오마카세',
  ];

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
                Icon(
                  Icons.food_bank_outlined,
                  color: Colors.blue,
                ),
                SizedBox(width: 10.0,),
                Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Text(
                    '음식종류',
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
              title: Text('음식 종류 선택\n(3가지만 가능합니다.)'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  children: [
                    Wrap(
                      spacing: 30.0,
                      runSpacing: 10.0,
                      children: foodTypes.map((location) {
                        return SizedBox(
                          width: (MediaQuery.of(context).size.width - 100) / 2.5,
                          child: _buildLocationButton(context, location, tempSelectedLocations, setState),
                        );
                      }).toList(),
                    ),
                  ],
                ),
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
                        if (tempSelectedLocations.length > 3) {
                          Navigator.pop(context);
                          _showWarningDialog(context, '선택은 3가지만 가능합니다.');
                        } else {
                          Navigator.pop(context, tempSelectedLocations);
                        }
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
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}