import 'package:flutter/material.dart';
import 'Api.dart';
import 'login.dart';


final myemail_controller = TextEditingController();
final mypassowrdController = TextEditingController();
final mycode_controller = TextEditingController();

class UserInitDemo extends StatefulWidget {
  @override
  userInit createState() => userInit();
}

class userInit extends State<UserInitDemo> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Wachtwoord vergeten"),
      ),
      body: Stack(children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: AssetImage("assets/background.jpg"),
                  fit: BoxFit.cover)),
        ),
        SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextField(
                  controller: myemail_controller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'email',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: ''),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextField(
                  controller: mypassowrdController,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'password',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: ''),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextField(
                  controller: mycode_controller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'toegangscode',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: ''),
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.80,
                decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: FlatButton(
                  onPressed: () {
                    ApiService api = new ApiService();
                    api.UserInit({"pass" : mypassowrdController.text, "email": mypassowrdController.text, "activation_code": mycode_controller.text});

                    showDialog(

                    ).then((value) => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginDemo()))
                    });
                  },
                  child: Text(
                    'Inschrijven',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ]))
      ]),
    );
  }
}