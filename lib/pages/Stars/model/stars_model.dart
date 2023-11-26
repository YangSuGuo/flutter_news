import 'dart:convert';

import 'package:item_news/pages/Item/model/stories_model.dart';

StarsData starsDataFromJson(String str) => StarsData.fromJson(json.decode(str));

String starsDataToJson(StarsData data) => json.encode(data.toJson());

/// 收藏数据
class StarsData {
  late int? id;
  late String? title;
  late String? hint;
  late String? image;
  late String? url;
  late String? ga_prefix;

  // 收藏日期
  late String? collectTime;

  StarsData({
    this.id,
    this.title,
    this.hint,
    this.image,
    this.url,
    this.ga_prefix,
    this.collectTime,
  });

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
        ga_prefix: this.ga_prefix);
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
