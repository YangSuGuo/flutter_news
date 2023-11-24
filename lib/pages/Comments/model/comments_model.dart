import 'dart:convert';

CommentData commentDataFromJson(String str) =>
    CommentData.fromJson(json.decode(str));

String commentDataToJson(CommentData data) => json.encode(data.toJson());

class CommentData {
  late int? longComments;
  late int? popularity;
  late int? shortComments;
  late int? comments;

  CommentData({
    this.longComments,
    this.popularity,
    this.shortComments,
    this.comments,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) => CommentData(
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
