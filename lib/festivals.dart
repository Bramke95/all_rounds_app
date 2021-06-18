import 'dart:async';
import 'package:all_round_events/login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'mainMenu.dart';
import 'package:flutter/material.dart';
import 'Api.dart';
import 'picture.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
List festivals = [];
List shifts = [];
List shiftDays = [];
List workDays = [];
bool isSet = false;
ApiService api = new ApiService();
Timer timer;
final storage = new FlutterSecureStorage();

class festivalDemo extends StatefulWidget {
  @override
  userInit createState() => userInit();
}

void back(context) {
  timer.cancel();
  Navigator.push(context, MaterialPageRoute(builder: (context) => UserMenu()));
  isSet = false;
}

class userInit extends State<festivalDemo> {
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
      festivals = [];
      shifts = [];
      shiftDays = [];
      workDays = [];
      api.getFestivals().then((value1) => {
            api.getshifts().then((value2) => {
                  api.GetShiftDays().then((value3) => {
                        api.GetShiftWorkDays().then((value4) => {
                              setState(() {
                                festivals = value1;
                                if (festivals.length < 1) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog(context),
                                  ).then((value) => {back(context)});
                                }
                                shifts = value2;
                                shiftDays = value3;
                                workDays = value4;
                                try {
                                  if (shifts[0] == "restart") {
                                    timer.cancel();
                                    isSet = false;
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => LoginDemo()));
                                  }
                                } catch (e) {}
                                try {
                                  if (workDays[0] == "picture") {
                                    // token is invalid
                                    workDays = [];

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildPopupDialog2(context),
                                    ).then((value) => {back(context)});
                                  }
                                } catch (e) {}
                                for (var j = 0; j < festivals.length; j++) {
                                  for (var i = 0; i < shifts.length; i++) {
                                    if (festivals[j]["shifts"] == null) {
                                      festivals[j]["shifts"] = [];
                                    }
                                    if (shifts[i]["festival_idfestival"] ==
                                        festivals[j]["idfestival"]) {
                                      festivals[j]["shifts"].add(shifts[i]);
                                    }
                                  }
                                  for (var h = 0;
                                      h < festivals[j]["shifts"].length;
                                      h++) {
                                    for (var k = 0; k < shiftDays.length; k++) {
                                      if (festivals[j]["shifts"][h]
                                              ["idshifts"] ==
                                          shiftDays[k]["idshifts"]) {
                                        if (festivals[j]["shifts"][h]
                                                    ["shift_days"] ==
                                                null ||
                                            festivals[j]["shifts"] == null) {
                                          festivals[j]["shifts"][h]
                                              ["shift_days"] = [];
                                        }
                                        try {
                                          festivals[j]["shifts"][h]
                                                  ["shift_days"]
                                              .add(shiftDays[k]);
                                        } catch (e) {
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
        onWillPop: () {
          //trigger leaving and use own data
          Navigator.pop(context, false);
          timer.cancel();
          isSet = false;
          //we need to return a future
          return Future.value(false);
        },
        child: Scaffold(
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
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, top: 0, bottom: 0),
                        decoration:
                            BoxDecoration(color: Colors.grey.withOpacity(0.72)),
                        child: Column(children: [
                          Center(
                            child: Text(
                              festivals[blockIdx]["name"].toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          Center(
                            child: Text(
                                  festivals[blockIdx]["details"].toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ),
                        ]),
                        padding: EdgeInsets.all(8.0)),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: festivals[blockIdx]["shifts"].length,
                      itemBuilder: (BuildContext context, int childIdx) {
                        print("Building block $blockIdx child $childIdx");
                        String shift_text = "";
                        String button_text = "Inschrijven";
                        bool is_subscrubed = false;
                        bool is_full = (int.parse(festivals[blockIdx]["shifts"]
                                [childIdx]["people_needed"]) <=
                            int.parse(festivals[blockIdx]["shifts"][childIdx]
                                ["subscribed_final"]));
                        bool is_completely_full = ((int.parse(
                                    festivals[blockIdx]["shifts"][childIdx]
                                        ["people_needed"]) +
                                int.parse(festivals[blockIdx]["shifts"]
                                    [childIdx]["spare_needed"])) <=
                            int.parse(festivals[blockIdx]["shifts"][childIdx]
                                ["subscribed_final"]));

                        if (festivals[blockIdx]["shifts"].length > 0) {
                          for (var y = 0; y < workDays.length; y++) {
                            if (workDays[y]["idshifts"] ==
                                festivals[blockIdx]["shifts"][childIdx]
                                    ["idshifts"]) {
                              is_subscrubed = true;
                              break;
                            }
                          }
                          shift_text = festivals[blockIdx]["shifts"][childIdx]
                                      ["name"]
                                  .toString() +
                              ":";

                          // check if user
                        }
                        List button = id_to_status(
                            int.parse(festivals[blockIdx]["status"]),
                            is_subscrubed,
                            is_full,
                            is_completely_full);
                        return Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.72)),
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, top: 0, bottom: 0),
                            child: Column(children: [
                              Center(
                                child: Text(
                                  shift_text,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.95,
                                decoration: BoxDecoration(
                                    color: button[2],
                                    borderRadius: BorderRadius.circular(20)),
                                margin: const EdgeInsets.only(
                                    top: 2.0, bottom: 2.0),
                                child: FlatButton(
                                  onPressed: () {
                                    if (button[3]) {
                                      print("disabled");
                                    } else if (button[0]) {
                                      print("subscribe");
                                      api
                                          .user_subscribe(festivals[blockIdx]
                                                      ["shifts"][childIdx]
                                                  ["idshifts"]
                                              .toString())
                                          .then((value) => {update()});
                                    } else {
                                      print("unsubscribe");
                                      api
                                          .user_unsubscribe(festivals[blockIdx]
                                                      ["shifts"][childIdx]
                                                  ["idshifts"]
                                              .toString())
                                          .then((value) => {update()});
                                    }
                                  },
                                  child: Text(
                                    button[1],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ),
                              Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.95,
                                decoration: BoxDecoration(
                                    color: button[2],
                                    borderRadius: BorderRadius.circular(20)),
                                margin: const EdgeInsets.only(
                                    top: 2.0, bottom: 2.0),
                                child: FlatButton(
                                  onPressed: () {
                                    var shift_id = festivals[blockIdx]["shifts"][childIdx]["idshifts"];
                                    storage.read(key: "id").then((ID) => {
                                      storage.read(key: "hash").then((HASH) => {
                                      _launchURL("https://all-round-events.be/api.php?action=pdf_unemployment&ID="+ID+"&HASH="+ HASH +"&shift=" + shift_id)
                                      })
                                    });

                                  },
                                  child: Text(
                                    "Werkloosheidsattest",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ),
                              Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width * 0.95,
                                decoration: BoxDecoration(
                                    color: button[2],
                                    borderRadius: BorderRadius.circular(20)),
                                margin: const EdgeInsets.only(
                                    top: 2.0, bottom: 2.0),
                                child: FlatButton(
                                  onPressed: () {
                                    api.get_location_by_shift_id(festivals[blockIdx]["shifts"][childIdx]["idshifts"]).then((locations) => {
                                        api.get_external_meeting().then((external) => {
                                        showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                        _buildPopupDialog3(context, locations, external),
                                        ).then((value) => {back(context)})
                                      })
                                    });

                                  },
                                  child: Text(
                                    "Opvang moment",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: festivals[blockIdx]["shifts"]
                                        [childIdx]["shift_days"]
                                    .length,
                                itemBuilder:
                                    (BuildContext context, int childIdxx) {
                                  String start = "";
                                  String end = "";
                                  String cost = "";
                                  if (festivals[blockIdx]["shifts"][childIdx]
                                              ["shift_days"]
                                          .length >
                                      0) {
                                    start = "Start: " +
                                        festivals[blockIdx]["shifts"][childIdx]
                                                    ["shift_days"][childIdxx]
                                                ["start_date"]
                                            .toString();
                                  }
                                  if (festivals[blockIdx]["shifts"][childIdx]
                                              ["shift_days"]
                                          .length >
                                      0) {
                                    end = "Einde: " +
                                        festivals[blockIdx]["shifts"][childIdx]
                                                    ["shift_days"][childIdxx]
                                                ["shift_end"]
                                            .toString();
                                  }
                                  if (festivals[blockIdx]["shifts"][childIdx]
                                              ["shift_days"]
                                          .length >
                                      0) {
                                    cost = festivals[blockIdx]["shifts"]
                                                [childIdx]["shift_days"]
                                            [childIdxx]["cost"]
                                        .toString();
                                  }
                                  return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.lightBlueAccent,
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      margin: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 2,
                                          bottom: 2),
                                      child: Column(children: [
                                        Text(
                                          "dag " +
                                              (childIdxx + 1).toString() +
                                              "(€" +
                                              cost +
                                              ")",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          start,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          end,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                      ]));
                                },
                              )
                            ]));
                      },
                    )
                  ],
                );
              },
            ))
          ]),
        ));
  }
  Widget _buildPopupDialog3(BuildContext context, locations, external) {
    int test = 4;
    return new AlertDialog(
      title: const Text('Evenementen'),
      content: setupAlertDialoadContainer(locations, external),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget setupAlertDialoadContainer(locations, external) {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child:ListView.builder(
        itemCount: locations.length,
        itemBuilder: (BuildContext context, int index) {
          var subscribed = false;
          for(var x = 0; x < external.length ; x++){
            if(external[x]["location_id"] == locations[index]["location_id"]){
              subscribed = true;
            }
          }
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Checkbox(
                  value: subscribed,
                  onChanged: (newValue) {
                    setState(() {
                      // checkbox is changed, this should untag all other checkboxes and push to api
                    });
                  },
                ),
                Text(
                    locations[index]["appointment_time"] + "  " +  locations[index]["location"]
                )]
          );
        },
      ),
    );
  }
}

