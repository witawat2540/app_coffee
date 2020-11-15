import 'dart:convert';

import 'package:coffee_app/salepage.dart';
import 'package:coffee_app/service/MyWidget.dart';
import 'package:coffee_app/service/config.dart';
import 'package:coffee_app/service/mybutton.dart';
import 'package:coffee_app/service/mytextinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController _user = TextEditingController();
  TextEditingController _password = TextEditingController();
  Map<String, dynamic> user;

  Future<void> Login() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (_user.text.isEmpty || _password.text.isEmpty) {
      My_widget.showInSnackBar(
          "กรุณากรอกข้อความ", Colors.white, _scaffoldkey, Colors.red, 4);
    } else {
      var results = await connect().post("login",
          jsonEncode({'user': _user.text, 'password': _password.text}));
      if (jsonDecode(results.body)['status'] == 'pass') {
        Map<String, dynamic> row = jsonDecode(results.body)["data"][0];
        setState(() {});
        user = {'user': _user.text, 'level': row["level"], 'name': row['name']};
        preferences.setString("user", jsonEncode(user));
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => SalePage(),
            ));
      } else {
        My_widget.showInSnackBar(
            "รหัสผ่านไม่ถูกต้อง", Colors.white, _scaffoldkey, Colors.red, 4);
      }
    }
  }

  get_user() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      setState(() {
        user = jsonDecode(preferences.getString('user'));
      });
    } catch (err) {}

    user == null
        ? print(" not login")
        : Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => SalePage(),
            ));
  }

  @override
  void initState() {
    get_user();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.6), BlendMode.dstATop),
                      image: NetworkImage(
                          'https://c1.wallpaperflare.com/preview/146/758/422/wall-coffee-coffee-shop-counter.jpg'))),
            ),
            Positioned(
              child: Align(
                alignment: Alignment.center,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Center(
                      child: Text(
                        "ระบบร้านกาแฟ",
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    mycontaner(
                      controller: _user,
                      icon: Icons.supervised_user_circle_outlined,
                      hintText: "UserName",
                      textInputType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    mycontaner(
                      controller: _password,
                      icon: Icons.lock_rounded,
                      obscureText: true,
                      hintText: "Password",
                      textInputType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    mybutton(
                      text: 'Login',
                      onTab: () => Login(),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
