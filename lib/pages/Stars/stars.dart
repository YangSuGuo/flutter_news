import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:item_news/Widget/remind.dart';
import 'package:item_news/pages/Item/Widget/list.dart';

import '../../db/db.dart';
import '../../models/history.dart';
import '../Essay/essay.dart';

class stars extends StatefulWidget {
  const stars({super.key});

  @override
  State<stars> createState() => _starsState();
}

class _starsState extends State<stars> {
  List<Map<String, dynamic>> items = []; // 收藏数据

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // 连接数据库
    final starsData = await DB.db.selectAllStars();
    for (final value in starsData) {
      setState(() {
        items.add(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: items.isNotEmpty ? _buildBody() : RemindWidget(),
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

  /// 收藏区
  Widget _buildBody() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 2),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                // 历史记录
                final HistoryData history = HistoryData();
                history.id = items[index]['id'];
                history.title = items[index]['title'];
                history.hint = items[index]['hint'];
                history.image = items[index]['image'];
                history.url = items[index]['url'];
                history.ga_prefix = items[index]['ga_prefix'];
                history.reading_time = DateTime.now().toIso8601String();
                DB.db.insertHistory(history);
                // todo 如果有就更新数据

                // 收藏数据
                Get.to(() => essay(), arguments: {
                  'id': items[index]['id'],
                  'title': items[index]['title'],
                  'link': items[index]['url'],
                  'description': items[index]['hint'],
                  'images': items[index]['image']
                });
              },
              child: Item(item: items[index]),
            ));
      },
    );
  }
}
