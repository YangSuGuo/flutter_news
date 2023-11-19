import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../http/net.dart';
import 'Widget/CommentWidget.dart';

class comments_page extends StatefulWidget {
  const comments_page({super.key});

  @override
  State<comments_page> createState() => _comments_pageState();
}

class _comments_pageState extends State<comments_page> {
  int id = 9766161; // 初始值 id
  Map<String, dynamic> comments = {}; // 评论额外信息
  bool support = false; // 点赞状态

  @override
  void initState() {
    super.initState();
    comments = Get.arguments["comments"];
    id = Get.arguments["id"];
    print("获取传值:${Get.arguments["id"]}");
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

  /// 评论区
  Widget _buildComments() {
    return ListView(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (comments['long_comments'] != 0) _buildLong_Comments(),
        if (comments['short_comments'] != 0) _buildShort_Comments()
      ])
    ]);
  }

  // 长评论
  Widget _buildLong_Comments() {
    // 异步加载
    return FutureBuilder<List<dynamic>>(
      future: HttpApi.getComments(id),
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
                  return CommentWidget(comment: Long_Comments[index]);
                },
              ),
            ],
          );
        }
      },
    );
  }

  // 短评论
  Widget _buildShort_Comments() {
    return FutureBuilder<List<dynamic>>(
      future: HttpApi.getShortComments(id),
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
                  return CommentWidget(comment: shortComments[index]);
                },
              ),
            ],
          );
        }
      },
    );
  }
}
