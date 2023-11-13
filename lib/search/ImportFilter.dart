import 'package:flutter/material.dart';
import 'package:food_marvel/search/ImportFilter1addr.dart';
import 'package:food_marvel/search/ImportFilter2FoodType.dart';
import 'package:food_marvel/search/ImportFilter3SoloPrice.dart';
import 'package:food_marvel/search/ImportFilter4Feel.dart';
import 'package:food_marvel/search/ImportFilter5Facility.dart';
import 'package:food_marvel/search/ImportFilter6SelectBtn.dart';

class FilterModal extends StatefulWidget {

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '필터',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                  Row(
                    children: [
                      TextButton(
                        child: Text('초기화', style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.deepOrange[400],
                        ),),
                        onPressed: (){
                          _resetFilters();
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          _resetFilters();
                        },
                        child: Icon(
                          Icons.refresh,
                          color: Colors.deepOrange[400],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Container(
            color: Colors.black,
            height: 3,
          ),
          FilterAddr(),
          FilterFoodtype(),
          FilterSoloPrice(),
          FilterFeel(),
          FilterFacility(),
          SizedBox(height: 30.0),
          FilterSelectBtn(
            onSearchPressed: () {
            },
            onClosePressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    Navigator.pop(context);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FilterModal();
      },
    );
  }
}
