import 'package:flutter/material.dart';

class mycontaner extends StatelessWidget {
  final icon;
  final String hintText;
  final TextInputType textInputType;
  final bool obscureText, readOnly;
  final Function onSaved;
  final TextEditingController controller;

  const mycontaner({
    Key key,
    this.icon,
    this.hintText,
    this.textInputType,
    this.obscureText = false,
    this.onSaved,
    this.controller,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        color: Colors.black38.withAlpha(150),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.3),
            spreadRadius: 0.5,
            blurRadius: 4,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        onSaved: onSaved,
        cursorColor: Colors.white,
        obscureText: obscureText,
        keyboardType: textInputType,
        readOnly: readOnly,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14.0),
            prefixIcon: Icon(
              icon,
              color: Colors.white,
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white)),
      ),
    );
  }
}