//0: false= user_desubscribe, true= user subscribe
//1: button title
//2: button color
//3: button disable
List id_to_status(id, is_already_subscribed, is_full, is_completely_full) {
  if (id == 0) {
    if (is_already_subscribed) {
      return [false, "Uitschrijven", Colors.red, false];
    } else {
      return [true, "Geïnteresseerd", Colors.green, false];
    }
  } else if (id == 1) {
    if (is_already_subscribed) {
      return [
        false,
        "Ingeschreven(uitschrijven niet mogelijk)",
        Colors.grey,
        true
      ];
    } else {
      return [false, "Inschrijven niet mogelijk", Colors.grey, true];
    }
  } else if (id == 2) {
    if (is_already_subscribed) {
      return [false, "Uitschrijven", Colors.grey, false];
    } else if (is_completely_full) {
      return [
        true,
        "registeren(volzet)",
        Colors.orange,
        false
      ];
    } else {
      return [true, "registeren", Colors.green, false];
    }
  } else if (id == 3) {
    if (is_already_subscribed) {
      return [false, "Uitschrijven", Colors.red, false];
    } else if (is_completely_full) {
      return [false, "Volzet", Colors.red, true];
    } else if (is_full) {
      return [true, "Inschrijven(Volzet)", Colors.orange, false];
    } else {
      return [true, "Inschrijven", Colors.green, false];
    }
  } else if (id == 4) {
    if (is_already_subscribed) {
      return [
        true,
        "Ingeschreven(Uitschrijven niet mogelijk)",
        Colors.green,
        true
      ];
    } else {
      return [true, "inschrijvingen afgesloten", Colors.grey, true];
    }
  } else if (id == 5) {
    if (is_already_subscribed) {
      return [false, "Eindafrekeningen", Colors.grey, true];
    } else {
      return [false, "Evenement afgelopen", Colors.grey, true];
    }
  } else if (id == 6) {
    return [false, "Afgeloten", Colors.grey, true];
  } else if (id == 7) {
    return [false, "geanuleerd", Colors.grey, true];
  } else {
    return [false, "uitgeschakeld", Colors.grey, true];
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Evenementen'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            "Er zijn geen evenementen in de nabije toekomst. Kom later terug! "),
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

Widget _buildPopupDialog2(BuildContext context) {
  int test = 4;
  return new AlertDialog(
    title: const Text('Evenementen'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Je kan je niet inschrijven zonder een profielfoto"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          timer.cancel();
          isSet = false;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => imgDemo()));
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Terug'),
      ),
    ],
  );
}



