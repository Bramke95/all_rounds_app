import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:flutter/material.dart";
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'Api.dart';
import 'mainMenu.dart';

ApiService api = new ApiService();

final storage = new FlutterSecureStorage();
String id = "";
String hash = "";
final String phpEndPoint =
    'https://all-round-events.be/api.php?action=upload_picture';
PickedFile file;
File image;
final _picker = ImagePicker();
var dio = Dio();
String url = "";
String simple_url = "";
bool isSet = false;

String first_text = "selecteer";
String second_text = "Opslaan";

class imgDemo extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<imgDemo> {
  void back(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserMenu()));
    isSet = false;
  }

  @override
  Widget build(BuildContext context) {
    void _choose() async {
      //PickedFile image = await _picker.getImage(source: ImageSource.camera);
      file = await _picker.getImage(source: ImageSource.gallery);
      image = File(file.path);
      setState(() {});
    }

    void set_image(image) {
      url = "https://all-round-events.be/" + image["picture_name"];
      simple_url = image["picture_name"];
      image = Image.network(url);
      second_text = "verwijder";
      setState(() {});
    }

    storage.read(key: "id").then((value) => {id = value});
    storage.read(key: "hash").then((value) => {hash = value});
    void update() {
      api.get_images().then((images) => {
            if (images.length < 1)
              {setState(() {})}
            else
              {
                for (int x = 0; x < images.length; x++)
                  {
                    if (images[x]["is_primary"] == "1") {set_image(images[x])}
                  }
              }
          });
    }

    if (!isSet) {
      update();
      isSet = true;
    }

    void uploaded() {
      image = null;
      update();
      first_text = "selecteer";
      second_text = "Opslaan";
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog2(context),
      ).then((value) => {});
    }

    void removed() {
      image = null;
      url = "";
      simple_url = "";
      update();
      first_text = "selecteer";
      second_text = "Opslaan";
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog3(context),
      ).then((value) => {});
    }

    void _upload() async {
      if (image == null) {
        if (simple_url.length < 1) {
          return;
        }
        api.remove_picture(simple_url).then((value) => {removed()});
        return;
      }
      ;
      Object json_data = {"ID": id, "TOKEN": hash};
      var formData = FormData.fromMap({
        'auth': jsonEncode(json_data),
        'img': await MultipartFile.fromFile(file.path, filename: 'test.jpg')
      });
      final res = await dio.post(
          'https://all-round-events.be/api.php?action=upload_picture',
          data: formData);
      if (res.statusCode == 200) {
        if (json.decode(res.data)["status"] == 200) {
          uploaded();
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context),
          ).then((value) => {back(context)});
        }
      }
    }

    return WillPopScope(
        onWillPop: () {
          //trigger leaving and use own data
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserMenu()));
          isSet = false;
          //we need to return a future
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("profielfoto"),
          ),
          body: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: _choose,
                    child: Text(first_text),
                  ),
                  SizedBox(width: 10.0),
                  RaisedButton(
                    onPressed: _upload,
                    child: Text(second_text),
                  )
                ],
              ),
              image != null ? Image.file(image) : Image.network(url)
            ],
          ),
        ));
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Afbeeldingen'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            "Het uploaden is mislukt, je kan maximaal 5 afbeeldingen opslaan.(GIF, PNG, JPG)"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserMenu()));
          isSet = false;
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Terug'),
      ),
    ],
  );
}

Widget _buildPopupDialog2(BuildContext context) {
  return new AlertDialog(
    title: const Text('Afbeeldingen'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Foto opgeslagen!"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Terug'),
      ),
    ],
  );
}

Widget _buildPopupDialog3(BuildContext context) {
  return new AlertDialog(
    title: const Text('Afbeeldingen'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Foto verwijderd!"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Terug'),
      ),
    ],
  );
}
