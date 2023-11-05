import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../http/net.dart';
import '../Essay/Widget/_itemIconButton.dart';

// 文章评论接口请求渲染

class comments_page extends StatefulWidget {
  const comments_page({super.key});

  @override
  State<comments_page> createState() => _comments_pageState();
}

class _comments_pageState extends State<comments_page> {
  int id = 9766161; // 初始值 id
  Map<String, dynamic> comments = {}; // 评论额外信息

  @override
  void initState() {
    super.initState();
    comments = Get.arguments["comments"];
    id = Get.arguments["id"];
    print("获取传值:${Get.arguments["id"]}");
  }

  // 文章长评信息
  Future<List<dynamic>> _getComments(int id) async {
    try {
      final response = await DioUtils.instance.dio
          .get('${HttpApi.zhihu_body}$id${HttpApi.zhihu_comments}');
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        final List<dynamic> comments = data['comments'];
        // print(comments.toString());
        return comments;
      } else {
        throw Exception('加载数据失败');
      }
    } catch (e) {
      throw Exception('错误：$e');
    }
  }

  // 文章短评信息
  Future<List<dynamic>> _getShort_Comments(int id) async {
    try {
      final response = await DioUtils.instance.dio
          .get('${HttpApi.zhihu_body}$id${HttpApi.zhihu_short_comments}');
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        final List<dynamic> comments = data['comments'];
        print(comments.toString());
        return comments;
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

  Widget _buildComments() {
    return ListView(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (comments['long_comments'] != 0) _buildLong_Comments(),
          if (comments['short_comments'] != 0) _buildShort_Comments()
        ],
      )
    ]);
  }

  /// 长评论
  Widget _buildLong_Comments() {
    return FutureBuilder<List<dynamic>>(
      future: _getComments(id),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        } else {
          List<dynamic> Long_Comments = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 0),
                child: Text(
                  '${comments['long_comments']} 条长评',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: Long_Comments.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> comment = Long_Comments[index];
                  return comments_widget(comment);
                },
              ),
            ],
          );
        }
      },
    );
  }

  /// 短评论
  Widget _buildShort_Comments() {
    return FutureBuilder<List<dynamic>>(
      future: _getShort_Comments(id),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center();
        } else {
          List<dynamic> shortComments = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 0),
                child: Text(
                  '${comments['short_comments']} 条短评',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: shortComments.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> comment = shortComments[index];
                  return comments_widget(comment);
                },
              ),
            ],
          );
        }
      },
    );
  }

  // 评论
  Widget comments_widget(Map<String, dynamic> comments) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 5, left: 12.5, right: 12.5, bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // '评论人',
            Row(
              children: [
                Text(comments['author'],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                SizedBox(
                  width: 43,
                  height: 43,
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.short_text_rounded,size: 30,)),
                )
              ],
            ),
            // 评论内容
            Text(
              comments['content'],
              textAlign: TextAlign.left,
              softWrap: true,
              style: const TextStyle(),
            ),
            if (comments['reply_to'] != null)
              // 回复
              Container(
                padding:
                    const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                decoration: const BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Row(
                  children: [
                    Text(
                      comments['reply_to']['author'] + '︰',
                      softWrap: true,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // todo 文本换行
                    Text(
                      comments['reply_to']['content'],
                      softWrap: true,
                    ),
                  ],
                ),
              ),

            // 评论时间
            Row(
              children: [
                Text(
                    DateFormat('MM-dd  hh∶mm')
                        .format(DateTime.fromMillisecondsSinceEpoch(
                            comments['time'] * 1000))
                        .toString(),

                    // '10-17 17:20'
                    style: const TextStyle(color: Colors.grey)),
                const Spacer(),
                // 点赞数量
                itemIconButton(
                  onPressed: () {},
                  icon: Icons.thumb_up_off_alt,
                  size: 20,
                  data: comments['likes'].toString(),
                ),
                const SizedBox(width: 10)
              ],
            )
          ],
        ));
  }
}
