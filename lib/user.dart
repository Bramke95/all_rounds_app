import 'package:flutter/material.dart';
import 'Api.dart';
import 'login.dart';

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
String size = "M";
String work = "Bediende";

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
        if(user[0] == "restart"){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginDemo()));
        }
        setState(() {
          user_name = user["name"];
          myName_controller.text = user["name"];
          myaddres_controller.text = user["adres_line_one"];
          myrekening_controller.text = user["adres_line_two"];
          mytelephone_controller.text = user["telephone"];
          myNathionality_controller.text = user["nationality"];
          date_controller.text = user["date_of_birth"];
          mytext_controller.text = user["text"];
          if (user["date_of_birth"] == "1") {
            String gender = "Vrouw";
          }
          size = user["size"];

          if(user["employment"] == 0){
            work = "Student";
          }
          else if (user["employment"] == 1){
            work = "Bediende";
          }
          else if (user["employment"] == 2){
            work = "Werkloos";
          }
          else if (user["employment"] == 3){
            work = "Andere";
          }

          isSet = true;
        });
      });
    }
    DateTime selectedDate = DateTime.utc(2000, 1, 1);
    Future<void> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(1920, 8), lastDate: DateTime(2010));
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
          decoration: new BoxDecoration(image: new DecorationImage(image: AssetImage("assets/background.jpg"), fit: BoxFit.cover)),
        ),
        SingleChildScrollView(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: myName_controller,
              decoration:
                  InputDecoration(fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: 'Naam', labelStyle: TextStyle(color: Colors.black), hintText: ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: myaddres_controller,
              decoration: InputDecoration(
                  fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: 'Adres', labelStyle: TextStyle(color: Colors.black), hintText: ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: myrekening_controller,
              decoration: InputDecoration(
                  fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: 'Rekening nr', labelStyle: TextStyle(color: Colors.black), hintText: ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: mytelephone_controller,
              decoration: InputDecoration(
                  fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: 'Gsm nr', labelStyle: TextStyle(color: Colors.black), hintText: ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: myNathionality_controller,
              decoration: InputDecoration(
                  fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: 'nationaliteit', labelStyle: TextStyle(color: Colors.black), hintText: ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: date_controller,
              readOnly: true,
              onTap: () {
                _selectDate(context);
              },
              decoration: InputDecoration(
                  fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: 'Geboortedatum', labelStyle: TextStyle(color: Colors.black), hintText: ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
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
                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    errorStyle: TextStyle(color: Colors.black, fontSize: 16.0, backgroundColor: Colors.white),
                    hintText: 'tewerkstelling',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                  ),
                  isEmpty: false,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: work,
                      isDense: true,
                      onChanged: (String newValue) {
                        setState(() {
                          work = newValue;
                        });
                      },
                      items: ["Student", "Bediende", "Werkloos", "andere"].map((String value) {
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
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                errorStyle: TextStyle(color: Colors.black, fontSize: 16.0, backgroundColor: Colors.white),
                hintText: 'T shift maat',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
              ),
              isEmpty: false,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: size,
                  isDense: true,
                  onChanged: (String newValue) {
                    setState(() {
                      size = newValue;
                    });
                  },
                  items: ["XXS", "XS", "S", "M", "L", "XL", "XXL"].map((String value) {
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
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: mysocialNR_controller,
              decoration: InputDecoration(
                  fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: 'Rijksregister nr', labelStyle: TextStyle(color: Colors.black), hintText: ''),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: mytext_controller,
              decoration: InputDecoration(
                  fillColor: Colors.white, filled: true, border: OutlineInputBorder(), labelText: 'Persoonlijke text', labelStyle: TextStyle(color: Colors.black), hintText: ''),
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
                String gender_int = "0";
                String work_int = "0";
                if (gender == "Vrouw") {
                  gender_int = "1";
                }

                if (work == "Student") {
                  work_int = "0";
                }
                if (work == "Bediende") {
                  work_int = "1";
                }
                if (work == "Werkloos") {
                  work_int = "2";
                }
                if (work == "andere") {
                  work_int = "3";
                }
                api.pushUser_info({
                  "name": myName_controller.text,
                  "address": myaddres_controller.text,
                  "bankNr": myrekening_controller.text,
                  "phone": mytelephone_controller.text,
                  "country": myNathionality_controller.text,
                  "birth": date_controller.text,
                  "gender": gender_int,
                  "size": size,
                  "text": mytext_controller.text,
                  "employment" : work_int,
                  "socialNR": mysocialNR_controller.text
                });
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
        child: const Text('Sluiten'),
      ),
    ],
  );
}
