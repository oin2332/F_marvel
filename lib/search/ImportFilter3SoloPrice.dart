import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterSoloPrice extends StatefulWidget {
  @override
  _FilterSoloPriceState createState() => _FilterSoloPriceState();
}

class _FilterSoloPriceState extends State<FilterSoloPrice> {
  String selectedPrice = '미선택';
  TextEditingController priceController = TextEditingController();
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
        return PriceSelectionModal(priceController: priceController);
      },
    );

    if (selectedValue != null) {
      if (selectedValue > 300000) {
        _showAlertDialog(context); // 300,000을 초과하는 경우 알림 띄우기
      } else {
        setState(() {
          selectedPrice = selectedValue == 0
              ? '미선택'
              : '0 원 ~ ${_numberFormat.format(selectedValue)} 원';
        });
      }
    }
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text('가격은 300,000 원을 초과할 수 없습니다. 초기화합니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 알림 창 닫기
                priceController.text = ''; // 입력값 초기화
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}

class PriceSelectionModal extends StatefulWidget {
  final TextEditingController priceController;

  PriceSelectionModal({required this.priceController});

  @override
  _PriceSelectionModalState createState() => _PriceSelectionModalState();
}

class _PriceSelectionModalState extends State<PriceSelectionModal> {
  int selectedPrice = 0;
  final NumberFormat _numberFormat = NumberFormat("#,###");
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '가격 선택: 0 ~ ${_numberFormat.format(selectedPrice)} 원 (최대 300.000만원)',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Slider(
            value: selectedPrice.toDouble(),
            min: 0,
            max: 300000,
            divisions: 100,
            onChanged: (value) {
              setState(() {
                selectedPrice = value.round();
              });
              widget.priceController.text = selectedPrice == 0
                  ? ''
                  : _numberFormat.format(selectedPrice);
            },
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: widget.priceController,
            focusNode: _focusNode,
            keyboardType: TextInputType.number,
            onTap: () {
              // 포커스가 변경되면서 초기화
              widget.priceController.text = '';
            },
            onChanged: (value) {
              int enteredValue = int.tryParse(value) ?? 0;

              // 허용 범위를 벗어나면 300,000으로 고정
              if (enteredValue > 300000) {
                setState(() {
                  enteredValue = 300000;
                });
                widget.priceController.text = _numberFormat.format(enteredValue);
              } else {
                setState(() {
                  selectedPrice = enteredValue;
                });
              }
            },
            decoration: InputDecoration(
              labelText: '직접 입력',
              suffixText: '원',
            ),
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
                  child: Text(
                    '설정 완료',
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