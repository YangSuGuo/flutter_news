import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Item/Widget/list.dart';

class stars extends StatefulWidget {
  const stars({super.key});

  @override
  State<stars> createState() => _starsState();
}

class _starsState extends State<stars> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      // body: _buildBody(),
    );
  }

  /// 标题栏
  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: true,
      elevation: 0,
      title: const Text('收藏'),
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

  /// 收藏列表
  Widget _buildBody(Map<String, dynamic> items){
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 2),
          child: Item(item: items[index]),
        );
      },
    );
  }
}
