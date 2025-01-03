import 'package:flutter/material.dart';

class DateBtn extends StatelessWidget {
  final void Function() onClicked;
  final IconData icnData;
  const DateBtn({super.key, required this.onClicked, required this.icnData});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
          height: 40,
          width: 40,
          color: Colors.white,
          alignment: Alignment.center,
          child: IconButton(
              onPressed: onClicked,
              icon: Icon(icnData))),
    );
  }
}
