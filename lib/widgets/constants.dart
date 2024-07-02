import 'package:flutter/material.dart';

class Constants{
  final primaryColor = Color.fromARGB(255,134,107,252);
  final secondaryColor = const Color(0xffa1c6fd);
  final tertiaryColor = const Color(0xff205cf1);
  final blackColor = const Color(0xff000000);
  final greyColor = const Color(0xffd9adb);

  final linearGradientBlue = const LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.topLeft,
    colors: <Color>[Color(0xffABcff2), Color(0xff9AC6f3)],
    stops: [0.0, 1.0]
  );

  final linearGradientPurple = const LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [Color(0xff51087e), Color.fromARGB(255, 120, 1, 195)],
    stops: [0.0,1.0]
  );
}