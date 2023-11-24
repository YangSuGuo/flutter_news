import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:item_news/pages/History/model/history_model.dart';
import 'package:item_news/pages/Item/model/stories_model.dart';
import 'package:item_news/pages/Item/Widget/list.dart';

import '../../db/db.dart';
import '../Essay/essay.dart';

class history extends StatefulWidget {
  const history({super.key});

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  List<StoriesData> items = []; // 历史数据

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final historyData = await DB.db.selectAllHistory();
    setState(() => items = historyData);
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
              onTap: () => Get.to(() => essay(), arguments: {'item': items[index]}),
              child: Item(item: items[index]),
            ));
      },
    );
  }
}
