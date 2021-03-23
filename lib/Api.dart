import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:all_round_events/login.dart';

class ApiService {
  // set up POST request arguments
  HttpClient client = HttpClient();
  final storage = new FlutterSecureStorage();

  Future < bool > autoApiLogin() async {
    String id = await storage.read(key: "id");
    String hash = await storage.read(key: "hash");
    // check if a token is saved.
    if (id != null && hash != null){
      Uri url = Uri.parse('https://www.all-round-events.be/api.php?action=get_main');
      String json = '{"id": "' + id.toString() + '", "hash": "' + hash.toString() + '"}';
      final request = await client.postUrl(url);
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      request.write(json);
      final response = await request.close();
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        var json_respone = jsonDecode(body);
        if (json_respone["status"] == 200) {
          return true;
        }
        else{
          return false;
        }

        return true;
      } else {
        // credentials found on device but they are not valid, log ins needed
        return false;
      }
    }
    else{
      // no credentials are stored on the device, login is needed
      return false;
    }
  }

  Future < List > ApiLogin(List login) async {


    Uri url = Uri.parse('https://www.all-round-events.be/api.php?action=login');
    String json = '{"email": "' + login[0] + '", "pass": "' + login[1] + '"}';
    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.write(json);
    final response = await request.close();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      var json_respone = jsonDecode(body);
      print(json_respone);
      if (json_respone["status"] == 200) {
        // save in secure storage
        await storage.write(key: "hash", value: json_respone["hash"]);
        await storage.write(key: "id", value: json_respone["id"]);
        return [json_respone["hash"], "OK"];
      } else {
        return ["", "Uw logingegevens waren niet correct, probeer opnieuw"];
      }
    } else {
      return ["", "Er kon geen connectie gemaakt worden, bent u verbonden met het internet?"];
    }
  }

  Future <dynamic> getUser_info() async {

    // write from secure storage
    String id = await storage.read(key: "id");
    String hash = await storage.read(key: "hash");

    Uri url = Uri.parse('https://www.all-round-events.be/api.php?action=get_main');
    String json = '{"id": "' + id.toString() + '", "hash": "' + hash.toString() + '"}';
    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.write(json);
    final response = await request.close();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      var json_respone = jsonDecode(body);
      return json_respone;
      print(json_respone);
    } else {

    }
  }

  Future <dynamic> pushUser_info(Map userData) async {

    // write from secure storage
    String id = await storage.read(key: "id");
    String hash = await storage.read(key: "hash");

    Uri url = Uri.parse('https://www.all-round-events.be/api.php?action=insert_main');
    Object json = {"id": id.toString() , "hash": hash.toString(),
      "name": userData["name"],
      "date_of_birth": userData["birth"],
      "Gender": userData["gender"],
      "adres_line_one": userData["address"],
      "adres_line_two": userData["bankNr"],
      "driver_license": userData["socialNR"],
      "nationality": userData["country"],
      "telephone": userData["phone"],
      "marital_state": "0",
      "text": userData["text"]
    };

    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.write(jsonEncode(json));
    final response = await request.close();
    int statusCode = response.statusCode;
    print(response.statusCode);
    final body = await response.transform(utf8.decoder).join();
    print(body);
    if (statusCode == 200) {
      var json_respone = jsonDecode(body);
      return json_respone;
      print(json_respone);
    } else {

    }
  }
}