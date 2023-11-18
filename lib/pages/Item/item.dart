import 'dart:convert';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../http/net.dart';
import '../../Widget/CustomDialogs.dart';
import 'Widget/list.dart';

class item extends StatefulWidget {
  @override
  State<item> createState() => _itemState();
}

class _itemState extends State<item> {
  DateTime dateTime = DateTime.now(); // 时间
  List<Map<String, dynamic>> items = []; // 知乎日报
  int day = 0; //分页

  @override
  void initState() {
    super.initState();
    // 初始化数据
    InitialData();
  }

  // 初始化数据 2天数据
  Future<void> InitialData() async {
    try {
      final newItems = await _getList();
      final oldItems = await _getOldList(dateTime, day);
      setState(() {
        items.addAll(newItems);
        items.addAll(oldItems);
      });
    } catch (e) {
      CustomDialogs.confirmationDialog(
          title: '🚨无网络!',
          content: '请检查网络是否连接!',
          context: context,
          onCancel: false,
          onConfirm: (() => Get.back()));
      print('加载列表初始数据失败: $e');
    }
  }

  // 新鲜的知乎日报
  Future<List<Map<String, dynamic>>> _getList() async {
    try {
      final response = await DioUtils.instance.dio.get(HttpApi.zhihu_list);
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        final List<Map<String, dynamic>> items =
            data['stories'].cast<Map<String, dynamic>>();
        final formattedDate = DateFormat('yyyyMMdd').format(DateTime.now());
        print('数据为: $formattedDate');
        return items;
      } else {
        throw Exception('加载数据失败');
      }
    } catch (e) {
      CustomDialogs.confirmationDialog(
          title: '🚨无网络!',
          content: '请检查网络是否连接!',
          context: context,
          onCancel: false,
          onConfirm: (() => Get.back()));
      throw Exception('错误：$e');
    }
  }

  // 过去的知乎日报
  // bug 在新旧交替时，可能会出现数据加载重复的问题【原因可能是数据没更新，或者初始时间没更新】
  Future<List<Map<String, dynamic>>> _getOldList(DateTime date, int i) async {
    try {
      final formattedDate = DateFormat('yyyyMMdd').format(date);
      final response = await DioUtils.instance.dio
          .get('${HttpApi.zhihu_oldList}$formattedDate');
      if (response.statusCode == 200) {
        final data = json.decode(response.data);

        final List<Map<String, dynamic>> items =
            data['stories'].cast<Map<String, dynamic>>();
        day = i++;
        dateTime = date.subtract(Duration(days: i));
        print('数据为: $formattedDate');
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
          // 获取新数据
          final newItems = await _getList();
          // 截取已有数据的新数据条数，进行比对
          final oldItems = items.sublist(0, newItems.length);
          print(listEquals(oldItems, newItems));
          // 如果不相同，删除相应的旧数据，更新新数据
          if (!listEquals(oldItems, newItems)) {
            items.removeRange(0, oldItems.length);
            setState(() {
              // 添加数据
              items.insertAll(0, newItems);
            });
          }
        } catch (e) {
          CustomDialogs.confirmationDialog(
              title: '🚨无网络!',
              content: '请检查网络是否连接!',
              context: context,
              onCancel: false,
              onConfirm: (() => Get.back()));
        }
      },
      onLoad: () async {
        // 上拉加载
        try {
          final oldItems = await _getOldList(dateTime, day);
          if (oldItems.isNotEmpty) {
            setState(() {
              // 日期数据为真，加载一条数据后改为假
              items.addAll(oldItems);
            });
          }
        } catch (e) {
          CustomDialogs.confirmationDialog(
              title: '🚨无网络!',
              content: '请检查网络是否连接!',
              context: context,
              onCancel: false,
              onConfirm: (() => Get.back()));
        }
      },
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 2),
            child: Item(item: items[index]),
          );
        },
      ),
    );
  }
}
