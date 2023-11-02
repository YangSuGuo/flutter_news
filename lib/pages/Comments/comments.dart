import 'package:flutter/material.dart';
import 'package:get/get.dart';

class comments_page extends StatefulWidget {
  const comments_page({super.key});

  @override
  State<comments_page> createState() => _comments_pageState();
}

class _comments_pageState extends State<comments_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(Get.arguments["comments"].toString()),
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
      children: [
        Text('data')
      ],
    );
  }
}
