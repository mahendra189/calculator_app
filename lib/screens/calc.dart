import 'package:calculator/screens/conversion.dart';
import 'package:calculator/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

List<String> operators = ['*', '/', '+', '-'];

class _CalcScreen extends State<Calc> with TickerProviderStateMixin {
  String input = '0';
  String space = '';
  double resFont = 40;
  late AnimationController _controller;
  late AnimationController _menuController;
  late Animation<Offset> _drawerAnimation;
  late Animation<Offset> _pageAnimation;
  late Animation<Offset> _menuAnimation;
  bool _isDrawerOpen = false;
  List<String> historyDB = [];
  bool _isMenuOpen = false;

  // pref to the storage
  Future<void> saveList(List<String> items) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(items); // Convert list to JSON string
    await prefs.setString('history', jsonString); // Save the string
  }

  Future<List<String>> loadList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('history'); // Get the string
    if (jsonString != null) {
      List<String> items = List<String>.from(
          jsonDecode(jsonString)); // Convert JSON string to list
      return items;
    }
    return []; // Return an empty list if no data found
  }

  void _loadHistory() async {
    historyDB = await loadList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Animation for the drawer sliding in from the left
    _drawerAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Start offscreen to the left
      end: const Offset(0.0, 0.0), // End at normal position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Animation for the main page content moving to the right
    _pageAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0), // Start at normal position
      end: const Offset(0.6, 0.0), // Slide to the right by 60% of screen width
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _menuAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start offscreen at the bottom
      end: const Offset(0.0, 0.0), // End at normal position at the bottom
    ).animate(
      CurvedAnimation(
        parent: _menuController,
        curve: Curves.bounceIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _menuController.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      if (_isDrawerOpen) {
        _controller.forward(); // Show drawer and slide page to the right
      } else {
        _controller.reverse(); // Hide drawer and reset page position
      }
    });
  }

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
    evaluation(input);
  }

  void clearInput(String value) {
    clear();
  }

  void evaluate(String value) {
    if (input.isNotEmpty &&
        space.isNotEmpty &&
        !operators.contains(input[input.length - 1])) {
      setState(() {
        historyDB.add("$input=$space");
        saveList(historyDB);
        input = space;
        space = '';
      });
    }
  }

  void clear() {
    setState(() {
      input = '0';
      space = '';
    });
  }

  void operatorSwitch(String op) {
    if (input != '0' && input.isNotEmpty) {
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
    if (input.length > 1) {
      setState(() {
        input = input.substring(0, input.length - 1);
      });
    } else {
      setState(() {
        input = '0';
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
    if (eq.isNotEmpty) {
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
      continue;
    }

    return extracted; // Return the list of extracted numbers and operators
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SlideTransition(position: _drawerAnimation, child: history()),
        SlideTransition(position: _pageAnimation, child: calcPage()),
        _isMenuOpen
            ? GestureDetector(
                onTap: () {
                  _menuController.reverse();
                  setState(() {
                    _isMenuOpen = false;
                  });
                },
                child: Container(
                  color: Colors.black
                      .withOpacity(0.8), // Semi-transparent overlay color
                ),
              )
            : const SizedBox.shrink(),
        Positioned(
          bottom: 10, // Adjust bottom padding as desired
          left: 20, // Adjust left padding if necessary
          child: SlideTransition(
            position: _menuAnimation,
            child: _isMenuOpen ? calcMenu() : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget calcPage() {
    return Column(children: [
      const SizedBox(
        height: 20,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: GestureDetector(
              onTap: () {
                _toggleDrawer();
              },
              child: Icon(
                !_isDrawerOpen
                    ? CupertinoIcons.list_bullet
                    : CupertinoIcons.multiply,
                size: 35,
                color: Theme.of(context).hintColor,
              )),
        ),
        Switch(
            value: widget.theme == ThemeMode.dark,
            activeColor: Colors.amber,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.orange,
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
              onClick: (String value) {
                if (_isDrawerOpen) {
                  _toggleDrawer();
                }
                setState(() {
                  _isMenuOpen = true;
                });
                _menuController.forward();
              }),
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
    ]);
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

  Widget history() {
    return Container(
      width: 225.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    historyDB = [];
                  });
                  saveList([]);
                },
                child: Container(
                    height: 40,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).hintColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("Delete All",
                        style: TextStyle(color: Theme.of(context).focusColor))),
              )
            ],
          ),
          const Divider(),
          historyDB.isEmpty
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.clock,
                          color: Theme.of(context).focusColor,
                          size: 30,
                        ),
                        const Text("No History")
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          ...historyDB.map(
            (e) {
              List<dynamic> split = e.split('=');
              return ListTile(
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 25, color: Theme.of(context).focusColor),
                    children: [
                      TextSpan(text: split[0]),
                      const TextSpan(text: '='),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          child: Text(
                            split[1],
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _toggleDrawer();
                  setState(() {
                    input = e.split('=')[0];
                  });
                  // evaluation(input);
                  // Navigate to Home or other logic
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget calcMenu() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(width: 0.2, color: Theme.of(context).focusColor),
      ),
      width: 225,
      height: 170,
      alignment: const Alignment(10, 10),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              Future.microtask(() {
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(builder: (context) => const Conversions()),
                );
              });
              if (_isDrawerOpen) {
                _toggleDrawer();
              }
              setState(() {
                _isMenuOpen = false;
              });
            },
            leading: Icon(
              CupertinoIcons.chart_bar_square,
              color: Theme.of(context).focusColor,
            ),
            title: Text("Conversions",
                style: TextStyle(color: Theme.of(context).focusColor)),
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.lab_flask,
              color: Theme.of(context).focusColor,
            ),
            title: Text("Scientific",
                style: TextStyle(color: Theme.of(context).focusColor)),
          ),
        ],
      ),
    );
  }
}
