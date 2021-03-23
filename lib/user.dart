import 'package:flutter/material.dart';
import 'Api.dart';
import 'package:flutter/services.dart';

String user_name = "";
final myName_controller = TextEditingController();
final myaddres_controller = TextEditingController();
final myrekening_controller = TextEditingController();
final mytelephone_controller = TextEditingController();
final myNathionality_controller = TextEditingController();
final date_controller = TextEditingController();
final mytext_controller = TextEditingController();
final mysocialNR_controller = TextEditingController();
bool isSet = false;
String gender = "Man";

class UserDemo extends StatefulWidget {
  @override
  userPage createState() => userPage();
}

class userPage extends State<UserDemo> {
  @override
  Widget build(BuildContext context) {
    if (!isSet) {
      ApiService api = new ApiService();
      api.getUser_info().then((user) {
        print(user);
        setState(() {
          user_name = user["name"];
          myName_controller.text = user["name"];
          myaddres_controller.text = user["adres_line_one"];
          myrekening_controller.text = user["adres_line_two"];
          mytelephone_controller.text = user["telephone"];
          myNathionality_controller.text = user["nationality"];
          date_controller.text = user["date_of_birth"];
          mytext_controller.text = user["text"];
          if (user["date_of_birth"] == "1"){
            String gender = "Vrouw";
          }

          isSet = true;
        });
      });
    }
    DateTime selectedDate = DateTime.utc(2000,1,1);
    Future<void> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(1920, 8),
          lastDate: DateTime(2010));
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
          date_controller.text = picked.toString();

        });
    }

    String dropdownValue = 'Man';
    return Scaffold(

      appBar: AppBar(
        title: Text("Gebruiker"),
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
              },
              child: Text(
                'Inschrijvingen',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: myName_controller,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Naam',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: myaddres_controller,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Adres',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: myrekening_controller,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Rekening nr',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: mytelephone_controller,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Gsm nr',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: myNathionality_controller,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'nationaliteit',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: date_controller,
                readOnly: true,
              onTap: () {
                _selectDate(context);
              },
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Geboortedatum',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: ''),
            ),
          ),
            Padding(

                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),

          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
                fillColor: Colors.white,
                errorStyle: TextStyle(color: Colors.black, fontSize: 16.0, backgroundColor: Colors.white),
                hintText: 'aub selecteer geslacht',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            ),

            isEmpty: false,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(

                value: gender,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                     gender = newValue;

                  });
                },
                items: ["Man", "Vrouw"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
            ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextField(
                  controller: mysocialNR_controller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Rijksregister nr',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: ''),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextField(
                  controller: mytext_controller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Persoonlijke text',
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
                String gender_int = "0";
                if (gender == "Vrouw"){
                  gender_int = "1";
                }
                api.pushUser_info({"name": myName_controller.text,
                  "address": myaddres_controller.text,
                  "bankNr": myrekening_controller.text,
                  "phone": mytelephone_controller.text,
                  "country": myNathionality_controller.text,
                  "birth": date_controller.text,
                  "gender":gender_int,
                "text": mytext_controller.text,
                "socialNR": mysocialNR_controller.text});
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context),
                );
              },
              child: Text(
                'Opslaan',
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
    title: const Text('Opgeslagen'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Al uw gegevens zijn opgeslagen!"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Close'),
      ),
    ],
  );
}
