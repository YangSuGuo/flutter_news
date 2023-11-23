import 'dart:convert';

import 'package:item_news/models/stories.dart';

HistoryData historyDataFromJson(String str) =>
    HistoryData.fromJson(json.decode(str));

String historyDataToJson(HistoryData data) => json.encode(data.toJson());

/// 历史记录数据
class HistoryData {
  HistoryData({
    this.id,
    this.title,
    this.hint,
    this.image,
    this.url,
    this.ga_prefix,
    this.reading_time,
  });

  // ID
  late int? id;

  // 标题
  late String? title;

  // 描述
  late String? hint;

  // 图片
  late String? image;

  // 链接
  late String? url;

  // 日报时间
  late String? ga_prefix;

  // 阅读时间
  late String? reading_time;

  factory HistoryData.fromJson(Map<String, dynamic> json) => HistoryData(
        id: json['id'],
        title: json['title'],
        hint: json['hint'],
        image: json['image'],
        url: json['url'],
        ga_prefix: json['ga_prefix'],
        reading_time: json['reading_time'],
      );

  StoriesData toStoriesData() {
    return StoriesData(
        id: this.id,
        title: this.title,
        hint: this.hint,
        image: this.image,
        url: this.url,
        ga_prefix: this.ga_prefix
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'hint': hint,
        'image': image,
        'url': url,
        'ga_prefix': ga_prefix,
        'reading_time': reading_time
      };

}
