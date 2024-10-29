import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData? icon;
  final Function? onClick;
  final String? label;
  const DrawerItem({super.key, this.icon, this.onClick, this.label});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Scaffold.of(context).closeDrawer();
        onClick!();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Icon(
                  icon != null ? icon! : CupertinoIcons.question,
                  size: 40,
                  color: Theme.of(context).focusColor,
                )),
            Expanded(
              child: Text(
                label != null ? label! : 'Title',
                style: TextStyle(
                    fontSize: 20, color: Theme.of(context).focusColor),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
