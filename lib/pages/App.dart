import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:item_news/pages/Item/item.dart';

import 'Settings/settings.dart';

// todo 主题切换优化 ！
// todo 利用布局构造器实现适配大尺寸
// todo 可选 已读文章id存入【数据库】or【shared_preferences】实现已读、未读状态管理
// todo 文章列表显示日期,获取新列表索引长度，根据索引长度加载日期【变量日期-1】
// todo 消息离线推送
// bug 在跟随系统状态下，无法进行切换主题

class app extends StatefulWidget {
  const app({super.key});

  @override
  State<app> createState() => _appState();
}

class _appState extends State<app> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppbar(), body: item());
  }

  /// 标题栏
  AppBar _buildAppbar() {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 60,
      title: const Text('知乎日报',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
      actions: [
        Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () => Get.to(const settings()),
              icon: const Icon(Icons.settings, size: 26),
              tooltip: '设置',
            ))
      ],
      backgroundColor: Get.isDarkMode ? const Color.fromRGBO(48, 48, 48, 1) : Colors.white12,
      foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
      leading: leading_time(),
    );
  }

  /// 日期显示
  Widget leading_time() {
    DateTime dateTime = DateTime.now();
    return Row(children: [
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
              ])),
      const SizedBox(
          width: 1,
          height: 40,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.grey),
          ))
    ]);
  }
}
