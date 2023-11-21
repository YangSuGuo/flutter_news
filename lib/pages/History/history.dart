import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:item_news/pages/Item/Widget/list.dart';

import '../../db/db.dart';
import '../Essay/essay.dart';

class history extends StatefulWidget {
  const history({super.key});

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  List<Map<String, dynamic>> items = []; // 历史数据

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // 连接数据库
    final historyData = await DB.db.selectAllHistory();
    for (final value in historyData) {
      setState(() {
        items.add(value);
      });
    }
    print(items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  /// 标题栏
  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: true,
      elevation: 0,
      title: const Text('历史记录'),
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

  /// 列表区
  Widget _buildBody() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 2),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.to(() => essay(), arguments: {
              'id': items[index]['id'],
              'title': items[index]['title'],
              'link': items[index]['url'],
              'description': items[index]['hint'],
              'images': items[index]['image']
            }),
            child: Item(item: items[index]),
          ));
      },
    );
  }
}
