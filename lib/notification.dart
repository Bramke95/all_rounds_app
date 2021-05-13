import 'dart:async';
import 'mainMenu.dart';
import 'package:flutter/material.dart';
import 'Api.dart';
import 'package:flutter_html/flutter_html.dart';

List notifications_list = [];
Timer timer;
bool isSet = false;
ApiService api = new ApiService();

class notificationsDemo extends StatefulWidget {
  @override
  notifications createState() => notifications();
}

class notifications extends State<notificationsDemo> {
  Future<bool> _onWillPop() async {
    isSet = false;
    timer.cancel();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserMenu()));
  }

  @override
  Widget build(BuildContext context) {
    void update() {
      api.get_news().then((value) => {
            setState(() {
              notifications_list = value;
              if (notifications_list.length < 1) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context),
                ).then((value) => {_onWillPop()});
              }
            })
          });
    }

    if (!isSet) {
      update();
      timer = new Timer(new Duration(seconds: 60), () {
        update();
      });
      isSet = true;
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Berichten"),
          ),
          body: Stack(children: [
            new Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: AssetImage("assets/background.jpg"),
                      fit: BoxFit.cover)),
            ),
            SingleChildScrollView(
                child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: notifications_list.length,
              itemBuilder: (BuildContext context, int x) {
                return Container(
                    margin: const EdgeInsets.only(
                        left: 12, right: 12, top: 8, bottom: 8),
                    child: Column(children: [
                      CustomPaint(
                          painter: CustomChatBubble(isOwn: false),
                          child: Container(
                              padding: EdgeInsets.all(8),
                              child: Column(children: [
                                Html(
                                    data: notifications_list[x]
                                        ["notification"]),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    notifications_list[x]["data"],
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              ])))
                    ]));
              },
            ))
          ]),
        ));
  }
}

class CustomChatBubble extends CustomPainter {
  CustomChatBubble({this.color, @required this.isOwn});

  final Color color;
  final bool isOwn;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color ?? Colors.redAccent;

    Path paintBubbleTail() {
      Path path;
      if (!isOwn) {
        path = Path()
          ..moveTo(5, size.height - 5)
          ..quadraticBezierTo(-5, size.height, -16, size.height - 4)
          ..quadraticBezierTo(-5, size.height - 5, 0, size.height - 17);
      }
      if (isOwn) {
        path = Path()
          ..moveTo(size.width - 6, size.height - 4)
          ..quadraticBezierTo(
              size.width + 5, size.height, size.width + 16, size.height - 4)
          ..quadraticBezierTo(
              size.width + 5, size.height - 5, size.width, size.height - 17);
      }
      return path;
    }

    final RRect bubbleBody = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(16));
    final Path bubbleTail = paintBubbleTail();

    canvas.drawRRect(bubbleBody, paint);
    canvas.drawPath(bubbleTail, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Berichten'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Er zijn geen berichten op dit moment, kom later een keer terug!"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Terug'),
      ),
    ],
  );
}
