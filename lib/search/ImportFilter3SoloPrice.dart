import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterSoloPrice extends StatefulWidget {
  @override
  _FilterSoloPriceState createState() => _FilterSoloPriceState();
}

class _FilterSoloPriceState extends State<FilterSoloPrice> {
  String selectedPrice = '미선택';
  final NumberFormat _numberFormat = NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPriceSelectionModal(context);
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/main/won-removebg-preview.png',
                  width: 30,
                  height: 30,
                ),
                SizedBox(width: 3.0),
                Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Text(
                    '1인당 가격',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              selectedPrice,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPriceSelectionModal(BuildContext context) async {
    final selectedValue = await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return PriceSelectionModal();
      },
    );

    if (selectedValue != null) {
      setState(() {
        selectedPrice = selectedValue == 0
            ? '미선택'
            : '0 원 ~ ${_numberFormat.format(selectedValue)} 원';
      });
    }
  }
}

class PriceSelectionModal extends StatefulWidget {
  @override
  _PriceSelectionModalState createState() => _PriceSelectionModalState();
}

class _PriceSelectionModalState extends State<PriceSelectionModal> {
  int selectedPrice = 0;
  final NumberFormat _numberFormat = NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            '가격 선택: 0 ~ ${_numberFormat.format(selectedPrice)} 원',
          style: TextStyle(
            fontSize: 18,
          ),),
          Slider(
            value: selectedPrice.toDouble(),
            min: 0,
            max: 100000,
            divisions: 100,
            onChanged: (value) {
              // 슬라이더의 값을 변경할 때마다 호출되는 콜백
              setState(() {
                selectedPrice = value.round();
              });
            },
          ),
          SizedBox(height: 16.0),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, selectedPrice); // 선택된 가격을 반환
                },
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text('설정 완료',
                  style: TextStyle(
                  fontSize: 18,
                  ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}