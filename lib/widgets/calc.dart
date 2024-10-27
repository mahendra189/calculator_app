import 'package:calculator/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Calc extends StatefulWidget {
  final Function changeTheme;
  final ThemeMode theme;
  const Calc({super.key, required this.theme, required this.changeTheme});

  @override
  State<Calc> createState() => _CalcScreen();
}

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

Color numColor = Colors.white10;
Color homeRowColor = Colors.white30;
Color sideColor = Colors.orange;
const int limitLength = 7;
const initialIcon = CupertinoIcons.check_mark_circled_solid;
Map<String, IconData> operatorMap = {
  '+': CupertinoIcons.add_circled_solid,
  '-': CupertinoIcons.minus_circle_fill,
  'X': CupertinoIcons.multiply_circle_fill,
  '/': CupertinoIcons.divide_circle_fill
};

class _CalcScreen extends State<Calc> {
  String input = '';
  String space = '';
  IconData operator = initialIcon;
  double resFont = 50;

  void onChange(String value) {
    // if (input.isNotEmpty) {
    //   setState(() {
    //     input += value;
    //     resFont -= 2;
    //   });
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text(
    //     "Length Limit $limitLength!",
    //   )));
    // }
    setState(() {
      input += value;
      if (7 < input.length && input.length < 15) {
        resFont -= 2;
      } else if (input.length <= 7) {
        resFont = 50;
      }
    });
  }

  void clearInput(String value) {
    clear();
  }

  void evaluate(String value) {
    if (input != '' && operator != initialIcon) {
      Map<IconData, num> operations = {
        operatorMap['+']!: num.parse(space) + num.parse(input),
        operatorMap['-']!: num.parse(space) - num.parse(input),
        operatorMap['X']!: num.parse(space) * num.parse(input),
        operatorMap['/']!: num.parse(space) / num.parse(input),
      };
      num eval = operations[operator]!;
      setState(() {
        space = '';
        input = eval.toString();
        operator = CupertinoIcons.equal_circle_fill;
      });
    } else if (input.isEmpty && space.isNotEmpty) {
      setState(() {
        input = space;
        space = '';
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter Number!")));
    }
  }

  void evaluateOperand() {
    if (input != '') {
      Map<IconData, num> operations = {
        operatorMap['+']!: num.parse(space) + num.parse(input),
        operatorMap['-']!: num.parse(space) - num.parse(input),
        operatorMap['X']!: num.parse(space) * num.parse(input),
        operatorMap['/']!: num.parse(space) / num.parse(input),
      };
      num eval = operations[operator]!;
      setState(() {
        space = eval.toString();
        input = '';
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter Number!")));
    }
  }

  void clear() {
    setState(() {
      input = '';
      space = '';
      operator = initialIcon;
    });
  }

  void operatorSwitch(String op) {
    if (input.isNotEmpty && space.isEmpty) {
      setState(() {
        space = input;
        operator = operatorMap[op]!;
        input = '';
      });
    } else if (input.isNotEmpty && space.isNotEmpty) {
      setState(() {
        operator = operatorMap[op]!;
      });
      evaluateOperand();
    } else if (input.isEmpty && space.isNotEmpty) {
      setState(() {
        operator = operatorMap[op]!;
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter Number!")));
    }
  }

  void backSpace(String value) {
    if (input.isNotEmpty) {
      setState(() {
        input = input.substring(0, input.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Switch(
                value: widget.theme == ThemeMode.dark,
                activeColor: Colors.amber,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: sideColor,
                activeTrackColor: Colors.black,
                splashRadius: 20,
                trackOutlineColor: const WidgetStatePropertyAll(
                    Color.fromARGB(139, 255, 255, 255)),
                onChanged: (bool value) {
                  widget.changeTheme();
                }),
          ]),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Text(space,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 30,
                                color: Theme.of(context).primaryColor,
                              )),
                        ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          operator,
                          color: Theme.of(context).focusColor,
                          size: 50,
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Text(input,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: resFont,
                                color: Theme.of(context).focusColor,
                              )),
                        ))
                      ],
                    ),
                  ],
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                  content: "",
                  label: buttonText("AC"),
                  bg: Theme.of(context).primaryColor,
                  onClick: clearInput),
              Button(
                  content: "",
                  label: buttonIcon(CupertinoIcons.delete_left),
                  bg: Theme.of(context).primaryColor,
                  onClick: backSpace),
              Button(
                  content: "",
                  label: buttonText("%"),
                  bg: Theme.of(context).primaryColor,
                  onClick: onChange),
              Button(
                  content: "/",
                  label: buttonIcon(CupertinoIcons.divide),
                  bg: Theme.of(context).hintColor,
                  onClick: operatorSwitch),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                  content: "7",
                  label: buttonText("7"),
                  bg: Theme.of(context).canvasColor,
                  onClick: onChange),
              Button(
                  content: "8",
                  label: buttonText("8"),
                  bg: Theme.of(context).canvasColor,
                  onClick: onChange),
              Button(
                  content: "9",
                  label: buttonText("9"),
                  bg: Theme.of(context).canvasColor,
                  onClick: onChange),
              Button(
                  content: "X",
                  label: buttonIcon(CupertinoIcons.multiply),
                  bg: Theme.of(context).hintColor,
                  onClick: operatorSwitch),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                  content: "4",
                  label: buttonText("4"),
                  bg: Theme.of(context).canvasColor,
                  onClick: onChange),
              Button(
                  content: "5",
                  label: buttonText("5"),
                  bg: Theme.of(context).canvasColor,
                  onClick: onChange),
              Button(
                  content: "6",
                  label: buttonText("6"),
                  bg: Theme.of(context).canvasColor,
                  onClick: onChange),
              Button(
                  content: "-",
                  label: buttonIcon(CupertinoIcons.minus),
                  bg: Theme.of(context).hintColor,
                  onClick: operatorSwitch),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                  content: "1",
                  label: buttonText("1"),
                  bg: Theme.of(context).canvasColor,
                  onClick: onChange),
              Button(
                  content: "2",
                  label: buttonText("2"),
                  bg: Theme.of(context).canvasColor,
                  onClick: onChange),
              Button(
                  content: "3",
                  label: buttonText("3"),
                  bg: Theme.of(context).canvasColor,
                  onClick: onChange),
              Button(
                  content: "+",
                  label: buttonIcon(CupertinoIcons.add),
                  bg: Theme.of(context).hintColor,
                  onClick: operatorSwitch)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                  content: "",
                  label: buttonIcon(Icons.calculate_rounded),
                  bg: Theme.of(context).canvasColor,
                  onClick: onChange),
              Button(
                  content: "0",
                  label: buttonText("0"),
                  bg: Theme.of(context).canvasColor,
                  onClick: onChange),
              Button(
                  content: ".",
                  label: buttonText("."),
                  bg: Theme.of(context).canvasColor,
                  onClick: onChange),
              Button(
                  content: "",
                  label: buttonIcon(CupertinoIcons.equal),
                  bg: Theme.of(context).hintColor,
                  onClick: evaluate)
            ],
          ),
        ],
      ),
    );
  }

  Widget buttonText(String label) {
    return Text(
      label,
      style: TextStyle(fontSize: 30, color: Theme.of(context).focusColor),
    );
  }

  Widget buttonIcon(IconData icon) {
    return Icon(icon, color: Theme.of(context).focusColor, size: 40);
  }
}
