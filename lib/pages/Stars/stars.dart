import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:item_news/Widget/remind.dart';
import 'package:item_news/models/stars.dart';
import 'package:item_news/pages/Item/Widget/list.dart';

import '../../db/db.dart';
import '../../models/history.dart';
import '../../models/stories.dart';
import '../Essay/essay.dart';

class stars extends StatefulWidget {
  const stars({super.key});

  @override
  State<stars> createState() => _starsState();
}

class _starsState extends State<stars> {
  List<StoriesData> items = []; // 收藏数据

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // 连接数据库
    final starsData = await DB.db.selectAllStars();
    setState(() => items = starsData);
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
                final HistoryData history = HistoryData(
                    id: items[index].id,
                    title: items[index].title,
                    hint: items[index].hint,
                    image: items[index].image,
                    url: items[index].url,
                    ga_prefix: items[index].ga_prefix,
                    reading_time: DateTime.now().toString());
                DB.db.insertHistory(history);
                // todo 如果有就更新数据

                // 收藏数据
                Get.to(() => essay(), arguments: {'item': items[index]});
              },
              child: Item(item: items[index]),
            ));
      },
    );
  }
}
