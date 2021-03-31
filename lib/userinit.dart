import 'package:flutter/material.dart';
import 'Api.dart';
import 'login.dart';
import 'user.dart';


final myemail_controller = TextEditingController();
final mypassowrdController = TextEditingController();
final mycode_controller = TextEditingController();
String error_text = "";
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
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "$error_text",
                    style: TextStyle(
                        background: Paint()
                          ..color = Colors.red
                          ..strokeWidth = 25
                          ..style = PaintingStyle.stroke),
                  )),
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
                  obscureText: true,
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
                    api.UserInit({"pass" : mypassowrdController.text, "email": myemail_controller.text, "activation_code": mycode_controller.text}).then((value){
                      if (value["status"] == 409){
                        setState(() {
                          error_text="Toegangscode was niet geldig.";
                        });
                      }
                      else if (value["status"] == 480){
                        setState(() {
                        error_text="Email al in gebruik, gelieve in te loggen.";
                        });
                      }
                      else if (value["status"] == 481){
                        setState(() {
                        error_text="Wachtwoord te kort!";
                        });
                      }
                      else {
                        showDialog(
                        context: context,
                        builder: (BuildContext context) => _buildPopupDialog(context),
                    ).then((value) => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => UserDemo()))
                    });
                          }
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

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Doorgaan'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Uw acound is aangemaakt, vul uw gegevens verder aan"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Doorgaan'),
      ),
    ],
  );
}
