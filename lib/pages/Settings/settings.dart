import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  List<bool> _isSelected = [false, !Get.isDarkMode, Get.isDarkMode]; // 主题设置

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
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 50,
              right: MediaQuery.of(context).size.width / 50),
          child: Column(children: [
            // 用户界面
            CustomCard(children: [
              const CustomHeaderText(text: '界面'),
              ToggleButtons(
                isSelected: _isSelected,
                onPressed: (value) => setState(() {
                  _isSelected = _isSelected.map((e) => false).toList();
                  _isSelected[value] = true;
                  if (value == 0) {
                    // todo 跟随系统实现
                    // 对话框
                    Get.defaultDialog(
                        title: '标题',
                        middleText: '这是描述信息！',
                        confirm: SizedBox(
                          // height: 35,
                            width: MediaQuery.of(context).size.width / 1.65,
                            child: MaterialButton(
                              elevation: 0,
                              color: Get.isDarkMode ? Colors.black12 : Colors.lightBlue.shade50,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              child: Text('确定',style: TextStyle(color: Colors.deepOrange.shade500,fontSize: 14,fontWeight: FontWeight.bold),),
                              onPressed: () {},
                            )),
                        radius: 10,
                        barrierDismissible: true);
                  } else if (value == 1) {
                    Get.changeTheme(ThemeData.light());
                  } else if (value == 2) {
                    Get.changeTheme(ThemeData.dark());
                  }
                }),
                renderBorder: false,
                children: [
                  ThemeTile(
                      text: '跟随系统',
                      icon: Icons.brightness_4,
                      horizontalPadding:
                          MediaQuery.of(context).size.width / 10),
                  ThemeTile(
                      text: '日间模式',
                      icon: Icons.wb_sunny,
                      horizontalPadding: MediaQuery.of(context).size.width / 9),
                  ThemeTile(
                      text: '夜间模式',
                      icon: Icons.nightlight_round,
                      horizontalPadding:
                          MediaQuery.of(context).size.width / 10),
                ],
              ),
            ]),
            // 功能界面
            CustomCard(children: [
              const CustomHeaderText(text: '功能'),
              ListTile(
                title: const Text('收藏夹'),
                visualDensity: const VisualDensity(vertical: -4),
                onTap: () => Get.to(const stars()),
              ),
              ListTile(
                title: const Text('实验室'),
                visualDensity: const VisualDensity(vertical: -3),
                onTap: () {},
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
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: MaterialButton(
                  color: _value ? Colors.black12 : Colors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  onPressed: () {
                    CustomDialogs.confirmationDialog(
                        title: '是否退出应用!',
                        context: context,
                        onCancel: true,
                        onConfirm: (() => exit(0)));
                  },
                  child: const Text(
                    '退出应用',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )),
            ),
            const SizedBox(height: 10),
            const Text('当前版本：3.6.4（1270）', style: TextStyle(color: Colors.grey))
          ]))
    ]);
  }

/*  static updateTheme() {
    Future.delayed(const Duration(milliseconds: 300), () {
      Get.forceAppUpdate();
    });
  }*/
}
