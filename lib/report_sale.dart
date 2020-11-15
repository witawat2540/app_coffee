import 'dart:convert';

import 'package:coffee_app/service/config.dart';
import 'package:flutter/material.dart';

class Report_sale extends StatefulWidget {
  @override
  _Report_saleState createState() => _Report_saleState();
}

class _Report_saleState extends State<Report_sale> {
  double report_sum = 0;

  Future<void> get_report()async{
    var res = await connect().get("report_sale");
    setState(() {
      report_sum = int.parse(jsonDecode(res.body)['sumbill'].toString()).toDouble();
    });
  }

  @override
  void initState() {
    get_report();
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "รายงานยอดขาย",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Card(
          elevation: 20,
          color: Colors.brown,
          child: Container(
            child: Center(
              child: Text(
                'ยอดขาย : ฿ ${report_sum.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
            height: 100,
            width: 300,
            // color: Colors.brown,
          ),
        ),
      ),
    );
  }
}
