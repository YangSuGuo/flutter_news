import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeTile extends StatelessWidget {
  final String text;
  final IconData icon;

  const ThemeTile({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: Get.width * 0.1,
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
