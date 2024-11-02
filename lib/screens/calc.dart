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
List<String> operators = ['*', '/', '+', '-'];

class _CalcScreen extends State<Calc> {
  String input = '0';
  String space = '';
  IconData operator = initialIcon;
  double resFont = 40;

  void onChange(String value) {
    if (input != '0') {
      setState(() {
        input += value;
        if (7 < input.length && input.length < 15) {
          resFont -= 2;
        } else if (input.length <= 7) {
          resFont = 40;
        }
      });
    } else {
      setState(() {
        input = '';
        input += value;
        if (7 < input.length && input.length < 15) {
          resFont -= 2;
        } else if (input.length <= 7) {
          resFont = 40;
        }
      });
    }
    evaluate(input);
  }

  void clearInput(String value) {
    clear();
  }

  void evaluate(String value) {
    if (input.isNotEmpty) {
      evaluation(input);
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
        input = '0';
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter Number!")));
    }
  }

  void clear() {
    setState(() {
      input = '0';
      space = '';
      operator = initialIcon;
    });
  }

  void operatorSwitch(String op) {
    if (input != '0') {
      String t = input.substring(0, input.length - 1) + op;
      if (operators.contains(input[input.length - 1])) {
        setState(() {
          input = t;
        });
      } else {
        setState(() {
          input += op;
        });
      }
    }
  }

  void backSpace(String value) {
    if (input.isNotEmpty) {
      setState(() {
        input = input.substring(0, input.length - 1);
      });
    }
  }

  void handleNegative() {
    if (!input.startsWith('-')) {
      setState(() {
        input = '-$input';
      });
    } else {
      setState(() {
        input = input.substring(
          1,
        );
      });
    }
  }

  // evaluation function
  void evaluation(String eq) {
    int v = eq.codeUnitAt(eq.length - 1);
    if (v >= 48 && v <= 57 && operators.any((e) => eq.contains(e))) {
      List<dynamic> sep = _extract(eq);
      List<String> op = ['*', '/'];
      while (sep.contains(op[0]) || sep.contains(op[1])) {
        int li = getIndex(sep, op[0]);
        int ri = getIndex(sep, op[1]);
        if (li < ri) {
          num a = sep[li - 1];
          num b = sep[li + 1];
          num result = a * b;
          sep.replaceRange(li - 1, li + 2, [result]);
        } else {
          num a = sep[ri - 1];
          num b = sep[ri + 1];
          num result = a / b;
          sep.replaceRange(ri - 1, ri + 2, [result]);
        }
      }
      op = ['+', '-'];
      while (sep.contains(op[0]) || sep.contains(op[1])) {
        int li = getIndex(sep, op[0]);
        int ri = getIndex(sep, op[1]);
        if (li < ri) {
          num a = sep[li - 1];
          num b = sep[li + 1];
          num result = a + b;
          sep.replaceRange(li - 1, li + 2, [result]);
        } else {
          num a = sep[ri - 1];
          num b = sep[ri + 1];
          num result = a - b;
          sep.replaceRange(ri - 1, ri + 2, [result]);
        }
      }
      setState(() {
        space = sep[0].toString();
      });
    }
  }

  int getIndex(List<dynamic> arr, String char) {
    int idx = arr.indexOf(char);
    return idx != -1 ? idx : arr.length;
  }

  List<dynamic> _extract(String eq) {
    List<dynamic> extracted = [];
    int i = 0;

    while (i < eq.length) {
      // Skip whitespace

      // Check for a sign or operator
      if (i < eq.length &&
          (eq[i] == '+' || eq[i] == '-' || eq[i] == '*' || eq[i] == '/')) {
        extracted.add(eq[i]); // Add the operator to the list
        i++; // Move to the next character
        continue; // Skip to the next iteration to avoid re-processing spaces
      }

      int t = i;

      // Extract digits
      while (
          i < eq.length && eq.codeUnitAt(i) >= 48 && eq.codeUnitAt(i) <= 57 ||
              i < eq.length && eq[i] == '.') {
        i++;
      }

      // If we found a number, parse and add it to the list
      if (t != i) {
        extracted.add(num.parse(eq.substring(t, i))); // Add the complete number
      }
    }

    return extracted; // Return the list of extracted numbers and operators
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Icon(
                    CupertinoIcons.list_bullet,
                    size: 35,
                    color: Theme.of(context).hintColor,
                  )),
            ),
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
                          child: Text(input,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 35,
                                color: Theme.of(context).primaryColor,
                              )),
                        ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Text(space,
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
                  label: buttonIcon(CupertinoIcons.plus_slash_minus),
                  bg: Theme.of(context).primaryColor,
                  onClick: (String value) {
                    handleNegative();
                  }),
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
                  content: "*",
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

  List<TextSpan> _getHighlightedSpans(String text) {
    List<TextSpan> spans = [];
    for (int i = 0; i < text.length; i++) {
      if (operators.contains(text[i])) {
        spans.add(TextSpan(
            text: text[i],
            style: TextStyle(color: Theme.of(context).hintColor)));
      } else {
        spans.add(TextSpan(text: text[i]));
      }
    }
    return spans;
  }
}
