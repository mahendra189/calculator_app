import 'package:calculator/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Calc extends StatefulWidget {
  const Calc({super.key});

  @override
  State<Calc> createState() => _CalcScreen();
}

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
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter Number!")));
    }
  }

  void evaluateOperand() {
    if (input != '') {
      Map<IconData, num> operations = {
        operatorMap['+']!: int.parse(space) + int.parse(input),
        operatorMap['-']!: int.parse(space) - int.parse(input),
        operatorMap['X']!: int.parse(space) * int.parse(input),
        operatorMap['/']!: int.parse(space) / int.parse(input),
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
                              child: Text(
                                space,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.white70),
                              )),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          operator,
                          color: Colors.white,
                          size: 50,
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Text(
                            input,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: resFont, color: Colors.white),
                          ),
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
                  bg: homeRowColor,
                  onClick: clearInput),
              Button(
                  content: "",
                  label: buttonIcon(CupertinoIcons.delete_left),
                  bg: homeRowColor,
                  onClick: backSpace),
              Button(
                  content: "",
                  label: buttonText("%"),
                  bg: homeRowColor,
                  onClick: onChange),
              Button(
                  content: "/",
                  label: buttonIcon(CupertinoIcons.divide),
                  bg: sideColor,
                  onClick: operatorSwitch),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                  content: "7",
                  label: buttonText("7"),
                  bg: numColor,
                  onClick: onChange),
              Button(
                  content: "8",
                  label: buttonText("8"),
                  bg: numColor,
                  onClick: onChange),
              Button(
                  content: "9",
                  label: buttonText("9"),
                  bg: numColor,
                  onClick: onChange),
              Button(
                  content: "X",
                  label: buttonIcon(CupertinoIcons.multiply),
                  bg: sideColor,
                  onClick: operatorSwitch),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                  content: "4",
                  label: buttonText("4"),
                  bg: numColor,
                  onClick: onChange),
              Button(
                  content: "5",
                  label: buttonText("5"),
                  bg: numColor,
                  onClick: onChange),
              Button(
                  content: "6",
                  label: buttonText("6"),
                  bg: numColor,
                  onClick: onChange),
              Button(
                  content: "-",
                  label: buttonIcon(CupertinoIcons.minus),
                  bg: sideColor,
                  onClick: operatorSwitch),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                  content: "1",
                  label: buttonText("1"),
                  bg: numColor,
                  onClick: onChange),
              Button(
                  content: "2",
                  label: buttonText("2"),
                  bg: numColor,
                  onClick: onChange),
              Button(
                  content: "3",
                  label: buttonText("3"),
                  bg: numColor,
                  onClick: onChange),
              Button(
                  content: "+",
                  label: buttonIcon(CupertinoIcons.add),
                  bg: sideColor,
                  onClick: operatorSwitch)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                  content: "",
                  label: buttonIcon(Icons.calculate_rounded),
                  bg: numColor,
                  onClick: onChange),
              Button(
                  content: "0",
                  label: buttonText("0"),
                  bg: numColor,
                  onClick: onChange),
              Button(
                  content: ".",
                  label: buttonText("."),
                  bg: numColor,
                  onClick: onChange),
              Button(
                  content: "",
                  label: buttonIcon(CupertinoIcons.equal),
                  bg: sideColor,
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
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
      ),
    );
  }

  Widget buttonIcon(IconData icon) {
    return Icon(icon, color: Colors.white, size: 40);
  }
}
