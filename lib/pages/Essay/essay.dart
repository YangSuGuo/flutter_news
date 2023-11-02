import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../http/net.dart';
import '../Comments/comments.dart';
import 'Widget/_itemIconButton.dart';

class essay extends StatefulWidget {
  @override
  State<essay> createState() => _essayState();
}

class _essayState extends State<essay> {
  Map<String, dynamic> items = {}; // 文章正文
  Map<String, dynamic> comments = {}; // 评论信息
  int id = 9766161; // 初始值 id

  @override
  void initState() {
    super.initState();
    // 初始化数据
    // todo 需要加载动画！！ok
    print("获取传值:${Get.arguments["id"]}");
    id = Get.arguments["id"];
    _getBody(id);
    _getComments(id);
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

  // 获取文章额外信息【评论，点赞】
  Future<void> _getComments(int id) async {
    try {
      final response =
          await DioUtils.instance.dio.get(HttpApi.zhihu_comments_info + '$id');
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        setState(() {
          comments = data;
        });

        print('获取评论数据成功');
      } else {
        throw Exception('获取评论数据失败');
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
    return Padding(padding: const EdgeInsets.only(top: 700), child: operate());
  }

  /// 操作列表
  Widget operate() {
    return Container(
        height: 70,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 4),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios),
                )),
            const SizedBox(
              width: 1,
              height: 30,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 评论
                  itemIconButton(
                    icon: Icons.messenger_outline,
                    onPressed: () =>
                        Get.to(comments_page(), arguments: {'id': items['id'],'comments': comments['comments']}),
                    data: comments['comments'].toString(),
                  ),
                  IconButton(
                      icon: const Icon(
                        Icons.star_border_rounded,
                        size: 28,
                      ),
                      onPressed: () => Get.back()),
                  IconButton(
                    icon: const Icon(Icons.loop),
                    onPressed: () => Get.back(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_rounded),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
