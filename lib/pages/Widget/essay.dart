import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../http/net.dart';

class essay extends StatefulWidget {

  @override
  State<essay> createState() => _essayState();
}

class _essayState extends State<essay> {
  Map<String, dynamic> items = {}; // 文章正文
  int id = 9766161; // 初始值 id

  @override
  void initState() {
    super.initState();
    // 初始化数据
    // todo 需要加载动画！！ok
    print("获取传值:${Get.arguments["id"]}");
    id = Get.arguments["id"];
    _getBody(id);
  }

  // 获取文章正文
  Future<void> _getBody(int id) async {
    try {
      final response =
          await DioUtils.instance.dio.get(HttpApi.zhihu_body + '$id');
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        setState(() {
          items = data;
        });
        print('获取正文数据成功');
      } else {
        throw Exception('获取正文数据失败');
      }
    } catch (e) {
      throw Exception('错误：$e');
    }
  }

  // 跳转文章原文
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
    return Scaffold(body: items.isEmpty ? const GFLoader() : _buildBody());
  }

  Widget _buildBody() {
    return const Text('data');
  }
}
