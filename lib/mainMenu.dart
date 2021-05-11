import 'package:flutter/material.dart';
import 'festivals.dart';
import 'notification.dart';
import 'user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login.dart';
import 'Api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

bool isSet = false;
ApiService api = new ApiService();

Color color = Colors.lightGreen;
String text_for_messages = "Berichten";

MaterialPageRoute<dynamic> route(context) {
  isSet = false;
  return MaterialPageRoute(builder: (context) => notificationsDemo());
}

class UserMenu extends StatefulWidget {
  @override
  userPageMenu createState() => userPageMenu();
}

class userPageMenu extends State<UserMenu> {
  Future<bool> _onWillPop() async {
    isSet = false;
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginDemo()));
  }

  @override
  Widget build(BuildContext context) {
    _launchURL(url) async {
      try {
        await launch(url);
      } on Exception catch (Exception) {
        print("failed to open");
      }
    }

    void update() {
      api.get_news().then((news_data) => {
            storage.read(key: "news2").then((last_news_id) => {
                  setState(() {
                    if (news_data.length == 0) {
                      return;
                    }
                    int current = 0;
                    try {
                      current = int.parse(news_data[0]["id"]);
                      storage.write(key: "news2", value: current.toString());
                    } catch (e) {}
                    if (int.parse(last_news_id) < current) {
                      text_for_messages = "Nieuw Bericht!";
                      color = Colors.redAccent;
                    } else {
                      text_for_messages = "Berichten";
                      color = Colors.lightGreen;
                    }
                  })
                })
          });
    }

    if (!isSet) {
      update();
    }
    isSet = true;

    String dropdownValue = 'Man';

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text("All Round Events"),
          ),
          body: Stack(children: <Widget>[
            new Container(
              decoration: new BoxDecoration(image: new DecorationImage(image: AssetImage("assets/background.jpg"), fit: BoxFit.cover)),
            ),
            SingleChildScrollView(
                child: Center(
                    child: Column(children: [
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.90,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(context, route(context));
                  },
                  child: Text(
                    text_for_messages,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.90,
                decoration: BoxDecoration(color: Colors.lightGreen, borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => festivalDemo()));
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
                decoration: BoxDecoration(color: Colors.lightGreen, borderRadius: BorderRadius.circular(20)),
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
                decoration: BoxDecoration(color: Colors.lightGreen, borderRadius: BorderRadius.circular(20)),
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
                decoration: BoxDecoration(color: Colors.lightGreen, borderRadius: BorderRadius.circular(20)),
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
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
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
        ));
  }
}
