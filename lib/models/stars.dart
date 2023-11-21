import 'dart:convert';

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

  // 修改日期
  late String? collectTime;

  factory StarsData.fromJson(Map<String, dynamic> json) => StarsData(
        id: json['id'],
        title: json['title'],
        hint: json['hint'],
        image: json['image'],
        url: json['url'],
        collectTime: json['collectTime'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'hint': hint,
        'image': image,
        'url': url,
        'collectTime': collectTime,
      };
}
