import 'package:flutter/material.dart';
import 'Api.dart';
import 'login.dart';
import 'user.dart';

List festivals = [];
List shifts = [];
List shiftDays = [];
bool isSet = false;
ApiService api = new ApiService();
class festivalDemo extends StatefulWidget {
  @override
  userInit createState() => userInit();
}

class userInit extends State<festivalDemo> {
  @override
  Widget build(BuildContext context) {
    if (!isSet) {
      api.getFestivals().then((value1) =>
      {
        api.getshifts().then((value2) =>
        {
          api.GetShiftDays().then((value3) =>
          {
            setState(() {
              festivals = value1;
              shifts = value2;
              shiftDays = value3;
              for (var j = 0; j < festivals.length; j++) {
                for (var i = 0; i < shifts.length; i++) {
                  if (festivals[j]["shifts"] == null) {
                    festivals[j]["shifts"] = [];
                  }
                  if (shifts[i]["festival_idfestival"] == festivals[j]["idfestival"]) {
                    festivals[j]["shifts"].add(shifts[i]);
                  }
                }
                for (var h = 0; h < festivals[j]["shifts"].length; h++) {
                  for (var k = 0; k < shiftDays.length; k++) {
                    if (festivals[j]["shifts"][h]["idshifts"] == shiftDays[k]["idshifts"]) {
                      if (festivals[j]["shifts"][h]["shift_days"] == null || festivals[j]["shifts"] == null) {
                        festivals[j]["shifts"][h]["shift_days"] = [];
                      }
                      try {
                        festivals[j]["shifts"][h]["shift_days"].add(shiftDays[k]);
                      }
                      catch (e) {
                        print("fail");
                      }
                    }
                  }
                }
              }
              // add days to shift
            })
          })
        })
      });
      isSet = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Inschrijvingen"),
      ),
      body: Stack(children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: AssetImage("assets/background.jpg"),
                  fit: BoxFit.cover)),
        ),
        SingleChildScrollView(

          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: festivals.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int blockIdx) {
              return new Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.72)),
                    child: Column(
                    children: [
                      Center(
                        child: Text(
                            festivals[blockIdx]["name"].toString(),
                          style: TextStyle(color: Colors.black, fontSize: 30, decoration: TextDecoration.underline),
                        ),
                      ),
                      Center(
                        child: Text(
                        festivals[blockIdx]["date"].toString() + " " +festivals[blockIdx]["details"].toString(),
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                      ]
                      ),
                      padding: EdgeInsets.all(8.0)),

                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: festivals[blockIdx]["shifts"].length,
                      itemBuilder: (BuildContext context, int childIdx) {
                        print("Building block $blockIdx child $childIdx");
                        String text = "";
                        if (festivals[blockIdx]["shifts"].length > 0) {
                          text = festivals[blockIdx]["shifts"][childIdx]["name"].toString() + ":";
                        }
                        return Container(
                            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.72)),
                            margin: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),

                          child: Column(children: [
                            Align(

                              alignment: Alignment.centerLeft,
                            child : Text(
                                text,
                              style: TextStyle(color: Colors.black, fontSize: 25),
                            ),
                            ),
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.95,
                              decoration: BoxDecoration(
                                  color: Colors.lightGreen,
                                  borderRadius: BorderRadius.circular(20)),
                              margin: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                              child: FlatButton(
                                onPressed: () {
                                },
                                child: Text(
                                  'Inschrijven',
                                  style: TextStyle(color: Colors.white, fontSize: 25),
                                ),
                              ),
                            ),
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: festivals[blockIdx]["shifts"][childIdx]["shift_days"].length,
                              itemBuilder: (BuildContext context, int childIdxx) {
                                String start = "";
                                String end = "";
                                String cost = "";
                                if (festivals[blockIdx]["shifts"][childIdx]["shift_days"].length > 0) {
                                  start = "Start: " +festivals[blockIdx]["shifts"][childIdx]["shift_days"][childIdxx]["start_date"].toString();
                                }
                                if (festivals[blockIdx]["shifts"][childIdx]["shift_days"].length > 0) {
                                  end = "Einde: " +festivals[blockIdx]["shifts"][childIdx]["shift_days"][childIdxx]["shift_end"].toString();
                                }
                                if (festivals[blockIdx]["shifts"][childIdx]["shift_days"].length > 0) {
                                  cost = festivals[blockIdx]["shifts"][childIdx]["shift_days"][childIdxx]["cost"].toString();
                                }
                                return Container(
                                    decoration: BoxDecoration(color: Colors.lightBlueAccent, border: Border.all(color: Colors.black), borderRadius: BorderRadius.all(Radius.circular(10))),
                                    margin: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                                    child: Column(children: [
                                      Text(
                                        "dag "  + (childIdxx + 1).toString() + "(€"+ cost +")",
                                        style: TextStyle(color: Colors.black, fontSize: 20),
                                      ),
                                      Text(
                                        start,
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      Text(
                                        end,
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                    ]
                                    )
                                );
                              },
                            )
                        ]
                          )
                        );
                      },
                    )
                ],
              );
            },
          )
        )
      ]),
    );
  }
}
