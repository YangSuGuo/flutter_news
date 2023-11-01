import 'package:flutter/material.dart';
import 'package:get/get.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  bool _value = Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Settings(),
    );
  }

  Widget Settings() {
    return Column(
      children: [
        const SizedBox(height: 45),
        SwitchListTile(
          value: _value,
          onChanged: (v) {
            setState(() {
              _value = !_value;
              Get.changeTheme(_value ? ThemeData.dark() : ThemeData.light());
            });
          },
          secondary: const Icon(Icons.dark_mode),
          title: const Text('夜间模式'),
        )
      ],
    );
  }
}
