import 'dart:convert';

CommentsData commentsDataFromJson(String str) =>
    CommentsData.fromJson(json.decode(str));

class CommentsData {
  late String? author;
  late String? content;
  late String? avatar;
  late int? time;
  late int? id;
  late int? likes;
  ReplyTo? replyTo;

  CommentsData({
    this.author,
    this.content,
    this.avatar,
    this.time,
    this.id,
    this.likes,
    this.replyTo,
  });

  CommentsData.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    content = json['content'];
    avatar = json['avatar'];
    time = json['time'];
    id = json['id'];
    likes = json['likes'];
    if (json['reply_to'] != null) {
      replyTo = ReplyTo.fromJson(json['reply_to']);
    }
  }
}

class ReplyTo {
  late String? content;
  late int? status;
  late int? id;
  late String? author;

  ReplyTo({
    this.content,
    this.status,
    this.id,
    this.author,
  });

  ReplyTo.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    status = json['status'];
    id = json['id'];
    author = json['author'];
  }
}
