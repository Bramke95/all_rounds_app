import 'package:flutter/material.dart';
import 'Api.dart';
import 'passforget.dart';
import 'userinit.dart';
import 'mainMenu.dart';

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

final myUser_controller = TextEditingController();
final myPass_controller = TextEditingController();
String error_text = "";
bool autolog_try = false;

class _LoginDemoState extends State<LoginDemo> {
  @override
  Widget build(BuildContext context) {
    // try to use the stored token to login, this prevents the user from logging in every time
    if (!autolog_try) {
      ApiService login = new ApiService();
      login.autoApiLogin().then((bool is_auth) {
        if (is_auth) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserMenu()));
        }
      });
      autolog_try = true;
    }

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        centerTitle: true,
        title: Text("All Round Events ", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.cyan,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/background.jpg"), fit: BoxFit.cover),
        ),
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "$error_text",
                  style: TextStyle(
                      background: Paint()
                        ..color = Colors.red
                        ..strokeWidth = 17
                        ..style = PaintingStyle.stroke),
                )),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: myUser_controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: 'voorbeeld@email.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: myPass_controller,
                obscureText: true,
                decoration: InputDecoration(
                    fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: 'Wachtwoord', labelStyle: TextStyle(color: Colors.black), hintText: ''),
              ),
            ),
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width * 0.45,
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              decoration: BoxDecoration(color: Colors.lightGreen, borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => passforgetDemo()));
                },
                child: Text('Wachtwoord vergeten?', style: TextStyle(backgroundColor: Colors.lightGreen, color: Colors.red, fontSize: 10)),
              ),
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.80,
              decoration: BoxDecoration(color: Colors.lightGreen, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    error_text = "";
                  });
                  ApiService login = new ApiService();
                  login.ApiLogin([myUser_controller.text, myPass_controller.text]).then((List res) {
                    if (res[0] == "") {
                      setState(() {
                        error_text = res[1];
                      });
                    } else {
                      // token is set, move to other page
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserMenu()));
                    }
                  });
                },
                child: Text(
                  'Inloggen',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.80,
              margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserInitDemo()));
                },
                child: Text(
                  'Registeren',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}
