import 'dart:convert';

import 'package:intl/intl.dart';

import 'net.dart';

class HttpApi {
  // 知乎日报 列表
  static const String zhihu_list = 'stories/latest';

  // 知乎日报 正文 {id}
  static const String zhihu_body = 'story/';

  // 知乎日报 过去的 {yyyyMMdd}
  static const String zhihu_oldList = 'stories/before/';

  // 知乎日报 长评论 {id}
  static const String zhihu_comments = 'story/{id}/long-comments';

  // 知乎日报 短评论 {id}
  static const String zhihu_short_comments = 'story/{id}/short-comments';

  DateTime dateTime = DateTime.now(); // 时间
  int day = 0; //分页

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
      throw Exception('错误：$e');
    }
  }

  // 过去的知乎日报
  // bug 在新旧交替时，可能会出现数据加载重复的问题【原因是数据索引错误】
  Future<List<Map<String, dynamic>>> _getOldList(DateTime date, int i) async {
    try {
      DateTime dateTime = DateTime.now();
      final formattedDate = DateFormat('yyyyMMdd').format(date);
      final response = await DioUtils.instance.dio
          .get(HttpApi.zhihu_oldList + '$formattedDate');
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
}
