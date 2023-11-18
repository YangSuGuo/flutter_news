import 'package:flutter/material.dart';

class ThemeTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final double horizontalPadding;

  const ThemeTile({
    Key? key,
    required this.text,
    required this.icon,
    required this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: horizontalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(icon, size: 30),
          Text(
            text,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
