import 'package:calculator/screens/conversion.dart';
import 'package:calculator/widgets/calc.dart';
import 'package:calculator/widgets/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

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
  int _currentScreen = 0;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void changeScreen(int newScreen) {
    setState(() {
      _currentScreen = newScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dynamic screens = [
      Calc(theme: _themeMode, changeTheme: toggleTheme),
      Conversions(
        changeScreen: () {
          changeScreen(0);
        },
      )
    ];
    return MaterialApp(
      theme: light,
      darkTheme: dark,
      themeMode: _themeMode,
      home: Scaffold(
        body: screens[_currentScreen],
        drawer: Drawer(
          backgroundColor:
              _themeMode == ThemeMode.dark ? Colors.grey[900] : Colors.white,
          child: Center(
            child: ListView(
              children: [
                const SizedBox(height: 20),
                DrawerItem(
                    icon: CupertinoIcons.chart_bar_square,
                    label: "Conversions",
                    onClick: () {
                      changeScreen(1);
                    }),
                const Divider(),
                DrawerItem(
                    icon: CupertinoIcons.lab_flask,
                    label: "Scientific",
                    onClick: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
