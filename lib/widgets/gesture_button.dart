import 'package:flutter/material.dart';
import 'package:toys/styles/custom.dart';

RaisedButton buildRaisedButton(String text, Color buttonColor, Color color,
      GestureTapCallback onPressed) {
    return RaisedButton(
      onPressed: onPressed,
      color: buttonColor,
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
    );
  }
class GestureButton extends StatelessWidget {
  GestureTapCallback onPressed;
  String text;

  GestureButton({this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onPressed, child: Text(text, style:Custom().linkButtonTextStyle,));
  }
}

class PrimaryButton extends StatelessWidget {
  String text;
  Color buttonColor, textColor;
  GestureTapCallback onPressed;
  PrimaryButton({this.text, this.buttonColor, this.onPressed, this.textColor});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      color: buttonColor,
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }
}