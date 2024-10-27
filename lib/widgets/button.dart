import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Widget label;
  final Color bg;
  final dynamic onClick;
  final String content;
  const Button(
      {super.key,
      required this.label,
      required this.content,
      required this.bg,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width / 4.5;

    return Padding(
        padding: const EdgeInsets.all(3),
        child: InkWell(
          onTap: () {
            onClick(content);
          },
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Center(child: label),
          ),
        ));
  }
}
