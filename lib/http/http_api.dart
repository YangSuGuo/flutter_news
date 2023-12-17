import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:item_news/pages/Essay/model/commentsinfo_model.dart';

import '../pages/Comments/model/comments_model.dart';
import '../pages/Item/model/stories_model.dart';
import 'net.dart';

class HttpApi {
  // 知乎日报 列表
  static const String zhihu_list = 'stories/latest';

  // 知乎日报 正文 {id}
  static const String zhihu_body = 'story/';

  // 知乎日报 过去的 {yyyyMMdd}
  static const String zhihu_oldList = 'stories/before/';

  // 知乎日报 评论信息 {id}
  static const String zhihu_comments_info = 'story-extra/';

  // 知乎日报 长评论 {id}
  static const String zhihu_comments = '/long-comments';

  // 知乎日报 短评论 {id}
  static const String zhihu_short_comments = '/short-comments';

  // 今日日报
  static Future<List<StoriesData>> getList() async {
    try {
      final response = await DioUtils.instance.dio.get(HttpApi.zhihu_list);
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        final List<dynamic> dataList = data['stories'];
        final List<StoriesData> items =
            dataList.map((json) => StoriesData.fromJson(json)).toList();
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

  // 旧日日报
  // bug 在新旧交替时，可能会出现数据加载重复的问题【原因可能是数据没更新，或者初始时间没更新】
  static Future<List<StoriesData>> getOldList(DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyyMMdd').format(date);
      final response = await DioUtils.instance.dio
          .get('${HttpApi.zhihu_oldList}$formattedDate');
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        final List<dynamic> dataList = data['stories'];
        final List<StoriesData> items =
            dataList.map((json) => StoriesData.fromJson(json)).toList();
        print('数据为: $formattedDate');
        return items;
      } else {
        throw Exception('加载数据失败');
      }
    } catch (e) {
      throw Exception('错误：$e');
    }
  }

  // 轮播图数据
  static Future<List<Map<String, dynamic>>> getSwiper() async {
    try {
      final response = await DioUtils.instance.dio.get(HttpApi.zhihu_list);
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        final List<Map<String, dynamic>> items =
            data['top_stories'].cast<Map<String, dynamic>>();
        return items;
      } else {
        throw Exception('加载数据失败');
      }
    } catch (e) {
      throw Exception('错误：$e');
    }
  }

  // 获取文章评论,点赞信息
  static Future<CommentInfoData> getCommentsInfo(int id) async {
    try {
      final response =
          await DioUtils.instance.dio.get('${HttpApi.zhihu_comments_info}$id');
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        final CommentInfoData commentInfoData = CommentInfoData.fromJson(data);
        return commentInfoData;
      } else {
        throw Exception('获取评论数据失败');
      }
    } catch (e) {
      throw Exception('错误：$e');
    }
  }

  // 长评论
  static Future<List<CommentsData>> getComments(int id) async {
    try {
      final response = await DioUtils.instance.dio
          .get('${HttpApi.zhihu_body}$id${HttpApi.zhihu_comments}');
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        final List<dynamic> commentsJson = data['comments'];
        List<CommentsData> comments =
            commentsJson.map((json) => CommentsData.fromJson(json)).toList();
        return comments;
      } else {
        throw Exception('加载数据失败');
      }
    } catch (e) {
      throw Exception('错误：$e');
    }
  }

  // 短评论
  static Future<List<CommentsData>> getShortComments(int id) async {
    try {
      final response = await DioUtils.instance.dio
          .get('${HttpApi.zhihu_body}$id${HttpApi.zhihu_short_comments}');
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        final List<dynamic> commentsJson = data['comments'];
        List<CommentsData> comments =
            commentsJson.map((json) => CommentsData.fromJson(json)).toList();
        return comments;
      } else {
        throw Exception('加载数据失败');
      }
    } catch (e) {
      throw Exception('错误：$e');
    }
  }
}
