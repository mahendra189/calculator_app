import 'package:calculator/constants/conversions_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calculator/widgets/button.dart';

class Conversions extends StatefulWidget {
  final Function? changeScreen;
  const Conversions({super.key, this.changeScreen});
  @override
  State<Conversions> createState() => _ConversionsPage();
}

class _ConversionsPage extends State<Conversions> {
  String _currentConversion = 'Length';
  String _input = '';
  String _converted = '';
  List<String> conversions = conversionsMap.keys.toList();
  Map<String, dynamic>? currentConversionMap = {};
  final TextEditingController _main = TextEditingController();
  final TextEditingController _secondary = TextEditingController();
  num _factor = 1;

  @override
  void initState() {
    update();
    currentConversionMap = conversionsMap[conversions.first];
  }

  void _factorChange(String value) {
    updateFactor();
    update();
  }

  void updateFactor() {
    if (currentConversionMap![_main.text] != null) {
      setState(() {
        _factor = currentConversionMap![_main.text]![_secondary.text]!;
      });
    }
  }

  void changeConversion(String c) {
    if (_currentConversion != c) {
      setState(() {
        _currentConversion = c;
        currentConversionMap = conversionsMap[c];
        _input = '';
        _converted = '';
      });
      updateFactor();
      update();
    }
  }

  void onChange(String value) {
    setState(() {
      _input += value;
      _converted = (_factor * num.parse(_input)).toString();
    });
  }

  void update() {
    if (_input.isNotEmpty) {
      setState(() {
        _converted = (_factor * num.parse(_input)).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  widget.changeScreen!();
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 25,
                  color: Theme.of(context).focusColor,
                )),
            Text(
              "Conversions",
              style: TextStyle(color: Theme.of(context).focusColor),
            )
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: conversions.map((c) {
                return _buildConversionCard(c, changeConversion,
                    active: _currentConversion == c);
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Divider(
            height: 0.1,
            endIndent: 15,
            indent: 15,
            color: Theme.of(context).primaryColor,
          ),
          currentConversion(currentConversionMap),
          // Numpad
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
                  content: "",
                  label: buttonIcon(CupertinoIcons.delete_left),
                  bg: Theme.of(context).canvasColor,
                  onClick: (String value) {
                    if (_input.isNotEmpty) {
                      setState(() {
                        _input = _input.substring(0, _input.length - 1);
                      });
                    }
                    update();
                  }),
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
                  content: "",
                  label: buttonIcon(CupertinoIcons.clear),
                  bg: Theme.of(context).canvasColor,
                  onClick: (String value) {
                    setState(() {
                      _input = "";
                      _converted = "";
                    });
                  }),
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
                  content: "",
                  label: buttonIcon(CupertinoIcons.up_arrow),
                  bg: Theme.of(context).canvasColor,
                  onClick: (String value) {})
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Button(
                  content: "",
                  label: buttonText(""),
                  bg: Theme.of(context).canvasColor,
                  onClick: (String value) {}),
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
                  label: buttonIcon(CupertinoIcons.down_arrow),
                  bg: Theme.of(context).canvasColor,
                  onClick: (String value) {})
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConversionCard(String title, Function onClick,
      {bool? active = false}) {
    return GestureDetector(
        onTap: () {
          onClick(title);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color:
                  active! ? Theme.of(context).canvasColor : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(30))),
          child: Text(title),
        ));
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

  Widget currentConversion(Map<String, dynamic>? currentMap) {
    return Column(children: [
      Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          DropdownMenu(
            initialSelection: currentMap!.keys.first,
            controller: _secondary,
            dropdownMenuEntries: currentMap.keys
                .map((l) => DropdownMenuEntry(value: l, label: l))
                .toList(),
            onSelected: (value) {
              _factorChange(value!);
            },
            inputDecorationTheme:
                const InputDecorationTheme(border: null, outlineBorder: null),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _converted,
            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 45),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 13, left: 10, right: 10),
            child: Text(
              "${currentMap.isNotEmpty && currentMap[_secondary.text] != null ? currentMap[_secondary.text]!['unit'] : 'unit'}",
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).focusColor),
            ),
          )
        ],
      ),
      Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          DropdownMenu(
            onSelected: (String? v) {
              _factorChange(v!);
            },
            initialSelection: currentMap.keys.first,
            controller: _main,
            dropdownMenuEntries: currentMap.keys
                .map((l) => DropdownMenuEntry(value: l, label: l))
                .toList(),
            inputDecorationTheme:
                const InputDecorationTheme(border: null, outlineBorder: null),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _input,
            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 45),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 13, left: 10, right: 10),
            child: Text(
              "${currentMap.isNotEmpty && currentMap[_main.text] != null ? currentMap[_main.text]!['unit'] : 'unit'}",
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).focusColor),
            ),
          )
        ],
      )
    ]);
  }
}
