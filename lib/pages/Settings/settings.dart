import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  bool _value = Get.isDarkMode;

  // 跳转
  Future<void> LaunchInBrowser(uni) async {
    if (!await launchUrl(
      uni,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('无法打开浏览器 $uni');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Settings(),
    );
  }

  /// 标题栏
  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: true,
      elevation: 0,
      title: const Text('设置'),
      backgroundColor:
          _value ? const Color.fromRGBO(48, 48, 48, 1) : Colors.white12,
      foregroundColor: _value ? Colors.white : Colors.black,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios, size: 20),
        splashColor: Colors.transparent,
      ),
    );
  }

  /// 设置项
  Widget Settings() {
    return Column(
      children: [
        SwitchListTile(
          activeColor: Colors.deepOrangeAccent,
          value: _value,
          onChanged: (v) {
            setState(() {
              _value = !_value;
              Get.changeTheme(_value ? ThemeData.dark() : ThemeData.light());
            });
          },
          secondary: _value
              ? const Icon(Icons.wb_sunny)
              : const Icon(Icons.nightlight_round),
          title: const Text('夜间模式'),
        ),
        const SizedBox(height: 5),
        const SizedBox(
            height: 1,
            width: 360,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.grey),
            )),
        const SizedBox(height: 5),
        _buildListTile('点个星星', "https://github.com/YangSuGuo/flutter_item1"),
        _buildListTile(
            '提交问题', 'https://github.com/YangSuGuo/flutter_item1/issues'),
        _buildListTile('作者信息', "https://github.com/YangSuGuo"),
        const SizedBox(height: 4),
        const SizedBox(
            height: 1,
            width: 360,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.grey),
            )),
        const SizedBox(height: 4),
        _buildListTile('证照一览', "https://www.zhihu.com/certificates"),
        _buildListTile('知乎协议', 'https://www.zhihu.com/plainterms'),
        const SizedBox(height: 10),
        // 按钮
        SizedBox(
          width: 360,
          height: 50,
          child: MaterialButton(
              color: _value ? Colors.black12 : Colors.white,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              onPressed: () {
                print('点击退出');
                showDialog(context: context, builder: (ctx) => dialog());
                // Dart虚拟机立即终止运行
                // exit(0);
              },
              child: const Text(
                '退出应用',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              )),
        ),
        const SizedBox(height: 10),
        const Text('当前版本：3.6.4（1270）', style: TextStyle(color: Colors.grey))
      ],
    );
  }

  /// 设置子项
  ListTile _buildListTile(title, http) {
    return ListTile(
      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
      title: Text(title),
      onTap: () => LaunchInBrowser(Uri.parse(http)),
    );
  }

  Widget dialog() {
    return AlertDialog(
      title: const Text('是否退出应用！'),
      actions: [
        TextButton(
          child: const Text('取消'),
          onPressed: () => Get.back(),
        ),
        TextButton(
          child: const Text('确定'),
          // Dart虚拟机立即终止运行
          onPressed: () => exit(0),
        )
      ],
    );
  }
}
