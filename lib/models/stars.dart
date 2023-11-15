import 'dart:convert';

StarsData moodDataFromJson(String str) => StarsData.fromJson(json.decode(str));
String StarsDataToJson(StarsData data) => json.encode(data.toJson());

/// 收藏数据
class StarsData {
  StarsData({
    this.starsID,
    this.title,
    this.description,
    this.image,
    this.link,
    this.publishTime,
  });

  // ID
  late int? starsID;

  // 标题
  late String? title;

  // 描述
  late String? description;

  // 图片
  late String? image;

  // 链接
  late String? link;

  // 修改日期
  late String? publishTime;

  factory StarsData.fromJson(Map<String, dynamic> json) => StarsData(
        starsID: json['starsID'],
        title: json['title'],
        description: json['description'],
        image: json['image'],
        link: json['link'],
        publishTime: json['publishTime'],
      );

  Map<String, dynamic> toJson() => {
        'starsID': starsID,
        'title': title,
        'description': description,
        'image': image,
        'link': link,
        'publishTime': publishTime,
      };
}
