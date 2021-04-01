import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final String message;
  final Color textColor;
  final Color backgroundColor;
  Message(this.message,
      {this.textColor = Colors.black,
      this.backgroundColor = const Color(0xFFB3E5FC)});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: backgroundColor,
        child: Center(
            child: Column(
          children: [
            Expanded(child: Container()),
            Text('${this.message}',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: textColor,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                )),
            Expanded(child: Container())
          ],
        )));
  }
}
