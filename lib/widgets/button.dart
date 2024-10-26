import 'package:flutter/material.dart';

const double size = 80;

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
    return InkWell(
      onTap: () {
        onClick(content);
      },
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Center(child: label),
      ),
    );
  }
}
