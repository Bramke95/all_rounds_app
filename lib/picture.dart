import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:flutter/material.dart";
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'Api.dart';

ApiService api = new ApiService();

final storage = new FlutterSecureStorage();
String id = "";
String hash = "";
final String phpEndPoint = 'https://all-round-events.be/api.php?action=upload_picture';
PickedFile file;
File image;
final _picker = ImagePicker();
var dio = Dio();
String url = "";
bool isSet = false;

class imgDemo extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<imgDemo> {

  void _upload() async {
    if (image == null) return;
    String base64Image = base64Encode(image.readAsBytesSync());
    var formData = FormData.fromMap({
      'name': 'wendux',
      'age': 25,
      'img': await MultipartFile.fromFile(file.path, filename: 'test.jpg')
    });
    final res = await dio.post('https://all-round-events.be/api.php?action=upload_picture', data: formData);
    // user response uploaded
  }

  void _choose() async {
    //PickedFile image = await _picker.getImage(source: ImageSource.camera);
    file = await _picker.getImage(source: ImageSource.gallery);
    image = File(file.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void set_image(image){
      url = "https://all-round-events.be/" + image["picture_name"];
      image = Image.network(url);
      print(url);
      setState(() {});

    }

    storage.read(key: "id").then((value) =>
    {
      id = value
    });
    storage.read(key: "hash").then((value) =>
    {
      hash = value
    });
    void update() {
      api.get_images().then((images) =>
      {
        if (images.length < 1) {
        }
        else
          {
            for(int x = 0; x < images.length; x++){
              if (images[x]["is_primary"] == "1"){
                set_image(images[x])
              }
            }
          }
      });
    }
    if (!isSet) {
      update();
      isSet = true;
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: _choose,
                child: Text('Choose Image'),
              ),
              SizedBox(width: 10.0),
              RaisedButton(
                onPressed: _upload,
                child: Text('Upload Image'),
              )
            ],
          ),
          image != null
              ? Image.file(image)
              : Image.network(url)
        ],
      ),
    );
  }
}