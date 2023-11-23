class Stars {
  // 收藏表
  static const String tableName = 'stars_info';

  // ID
  static const String id = 'id';

  // 标题
  static const String title = 'title';

  // 描述
  static const String hint = 'hint';

  // 图片
  static const String image = 'image';

  // 链接
  static const String url = 'url';

  // 日报时间
  static const String ga_prefix = 'ga_prefix';

  // 收藏时间
  static const String collectTime = 'collectTime';

  /// 删除数据库
  final String dropTable = 'DROP TABLE IF EXISTS $tableName';

  /// 创建数据库
  final String createTable = '''
      CREATE TABLE $tableName (
        $id INTEGER PRIMARY KEY,
        $title TEXT,
        $hint TEXT,
        $image TEXT,
        $url TEXT,
        $ga_prefix TEXT,
        $collectTime TEXT
      );
    ''';
}
