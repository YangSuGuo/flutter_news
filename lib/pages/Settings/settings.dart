import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:item_news/pages/Stars/stars.dart';

import '../../Widget/CustomDialogs.dart';
import 'Widget/ListTile.dart';

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
            Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 0.0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Text(
                        '界面',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.7,
                        ),
                      ),
                    ),
                    ToggleButtons(
                      isSelected: _isSelected,
                      onPressed: (value) => setState(() {
                        _isSelected = _isSelected.map((e) => false).toList();
                        _isSelected[value] = true;
                        if (value == 0) {
                          // todo 跟随系统实现
                        } else if (value == 1) {
                          Get.changeTheme(ThemeData.light());
                        } else if (value == 2) {
                          Get.changeTheme(ThemeData.dark());
                        }
                      }),
                      renderBorder: false,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                top: 10,
                                left: MediaQuery.of(context).size.width / 10,
                                right: MediaQuery.of(context).size.width / 10,
                                bottom: 10),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.brightness_4, size: 30),
                                Text('跟随系统', style: TextStyle(fontSize: 10))
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 10,
                                left: MediaQuery.of(context).size.width / 9,
                                right: MediaQuery.of(context).size.width / 9,
                                bottom: 10),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.wb_sunny, size: 30),
                                Text('日间模式', style: TextStyle(fontSize: 10))
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 10,
                                left: MediaQuery.of(context).size.width / 10,
                                right: MediaQuery.of(context).size.width / 10,
                                bottom: 10),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.nightlight_round, size: 30),
                                Text('夜间模式', style: TextStyle(fontSize: 10))
                              ],
                            ))
                      ],
                    ),
                  ],
                )),
            // 功能界面
            Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 0.0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Text(
                        '功能',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.7,
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('收藏夹'),
                      visualDensity: const VisualDensity(vertical: -4),
                      onTap: () => Get.to(const stars()),
                    ),
                    ListTile(
                      title: const Text('推送中心'),
                      visualDensity: const VisualDensity(vertical: -3),
                      onTap: () => Get.to(const stars()),
                    ),
                  ],
                )),
            // 关于
            const Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Text(
                        '关于',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.7,
                        ),
                      ),
                    ),
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
                  ],
                )),
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
}
