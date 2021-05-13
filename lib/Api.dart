import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'login.dart';

class ApiService {
  // set up POST request arguments
  HttpClient client = HttpClient();
  final storage = new FlutterSecureStorage();

  Future<bool> autoApiLogin() async {
    String id = await storage.read(key: "id");
    String hash = await storage.read(key: "hash");
    // check if a token is saved.
    if (id != null && hash != null) {
      Uri url =
          Uri.parse('https://www.all-round-events.be/api.php?action=get_main');
      String json =
          '{"id": "' + id.toString() + '", "hash": "' + hash.toString() + '"}';
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
        } else {
          return false;
        }
      } else {
        // credentials found on device but they are not valid, log ins needed
        return false;
      }
    } else {
      // no credentials are stored on the device, login is needed
      return false;
    }
  }

  Future<List> ApiLogin(List login) async {
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
      return [
        "",
        "Er kon geen connectie gemaakt worden, bent u verbonden met het internet?"
      ];
    }
  }

  Future<void> PassReset(String email) async {
    Uri url =
        Uri.parse('https://www.all-round-events.be/api.php?action=reset_pass');
    String json = '{"email": "' + email + '"}';
    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.write(json);
    final response = await request.close();
    int statusCode = response.statusCode;
    if (statusCode != 200) {
      print("error");
    }
  }

  Future<dynamic> UserInit(Map userData) async {
    Uri url =
        Uri.parse('https://www.all-round-events.be/api.php?action=new_user');
    Object json = {
      "pass": userData["pass"],
      "email": userData["email"],
      "activation_code": userData["activation_code"]
    };
    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.write(jsonEncode(json));
    final response = await request.close();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      var json_respone = jsonDecode(body);
      await storage.write(key: "hash", value: json_respone["hash"]);
      await storage.write(key: "id", value: json_respone["id"]);
      return json_respone;
    }
  }

  Future<dynamic> getUser_info() async {
    // write from secure storage
    String id = await storage.read(key: "id");
    String hash = await storage.read(key: "hash");

    Uri url =
        Uri.parse('https://www.all-round-events.be/api.php?action=get_main');
    String json =
        '{"id": "' + id.toString() + '", "hash": "' + hash.toString() + '"}';
    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.write(json);
    final response = await request.close();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      var json_respone = jsonDecode(body);
      return json_respone;
    } else {}
  }

  Future<List> getFestivals() async {
    // write from secure storage
    String id = await storage.read(key: "id");
    String hash = await storage.read(key: "hash");

    Uri url = Uri.parse(
        'https://www.all-round-events.be/api.php?action=get_festivals');
    String json =
        '{"id": "' + id.toString() + '", "hash": "' + hash.toString() + '"}';
    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.write(json);
    final response = await request.close();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      try {
        if (jsonDecode(body).length == 0) {
          return [];
        }
      } catch (e) {}
      var json_respone = jsonDecode(body);
      return json_respone;
    } else {
      return [];
    }
  }

  Future<List> getshifts() async {
    // write from secure storage
    String id = await storage.read(key: "id");
    String hash = await storage.read(key: "hash");

    Uri url =
        Uri.parse('https://www.all-round-events.be/api.php?action=get_shifts');
    String json =
        '{"id": "' + id.toString() + '", "hash": "' + hash.toString() + '"}';
    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.write(json);
    final response = await request.close();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      try {
        if (jsonDecode(body).length == 0) {
          return [];
        }
      } catch (e) {}
      var json_respone = jsonDecode(body);
      return json_respone;
    } else {}
  }

  Future<List> GetShiftDays() async {
    // write from secure storage
    String id = await storage.read(key: "id");
    String hash = await storage.read(key: "hash");
    Uri url = Uri.parse(
        'https://www.all-round-events.be/api.php?action=get_shift_days');
    String json =
        '{"id": "' + id.toString() + '", "hash": "' + hash.toString() + '"}';
    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.write(json);
    final response = await request.close();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      try {
        if (jsonDecode(body).length == 0) {
          return [];
        }
      } catch (e) {}
      var json_respone = jsonDecode(body);
      return json_respone;
      print(json_respone);
    } else {
      return [];
    }
  }

  Future<List> get_images() async {
    // write from secure storage
    String id = await storage.read(key: "id");
    String hash = await storage.read(key: "hash");
    Uri url = Uri.parse(
        'https://www.all-round-events.be/api.php?action=get_pictures');
    String json =
        '{"id": "' + id.toString() + '", "hash": "' + hash.toString() + '"}';
    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.write(json);
    final response = await request.close();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      try {
        if (jsonDecode(body).length == 0) {
          return [];
        }
        if (jsonDecode(body)["status"] == 200) {
          return [];
        }
      } catch (e) {}
      var json_respone = jsonDecode(body);
      return json_respone;
      print(json_respone);
    } else {
      return [];
    }
  }

  Future<List> GetShiftWorkDays() async {
    // write from secure storage
    String id = await storage.read(key: "id");
    String hash = await storage.read(key: "hash");
    Uri url = Uri.parse(
        'https://www.all-round-events.be/api.php?action=shift_work_days');
    String json =
        '{"id": "' + id.toString() + '", "hash": "' + hash.toString() + '"}';
    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.write(json);
    final response = await request.close();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      if (jsonDecode(body).length < 1) {
        return [];
      }
      if (jsonDecode(body)["error_type"] == 8) {
        return ["picture"];
      }
      if (jsonDecode(body)["status"] == 200) {
        return [];
      }
      List json_respone = jsonDecode(body);
      return json_respone;
    } else {
      return [];
    }
  }

  Future<bool> user_subscribe(shift) async {
    // write from secure storage
    String id = await storage.read(key: "id");
    String hash = await storage.read(key: "hash");
    Uri url = Uri.parse(
        'https://www.all-round-events.be/api.php?action=user_subscribe');
    Object json = {"id": id, "hash": hash, "Id_Users": id, "idshifts": shift};
    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    print(json);
    request.write(jsonEncode(json));
    final response = await request.close();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      print(body);
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    // write from secure storage
    String id = await storage.read(key: "id");
    String hash = await storage.read(key: "hash");
    Uri url =
        Uri.parse('https://www.all-round-events.be/api.php?action=logout');
    Object json = {"id": id, "hash": hash, "Id_Users": id};
    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.write(jsonEncode(json));
    final response = await request.close();
  }

  Future<void> remove_picture(pic_url) async {
    // write from secure storage
    String id = await storage.read(key: "id");
    String hash = await storage.read(key: "hash");
    Uri url =
        Uri.parse('https://all-round-events.be/api.php?action=delete_picture');
    Object json = {"id": id, "hash": hash, "Id_Users": id, "image": pic_url};
    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.write(jsonEncode(json));
    final response = await request.close();
  }

  Future<bool> user_unsubscribe(shift) async {
    // write from secure storage
    String id = await storage.read(key: "id");
    String hash = await storage.read(key: "hash");
    Uri url = Uri.parse(
        'https://www.all-round-events.be/api.php?action=user_unsubscribe');
    Object json = {"id": id, "hash": hash, "Id_Users": id, "idshifts": shift};
    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.write(jsonEncode(json));
    final response = await request.close();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List> get_news() async {
    // write from secure storage
    String id = await storage.read(key: "id");
    String hash = await storage.read(key: "hash");
    Uri url =
        Uri.parse('https://www.all-round-events.be/api.php?action=get_news');
    Object json = {"id": id, "hash": hash};
    final request = await client.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.write(jsonEncode(json));
    final response = await request.close();
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      print(body);
      try {
        if (jsonDecode(body)["status"] == 200) {
          return [];
        }
        if (jsonDecode(body)["status"] == 409) {
          return [];
        }
      } catch (e) {}
      List json_respone = jsonDecode(body);
      return json_respone;
    } else {
      return [];
    }
  }

  Future<dynamic> pushUser_info(Map userData) async {
    // write from secure storage
    String id = await storage.read(key: "id");
    String hash = await storage.read(key: "hash");

    Uri url =
        Uri.parse('https://www.all-round-events.be/api.php?action=insert_main');
    Object json = {
      "id": id.toString(),
      "hash": hash.toString(),
      "name": userData["name"],
      "date_of_birth": userData["birth"],
      "Gender": userData["gender"],
      "adres_line_one": userData["address"],
      "adres_line_two": userData["bankNr"],
      "size": userData["size"],
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
    } else {}
  }
}
