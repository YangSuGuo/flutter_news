import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:item_news/pages/Item/item.dart';

import 'Settings/settings.dart';

// todo 主题切换优化 ！
// todo 利用布局构造器实现适配平板
// todo 可选 轮播图组件实现 ！！
// todo 可选 已读文章id存入【数据库】or【shared_preferences】实现已读、未读状态管理
// todo 可选 持久化主题状态【shared_preferences】，自动跟随系统主题
// todo 可选 json 实体化
// todo 文章列表显示日期
// todo 将数据库和网络请求的api，类型转换，api独立分成
// todo 消息离线推送

class app extends StatefulWidget {
  const app({super.key});

  @override
  State<app> createState() => _appState();
}

class _appState extends State<app> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppbar(), body: _buildBody());
  }

  /// 标题栏
  AppBar _buildAppbar() {
    return AppBar(
      elevation: 0,
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
      backgroundColor:
          Get.isDarkMode ? const Color.fromRGBO(48, 48, 48, 1) : Colors.white12,
      foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
      leading: leading_time(),
    );
  }

  /// 日期显示
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

  /// Body
  Widget _buildBody() {
    return Padding(
        padding: const EdgeInsets.only(top: 0),
        child: item()
    );
  }
}
