class History{
  /// 历史记录表
  static const String tableName = 'history';

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

  // 阅读时间
  static const String reading_time = 'reading_time';

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
        $reading_time TEXT
      );
    ''';
}