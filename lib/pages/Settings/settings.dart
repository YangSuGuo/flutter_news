import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:item_news/pages/History/history.dart';
import 'package:item_news/pages/Stars/stars.dart';

import '../../Widget/CustomDialogs.dart';
import 'Widget/CardColumn.dart';
import 'Widget/CustomHeaderText.dart';
import 'Widget/ListTile.dart';
import 'Widget/ThemeTile.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  final bool _value = Get.isDarkMode;
  List<bool> _isSelected = [true, false, false]; // 主题设置

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildSettings(),
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

  /// 设置
  Widget _buildSettings() {
    return ListView(children: [
      Padding(
          padding: EdgeInsets.only(left: Get.width / 50, right: Get.width / 50),
          child: Column(children: [
            // 用户界面
            CustomCard(children: [
              const CustomHeaderText(text: '界面'),
              // todo 重构此组件，自己实现【有屏幕适配问题】
              // todo 在md3下颜色为MD3默认颜色：紫色，MD2为蓝色
              ToggleButtons(
                isSelected: _isSelected,
                onPressed: (value) => setState(() {
                  _isSelected = _isSelected.map((e) => false).toList();
                  _isSelected[value] = true;
                  if (value == 0) {
                    // todo 跟随系统实现
                    // Get.snackbar("跟随系统", "欢迎使用Snackbar");
                  } else if (value == 1) {
                    Get.changeTheme(ThemeData.light());
                  } else if (value == 2) {
                    Get.changeTheme(ThemeData.dark());
                  }
                }),
                renderBorder: false,
                children: const [
                  ThemeTile(
                    text: '跟随系统',
                    icon: Icons.brightness_4,
                  ),
                  ThemeTile(
                    text: '日间模式',
                    icon: Icons.wb_sunny,
                  ),
                  ThemeTile(
                    text: '夜间模式',
                    icon: Icons.nightlight_round,
                  ),
                ],
              ),
            ]),
            // 功能界面
            CustomCard(children: [
              const CustomHeaderText(text: '功能'),
              ListTile(
                title: const Text('实验室'),
                visualDensity: const VisualDensity(vertical: -3),
                onTap: () {},
              ),
              ListTile(
                title: const Text('收藏夹'),
                visualDensity: const VisualDensity(vertical: -4),
                onTap: () => Get.to(const stars()),
              ),
              ListTile(
                title: const Text('历史记录'),
                visualDensity: const VisualDensity(vertical: -4),
                onTap: () => Get.to(const history()),
              ),
            ]),
            // 关于
            const CustomCard(children: [
              CustomHeaderText(text: '关于'),
              CustomListTile(
                title: '作者信息',
                http: 'https://github.com/YangSuGuo',
              ),
              CustomListTile(
                title: '项目地址',
                http: 'https://github.com/YangSuGuo/flutter_news',
              ),
              CustomListTile(
                title: '证照一览',
                http: '"https://www.zhihu.com/certificates',
              ),
              CustomListTile(
                title: '知乎用户协议',
                http: 'https://www.zhihu.com/plainterms',
              )
            ]),
            SizedBox(
              width: Get.width,
              height: 50,
              child: MaterialButton(
                  color: Get.isDarkMode ? Colors.black12 : Colors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  onPressed: () {
                    CustomDialogs.confirmationDialog(
                        title: '是否退出应用!',
                        context: context,
                        cancel: true,
                        confirm: true,
                        buttonMinWidth: true,
                        onConfirm: (() => exit(0)));
                  },
                  child: const Text(
                    '退出应用',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )),
            ),
            const SizedBox(height: 10),
            const Text('当前版本：1.3.4', style: TextStyle(color: Colors.grey))
          ]))
    ]);
  }
}
