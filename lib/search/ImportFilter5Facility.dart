import 'package:flutter/material.dart';

class FilterFacility extends StatefulWidget {
  @override
  _FilterFacility createState() => _FilterFacility();
}

class _FilterFacility extends State<FilterFacility> {
  Set<String> selectedLocations = Set<String>();
  List<String> facilityTypes = [
    '포장', '키즈존', 'NO키즈존', '1층', '승강기', '화장실',
    '주차장', '단체', '계단없음',
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
                Image.asset(
                  'assets/main/sofa-removebg-preview.png',
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 3.0,),
                Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Text(
                    '편의시설',
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
            selectedLocations.isEmpty
                ? '미선택'
                : selectedLocations.join(', ').length <= 25
                ? selectedLocations.join(', ')
                : selectedLocations.join(', ').substring(0, 25) + '...',
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
              title: Text('편의시설'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  children: [
                    Wrap(
                      spacing: 30.0,
                      runSpacing: 10.0,
                      children: facilityTypes.map((location) {
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
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}