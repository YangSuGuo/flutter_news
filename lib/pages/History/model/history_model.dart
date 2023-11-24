import 'dart:convert';

import 'package:item_news/pages/Item/model/stories_model.dart';

HistoryData historyDataFromJson(String str) =>
    HistoryData.fromJson(json.decode(str));

String historyDataToJson(HistoryData data) => json.encode(data.toJson());

/// 历史记录数据
class HistoryData {
  late int? id;
  late String? title;
  late String? hint;
  late String? image;
  late String? url;
  late String? ga_prefix;
  // 阅读时间
  late String? reading_time;

  HistoryData({
    this.id,
    this.title,
    this.hint,
    this.image,
    this.url,
    this.ga_prefix,
    this.reading_time,
  });

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
        ga_prefix: this.ga_prefix);
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
