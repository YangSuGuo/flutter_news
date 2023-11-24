import 'dart:convert';

StoriesData storiesDataFromJson(String str) =>
    StoriesData.fromJson(json.decode(str));
StoriesData storiesDataFromJsonInside(String str) =>
    StoriesData.fromJsonInside(json.decode(str));
String storiesDataToJson(StoriesData data) => json.encode(data.toJson());

/// 文章列表
class StoriesData {
  StoriesData({
    this.id,
    this.title,
    this.hint,
    this.image,
    this.url,
    this.ga_prefix,
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

  factory StoriesData.fromJson(Map<String, dynamic> json) => StoriesData(
        id: json['id'],
        title: json['title'],
        hint: json['hint'],
        image: json['images'][0],
        url: json['url'],
        ga_prefix: json['ga_prefix'],
      );

  factory StoriesData.fromJsonInside(Map<String, dynamic> json) => StoriesData(
    id: json['id'],
    title: json['title'],
    hint: json['hint'],
    image: json['image'],
    url: json['url'],
    ga_prefix: json['ga_prefix'],
  );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'hint': hint,
        'image': image,
        'url': url,
        'ga_prefix': ga_prefix
      };
}
