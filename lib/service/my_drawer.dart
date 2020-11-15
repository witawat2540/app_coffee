import 'package:coffee_app/report_sale.dart';
import 'package:flutter/material.dart';

import 'MyWidget.dart';

class mydrawer extends StatelessWidget {
  const mydrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.brown),
            child: Center(
              child: Text("ระบบร้านกาแฟ",
                  style: TextStyle(fontSize: 40, color: Colors.white)),
            ),
          ),
          ListTile(
            title: Text(
              "สินค้า",
              style: TextStyle(fontSize: 20),
            ),
            leading: Icon(Icons.monetization_on),
          ),
          My_widget.line(),
          ListTile(
            onTap: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => Report_sale(),));
            },
            title: Text(
              "รายงานยอดขาย",
              style: TextStyle(fontSize: 20),
            ),
            leading: Icon(Icons.restore_page),
          ),
          My_widget.line(),
          ListTile(
            title: Text(
              "รายงานกำไร",
              style: TextStyle(fontSize: 20),
            ),
            leading: Icon(Icons.monetization_on),
          ),
          My_widget.line(),
        ],
      ),
    );
  }
}