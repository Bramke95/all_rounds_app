import 'package:flutter/material.dart';
import 'Api.dart';
import 'login.dart';

final myemail_controller = TextEditingController();

class passforgetDemo extends StatefulWidget {
  @override
  PassForget createState() => PassForget();
}

class PassForget extends State<passforgetDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wachtwoord vergeten"),
      ),
      body: Stack(children: <Widget>[
        new Container(
          decoration: new BoxDecoration(image: new DecorationImage(image: AssetImage("assets/background.jpg"), fit: BoxFit.cover)),
        ),
        SingleChildScrollView(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: myemail_controller,
              decoration: InputDecoration(
                  fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: 'email', labelStyle: TextStyle(color: Colors.black), hintText: ''),
            ),
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.80,
            decoration: BoxDecoration(color: Colors.lightGreen, borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: FlatButton(
              onPressed: () {
                ApiService api = new ApiService();
                api.PassReset(myemail_controller.text);
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context),
                ).then((value) => {Navigator.push(context, MaterialPageRoute(builder: (context) => LoginDemo()))});
              },
              child: Text(
                'Verstuur',
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
    title: const Text('Verstuurd'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Uw aanvraag is verstuurd, check je mailbox! "),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Sluit'),
      ),
    ],
  );
}
