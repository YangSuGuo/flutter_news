import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:item_news/pages/Widget/item.dart';

import 'Settings/settings.dart';

class app extends StatefulWidget {
  const app({super.key});

  @override
  State<app> createState() => _appState();
}

class _appState extends State<app> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppbar(), body: Body());
  }

  /// Body
  Widget Body() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: item(),
        ),
      ],
    );
  }

  /// 标题栏
  AppBar _buildAppbar() {
    return AppBar(
      elevation: 0,
      leadingWidth: 60,
      title: const Text('知乎日报',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
      actions: [
        Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () => Get.to(const settings()),
              icon: const Icon(Icons.settings, size: 26),
              tooltip: '设置',
              splashColor: Colors.transparent,
            ))
      ],
      backgroundColor:
          Get.isDarkMode ? Color.fromRGBO(48, 48, 48, 1) : Colors.white12,
      foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
      // leading: Header()
      leading: leading_time(),
    );
  }

  Widget leading_time() {
    DateTime dateTime = DateTime.now();
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  DateFormat('dd').format(dateTime),
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Text(DateFormat('MM月').format(dateTime),
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            )),
        const SizedBox(
          width: 1,
          height: 40,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
