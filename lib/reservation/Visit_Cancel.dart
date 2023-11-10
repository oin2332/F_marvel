import 'package:flutter/material.dart';
import 'package:food_marvel/reservation/function/cancel_noshow_page.dart';
import 'package:food_marvel/reservation/function/getReservation.dart';
import 'package:provider/provider.dart';


class Visit_Cancel extends StatefulWidget {
  @override
  State<Visit_Cancel> createState() => _Visit_schedule_pageState();
}

class _Visit_schedule_pageState extends State<Visit_Cancel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 590,
      child: ReservationCListWidget(), // 수정
    );
  }
}