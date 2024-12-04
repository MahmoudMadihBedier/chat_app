import 'package:chat_app/theming/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  String text;
  VoidCallback onPressrd;
  Color color;
  ButtonWidget({required this.text, required this.color,required this.onPressrd});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 5,
      child: MaterialButton(
          height: 50,
          color: color,
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onPressrd),
    );
  }
}
