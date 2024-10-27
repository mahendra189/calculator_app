import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

IconData addIcon = Icons.add;
IconData subtractIcon = Icons.remove;
IconData multiplyIcon = Icons.close;
IconData divisionIcon = CupertinoIcons.divide;

Map<String, Color> darkTheme = {
  'background': Colors.black,
  'homeRow': Colors.white30,
  'sideRow': Colors.orange,
  'btn_bg': Colors.white10,
  'btn_fg': Colors.white,
};

Map<String, Color> lightTheme = {
  'background': Colors.white,
  'homeRow': Colors.black54,
  'sideRow': Colors.orange,
  'btn_bg': Colors.black38,
  'btn_fg': Colors.black87,
};

// ThemeData(
//     scaffoldBackgroundColor: colorMap['background'],
//     primaryColor: colorMap['homeRow'],
//     accentColor: colorMap['sideRow'],
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         primary: colorMap['btn_bg'],
//         onPrimary: colorMap['btn_fg'],
//       ),
//     ),
//     // Additional theme properties that refer to colorMap values
//   );
ThemeData light = ThemeData(
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    useMaterial3: true,
    primaryColor: Colors.white54,
    hintColor: Colors.orange,
    canvasColor: Colors.black38,
    focusColor: Colors.black87,
    scaffoldBackgroundColor: Colors.white);

ThemeData dark = ThemeData(
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    useMaterial3: true,
    primaryColor: Colors.white30,
    hintColor: Colors.orange,
    canvasColor: Colors.white10,
    focusColor: Colors.white,
    scaffoldBackgroundColor: Colors.white);
