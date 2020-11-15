import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spinner_input/spinner_input.dart';

import 'config.dart';
import 'mytextinput.dart';

class Select_product_bt extends StatefulWidget {
  @override
  _Select_product_btState createState() => _Select_product_btState();
}

class _Select_product_btState extends State<Select_product_bt> {
  double sumprice = 0;
  TextEditingController _sum = TextEditingController();
  TextEditingController _rub_monny = TextEditingController();
  TextEditingController _change = TextEditingController(text: '0');
  List<dynamic> row = [];

  Future<void> getdata() async {
    var res_sale = await connect().get("get_sale");
    var res_sum = await connect().get("sum_qty");

    setState(() {
      row = jsonDecode(res_sale.body);
      sumprice = int.parse(jsonDecode(res_sum.body)['sum_price']).toDouble();
      _sum.text = sumprice.toStringAsFixed(2).toString();
    });
  }

  set_monny(int monny) {
    setState(() {
      _rub_monny.text = monny.toString();
      _change.text = (monny - sumprice).toString();
    });
  }

  update_qty(qty, id) async {
    await connect().put('update_qty', jsonEncode({'qty': qty, 'id': id}));
    getdata();
    //print(int.parse(_rub_monny.text)-sumprice);
  }

  delete_sale(id)async{
     await connect().delete('delete_sale/$id');
     getdata();
  }


  end_sale()async{
    List<Map<String,dynamic>> detail = [];

    for(var item in row){
      detail.add({
        'id_product':item['id'],
        'price':item['price'],
        'qty':item['qty']
      });
    }
    Map<String,dynamic> product = {
      'sumbill':sumprice.toInt(),
      "detail":detail
    };
    await connect().post('endsale', jsonEncode(product));
    Navigator.pop(context);
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 50,
              child: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  "ตะกร้าสินค้า",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Column(
                children: row
                    .map((e) => Card(
                          elevation: 10,
                          child: ListTile(
                            leading: SpinnerInput(
                              spinnerValue:
                                  int.parse(e['qty'].toString()).toDouble(),
                              minValue: 1,
                              onChange: (newvalue) {

                                update_qty(newvalue,e['id']);
                                setState(() {});
                              },
                            ),
                            title: Text('${e['name']} = ฿ ${e['sumprice']}'),
                            trailing: IconButton(
                              onPressed: () =>delete_sale(e['id']),
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ))
                    .toList()),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 400,
              color: Colors.brown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  label("ราคา"),
                  mycontaner(
                    controller: _sum,
                    readOnly: true,
                    hintText: "ราคา",
                    icon: Icons.attach_money,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  label("จ่าย"),
                  mycontaner(
                    controller: _rub_monny,
                    hintText: "จ่าย",
                    textInputType: TextInputType.number,
                    icon: Icons.attach_money,
                    //controller: _sum,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  label("เงินทอน"),
                  mycontaner(
                    controller: _change,
                    hintText: "เงินทอน",
                    readOnly: true,
                    textInputType: TextInputType.number,
                    icon: Icons.attach_money,
                    //controller: _sum,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      my_button_end_sale(
                        color: Colors.green,
                        text: '฿ 20',
                        ontab: sumprice > 20 ? null : () => set_monny(20),
                      ),
                      my_button_end_sale(
                        color: Colors.redAccent,
                        text: '฿ 100',
                        ontab: sumprice > 100 ? null : () => set_monny(100),
                      ),
                      my_button_end_sale(
                        color: Colors.deepPurple,
                        text: '฿ 500',
                        ontab: sumprice > 500 ? null : () => set_monny(500),
                      ),
                      my_button_end_sale(
                        color: Colors.grey,
                        text: '฿ 1000',
                        ontab: sumprice > 1000 ? null : () => set_monny(100),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: my_button_end_sale(
                      color: Colors.redAccent,
                      text: 'จบการขาย',
                      ontab: () =>end_sale(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  label(text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 50,
          ),
          Text(
            "$text",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class my_button_end_sale extends StatelessWidget {
  final String text;
  final Function ontab;
  final Color color;

  const my_button_end_sale({
    Key key,
    this.text,
    this.ontab,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: ontab,
      child: Text(text),
      textColor: Colors.white,
      color: color,
    );
  }
}
