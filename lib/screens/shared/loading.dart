import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String label;
  final Color spinningColor;
  final Color backgroundColor;
  final Color textColor;
  Loading(
      {this.label = 'Loading',
      this.spinningColor = Colors.purpleAccent,
      this.backgroundColor = const Color(0xFFB3E5FC),
      this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: backgroundColor,
        child: Center(
            child: Column(
          children: [
            Expanded(child: Container()),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(spinningColor),
            ),
            Container(
              height: 20,
            ),
            Text(this.label,
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
