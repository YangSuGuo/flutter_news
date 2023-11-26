import 'dart:convert';

CommentInfoData commentInfoDataFromJson(String str) =>
    CommentInfoData.fromJson(json.decode(str));

String commentInfoDataToJson(CommentInfoData data) =>
    json.encode(data.toJson());

class CommentInfoData {
  late int? longComments;
  late int? popularity;
  late int? shortComments;
  late int? comments;

  CommentInfoData({
    this.longComments,
    this.popularity,
    this.shortComments,
    this.comments,
  });

  factory CommentInfoData.fromJson(Map<String, dynamic> json) =>
      CommentInfoData(
        longComments: json['long_comments'],
        popularity: json['popularity'],
        shortComments: json['short_comments'],
        comments: json['comments'],
      );

  Map<String, dynamic> toJson() => {
        'long_comments': longComments,
        'popularity': popularity,
        'short_comments': shortComments,
        'comments': comments
      };
}
