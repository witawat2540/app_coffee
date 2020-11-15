import 'package:flutter/material.dart';

class mybutton extends StatelessWidget {
  final String text;
  final Function onTab;
  const mybutton({
    Key key, this.text, this.onTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: RaisedButton(
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0)),
        child: Text(
          "$text",
          style: TextStyle(fontSize: 20),
        ),
        onPressed:onTab,
        color: Colors.white,
        textColor: Colors.black,
      ),
      margin: EdgeInsets.symmetric(horizontal: 50),
    );
  }
}