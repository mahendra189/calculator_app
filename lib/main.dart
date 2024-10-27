import 'package:calculator/widgets/calc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const Calculator());
}

// Define your light and dark themes here
ThemeData light = ThemeData(
  textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
  useMaterial3: true,
  primaryColor: Colors.black54,
  hintColor: Colors.orange,
  canvasColor: Colors.black38,
  focusColor: Colors.black87,
  scaffoldBackgroundColor: Colors.white,
);

ThemeData dark = ThemeData(
  textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
  useMaterial3: true,
  primaryColor: Colors.white30,
  hintColor: Colors.orange,
  canvasColor: Colors.white10,
  focusColor: Colors.white,
  scaffoldBackgroundColor: Colors.black,
);

class Calculator extends StatefulWidget {
  const Calculator({super.key});
  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  ThemeMode _themeMode = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: light,
        darkTheme: dark,
        themeMode: _themeMode,
        home:
            Scaffold(body: Calc(theme: _themeMode, changeTheme: toggleTheme)));
  }
}
