import 'dart:convert';

import 'package:coffee_app/service/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'service/Select_product_bt.dart';
import 'service/my_drawer.dart';

class SalePage extends StatefulWidget {
  @override
  _SalePageState createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  int counter = 0;
  double sumprice = 0;
  List<dynamic> row = [];

  Future<void> getdata() async {
    var res = await connect().get('get_product');

    setState(() {
      row = jsonDecode(res.body);
    });
    print(row);
    var res_sum = await connect().get('sum_qty');
    setState(() {
      counter = int.parse(jsonDecode(res_sum.body)['sum_qty']);
      sumprice = int.parse(jsonDecode(res_sum.body)['sum_price']).toDouble();
    });
  }

  add_sale(Map<String, dynamic> row) async {
    var res = await connect().post(
        "add_sale",
        jsonEncode(
            {'name': row['name'], 'price': row['price'], 'id': row['id']}));
    var res_sum = await connect().get('sum_qty');
    setState(() {
      counter = int.parse(jsonDecode(res_sum.body)['sum_qty']);
      sumprice = int.parse(jsonDecode(res_sum.body)['sum_price']).toDouble();
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => show_model(),
          child: counter != 0
              ? Stack(
                  children: <Widget>[
                    new IconButton(
                        icon: Icon(Icons.local_mall),
                        onPressed: () {
                          show_model();
                        }),
                    new Positioned(
                      right: 7,
                      top: 7,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '$counter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                )
              : Icon(Icons.local_mall)),
      drawer: mydrawer(),
      appBar: AppBar(
        title: Text(
          "ระบบร้านกาแฟ",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            width: 150,
            child: Text(
              "฿ ${sumprice.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
      body: row.length == 0
          ? Container()
          : GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                  row.length,
                  (index) => InkWell(
                        onTap: () {
                          add_sale(row[index]);
                          /*setState(() {
                      counter ++;
                    });*/
                        },
                        child: Card(
                          margin: EdgeInsets.all(10),
                          color: Colors.black38.withOpacity(0.4),
                          child: GridTile(
                            child: Container(
                              child: Center(
                                child: Icon(
                                  Icons.fastfood,
                                  size: 100,
                                ),
                              ),
                            ),
                            footer: Container(
                                color: Colors.brown,
                                height: 40,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("${row[index]["name"]}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white)),
                                          Text("฿ ${row[index]['price']}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
//                      title: Center(
//                        child: Text("กาแฟ", style: TextStyle(fontSize: 20)),
//                      ),
//                      subtitle: Center(
//                        child: Text("price ฿ 10.00"),
//                      ),
                          ),
                        ),
                      )),
            ),
    );
  }

  show_model() {
    /*setState(() {
      counter = 0;
    });*/
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Select_product_bt(),
    ).then((value) => getdata());
  }
}
