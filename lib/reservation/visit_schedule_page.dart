import 'package:flutter/material.dart';
import 'package:food_marvel/reservation/function/FinishReservation.dart';
import 'package:food_marvel/reservation/function/getReservation.dart';
import 'package:provider/provider.dart';


class Visit_schedule_page extends StatefulWidget {
  @override
  State<Visit_schedule_page> createState() => _Visit_schedule_pageState();
}

class _Visit_schedule_pageState extends State<Visit_schedule_page> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 590,
      child: ReservationFListWidget(), // 수정
    );
  }
}