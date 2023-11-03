import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../http/net.dart';
import '../Essay/Widget/_itemIconButton.dart';

class comments_page extends StatefulWidget {
  const comments_page({super.key});

  @override
  State<comments_page> createState() => _comments_pageState();
}

class _comments_pageState extends State<comments_page> {
  int id = 9766161; // 初始值 id
  Map<String, dynamic> comments = {}; // 评论额外信息
  List<Map<Map<String,dynamic>, dynamic>> comments_info = []; // 长评论信息
  List<Map<Map<String,dynamic>, dynamic>> short_comments_info = []; // 短评论信息

  @override
  void initState() {
    super.initState();
    comments = Get.arguments["comments"];
    id = Get.arguments["id"];
    // setState(() {
    //   comments_info = _getComments(id) as List<Map<Map<String, dynamic>, dynamic>>;
    //   short_comments_info = _getShort_Comments(id) as List<Map<Map<String, dynamic>, dynamic>>;
    // });
    print(comments_info);
  }

  // 文章长评论信息
  Future<List<Map<Map<String,dynamic>, dynamic>>> _getComments(int id) async {
    try {
      final response = await DioUtils.instance.dio.get(HttpApi.zhihu_body + '$id'+ HttpApi.zhihu_comments);
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        final List<Map<Map<String,dynamic>, dynamic>> items =
        data['comments'].cast<Map<Map<String,dynamic>, dynamic>>();
        return items;
      } else {
        throw Exception('加载数据失败');
      }
    } catch (e) {
      throw Exception('错误：$e');
    }
  }

  // 文章长评论信息
  Future<List<Map<Map<String,dynamic>, dynamic>>> _getShort_Comments(int id) async {
    try {
      final response = await DioUtils.instance.dio.get(HttpApi.zhihu_body + '$id'+ HttpApi.zhihu_short_comments);
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        final List<Map<Map<String,dynamic>, dynamic>> items =
        data['comments'].cast<Map<Map<String,dynamic>, dynamic>>();
        return items;
      } else {
        throw Exception('加载数据失败');
      }
    } catch (e) {
      throw Exception('错误：$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(comments['comments'].toString()),
      body: _buildComments(),
    );
  }

  /// 标题栏
  AppBar _buildAppBar(String date) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: true,
      elevation: 0,
      title: Text('$date 条评论'),
      backgroundColor:
          Get.isDarkMode ? const Color.fromRGBO(48, 48, 48, 1) : Colors.white12,
      foregroundColor: Get.isDarkMode ? Colors.white : Colors.black,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios, size: 20),
        splashColor: Colors.transparent,
      ),
    );
  }

  /// 评论
  Widget _buildComments() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(comments['long_comments'] != 0)
        Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 0),
            child: Text(
              '${comments['long_comments']} 条长评',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
        if(comments['long_comments'] != 0)
        long_comments(),
        Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              '${comments['short_comments']} 条短评',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
        long_comments()
      ],
    );
  }

  // 长评论
  Widget long_comments() {
    return Padding(
        padding: const EdgeInsets.only(top: 5,left: 12.5,right: 12.5,bottom: 5),
        child: Column(
          children: [
            Row(
              children: [
                const Text(

                    // comments_info['content'],
                    '评论人',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                itemIconButton(
                    onPressed: () {}, icon: Icons.short_text_rounded),
              ],
            ),
            // SizedBox(height: 10),
            const Text(
                'pl000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'),
            Row(
              children: [
                Text('10-17 17:20', style: TextStyle(color: Colors.grey)),
                const Spacer(),
                itemIconButton(
                  onPressed: () {},
                  icon: Icons.thumb_up_off_alt,
                  size: 20,
                  data: "21",
                ),
                const SizedBox(width: 10)
              ],
            )
          ],
        ));
  }
}
