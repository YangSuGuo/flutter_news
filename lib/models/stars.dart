import 'dart:convert';

import 'package:item_news/models/stories.dart';

StarsData starsDataFromJson(String str) => StarsData.fromJson(json.decode(str));

String starsDataToJson(StarsData data) => json.encode(data.toJson());

/// 收藏数据
class StarsData {
  StarsData({
    this.id,
    this.title,
    this.hint,
    this.image,
    this.url,
    this.ga_prefix,
    this.collectTime,
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

  // 收藏日期
  late String? collectTime;

  factory StarsData.fromJson(Map<String, dynamic> json) => StarsData(
        id: json['id'],
        title: json['title'],
        hint: json['hint'],
        image: json['image'],
        url: json['url'],
        ga_prefix: json['ga_prefix'],
        collectTime: json['collectTime'],
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
        'collectTime': collectTime,
      };
}
