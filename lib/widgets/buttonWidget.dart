import 'package:flutter/material.dart';

class Buttonwidget extends StatelessWidget {
  final Color bgColor;
  final String buttonLabel;
  final void Function() onClick;

  const Buttonwidget(
      {super.key,
      required this.bgColor,
      required this.buttonLabel,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)
        )
      ),
      onPressed: onClick,
      child: Padding(
        // padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1),
        child: Text(
          buttonLabel,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
