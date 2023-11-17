class Stars{
  // 收藏表
  static const String tableName = 'stars_info';

  // ID
  static const String starsID = 'starsID';

  // 标题
  static const String title = 'title';

  // 描述
  static const String description = 'description';

  // 图片
  static const String image = 'image';

  // 链接
  static const String link = 'link';

  // 发布时间
  // static const String publishTime = 'publishTime';

  // 收藏时间
  static const String collectTime = 'collectTime';

  /// 删除数据库
  final String dropTable = 'DROP TABLE IF EXISTS $tableName';

  /// 创建数据库
  final String createTable = '''
      CREATE TABLE $tableName (
        $starsID INTEGER PRIMARY KEY,
        $title TEXT,
        $description TEXT,
        $image TEXT,
        $link TEXT,
        $collectTime TEXT
      );
    ''';
}