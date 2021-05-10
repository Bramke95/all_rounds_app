import "package:flutter/material.dart";
import 'login.dart';

Future<dynamic> onSelectNotification(test){
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue), home: LoginDemo());
  }
  test = {};
  return test;
}

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue), home: LoginDemo());
  }
}

