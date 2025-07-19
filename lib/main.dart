import 'package:flutter/material.dart';
import 'package:weather/pages/Home.dart';
import 'package:weather/pages/Loading.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // initialRoute: "/",  // Set the initial route correctly
    routes: {
      "/": (context) => Loading(),
      "/Home": (context) => Home(),
      "/Loading": (context) => Loading(),
    },
  ));
}
