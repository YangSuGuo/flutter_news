import 'package:flutter/material.dart';

class CustomHeaderText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double fontSize;

  const CustomHeaderText({
    Key? key,
    required this.text,
    this.color = Colors.lightBlue,
    this.fontWeight = FontWeight.bold,
    this.fontSize = 12.7,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
