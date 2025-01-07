import 'package:flutter/material.dart';

class Buttonwidget extends StatefulWidget {
  final Color bgColor;
  final String buttonLabel;
  final dynamic onClick;

  const Buttonwidget(
      {super.key,
      required this.bgColor,
      required this.buttonLabel,
      required this.onClick});

  @override
  State<Buttonwidget> createState() => _ButtonwidgetState();
}

class _ButtonwidgetState extends State<Buttonwidget> {
  bool isLoading = false;

  void handleClick() async {
    setState(() {
      isLoading = true;
    });

    try {
      await widget.onClick();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: widget.bgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      onPressed: isLoading ? null : handleClick,
      child: Padding(
        // padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                widget.buttonLabel,
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
