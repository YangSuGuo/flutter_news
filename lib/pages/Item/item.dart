import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:item_news/pages/Essay/essay.dart';
import 'package:item_news/pages/Item/model/stories_model.dart';

import '../../../http/net.dart';
import '../../Widget/CustomDialogs.dart';
import '../../db/db.dart';
import '../History/model/history_model.dart';
import 'Widget/list.dart';

class item extends StatefulWidget {
  @override
  State<item> createState() => _itemState();
}

class _itemState extends State<item> {
  DateTime dateTime = DateTime.now(); // 时间
  List<StoriesData> items = []; // 知乎日报
  bool read = false; // 阅读状态

  @override
  void initState() {
    super.initState();
    // 初始化数据
    InitialData();
  }

  // 初始化数据 2天数据
  Future<void> InitialData() async {
    try {
      final newItems = await HttpApi.getList();
      final oldItems = await HttpApi.getOldList(dateTime);
      // todo 获取初始化的阅读状态
      setState(() {
        items.addAll(newItems);
        items.addAll(oldItems);
      });

      dateTime = dateTime.subtract(const Duration(days: 1));
    } catch (e) {
      CustomDialogs.confirmationDialog(
          title: '🚨网络异常!',
          content: '请检查网络是否连接!',
          context: context,
          cancel: false,
          confirm: true,
          buttonMinWidth: false,
          onConfirm: (() {
            InitialData();
            Get.back();
          }));
      print('加载列表初始数据失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildList();
  }

  // bodyList
  // bug 无网络时初始化失败无数据，下拉刷新失败
  // bug 无网络时初始化失败，上拉刷新成功，下拉刷新会将上拉刷新的覆盖【 items.removeRange(0, oldItems.length) 】
  // bug listEquals(oldItems, newItems) 比对结果错误
  Widget _buildList() {
    return EasyRefresh(
        header: const ClassicHeader(
          hapticFeedback: true,
          hitOver: true,
          safeArea: false,
          processedDuration: Duration.zero,
          showMessage: false,
          showText: false,
        ),
        footer: const ClassicFooter(
          hapticFeedback: true,
          processedDuration: Duration.zero,
          showMessage: false,
          showText: false,
        ),
        onRefresh: () async {
          // 下拉刷新
          try {
            final newItems = await HttpApi.getList();
            final oldItems = items.sublist(0, newItems.length);
            print(listEquals(oldItems, newItems));
            if (!listEquals(oldItems, newItems)) {
              items.removeRange(0, oldItems.length);
              setState(() {
                items.insertAll(0, newItems);
              });
            }
          } catch (e) {
            CustomDialogs.confirmationDialog(
                title: '🚨网络异常!',
                content: '请检查网络是否连接!',
                context: context,
                cancel: false,
                confirm: true,
                buttonMinWidth: false,
                onConfirm: (() {
                  Get.back();
                }));
          }
        },
        onLoad: () async {
          // 上拉加载
          try {
            final oldItems = await HttpApi.getOldList(dateTime);
            if (oldItems.isNotEmpty) {
              setState(() {
                // 日期数据 为真，加载一条数据后改为假
                items.addAll(oldItems);
              });
              dateTime = dateTime.subtract(const Duration(days: 1));
            }
          } catch (e) {
            CustomDialogs.confirmationDialog(
                title: '🚨网络异常!',
                content: '请检查网络是否连接!',
                context: context,
                cancel: false,
                confirm: true,
                buttonMinWidth: false,
                onConfirm: (() {
                  Get.back();
                }));
          }
        },
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 2),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    // 历史记录
                    final HistoryData history = HistoryData(
                        id: items[index].id,
                        title: items[index].title,
                        hint: items[index].hint,
                        image: items[index].image,
                        url: items[index].url,
                        ga_prefix: items[index].ga_prefix,
                        reading_time: DateTime.now().toString());
                    List result = await DB.db.selectHistory(items[index].id!);
                    read = !result.isNotEmpty;
                    if (read) {
                      DB.db.insertHistory(history);
                    } else {
                      DB.db.updateHistory(history);
                      print('更新数据');
                    }

                    // todo 如果有就更新数据
                    // 收藏数据
                    Get.to(() => essay(), arguments: {'item': items[index]});
                  },
                  child: Item(item: items[index]),
                ));
          },
        ));
  }
}
