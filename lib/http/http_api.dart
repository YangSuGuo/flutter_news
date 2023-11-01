class HttpApi {
  // 知乎日报 列表
  static const String zhihu_list = 'stories/latest';

  // 知乎日报 正文 {id}
  static const String zhihu_body = 'story/';

  // 知乎日报 过去的 {yyyyMMdd}
  static const String zhihu_oldList = 'stories/before/';

  // 知乎日报 长评论 {id}
  static const String zhihu_comments = 'story/{id}/long-comments';

  // 知乎日报 短评论 {id}
  static const String zhihu_short_comments = 'story/{id}/short-comments';
}