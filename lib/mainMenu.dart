import 'package:flutter/material.dart';
import 'festivals.dart';
import 'notification.dart';
import 'user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login.dart';
import 'Api.dart';

ApiService api = new ApiService();

class UserMenu extends StatefulWidget {
  @override
  userPageMenu createState() => userPageMenu();
}

class userPageMenu extends State<UserMenu> {
  @override
  Widget build(BuildContext context) {

    _launchURL(url) async {
      try {
        await launch(url);
      }
      on Exception catch(Exception){
        print("failed to open");
      }

    }

    String dropdownValue = 'Man';
    return Scaffold(
      appBar: AppBar(
        title: Text("All Round Events"),
      ),
      body: Stack(children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: AssetImage("assets/background.jpg"),
                  fit: BoxFit.cover)),
        ),
        SingleChildScrollView(
          child: Center(
            child: Column(children: [
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.90,
                decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: FlatButton(
                  onPressed: () {

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => notificationsDemo()));
                  },
                  child: Text(
                    'Berichten',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.90,
                decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: FlatButton(
                  onPressed: () {

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => festivalDemo()));
                  },
                  child: Text(
                    'Inschrijvingen',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.90,
                decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserDemo()));
                  },
                  child: Text(
                    'Uw gegevens',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.90,
                decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: FlatButton(
                  onPressed: () {
                    _launchURL("https://all-round-events.be/html/nl/info.html");
                  },
                  child: Text(
                    'FAQ',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.90,
                decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: FlatButton(
                  onPressed: () {
                    _launchURL("https://all-round-events.be/html/nl/home.html");
                  },
                  child: Text(
                    'Website',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.90,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: TextButton(
                  onPressed: () {
                    api.logout();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginDemo()));
                  },
                  child: Text(
                    'Afmelden',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ])))
      ]),
    );
  }
}