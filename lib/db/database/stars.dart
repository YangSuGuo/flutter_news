class Stars{
  // 表名称
  static const String tableName = 'mood_info';

  // ID
  static const String starsID = 'starsID';

  /// 删除数据库
  final String dropTable = 'DROP TABLE IF EXISTS $tableName';

  /// 创建数据库
  final String createTable = '''
      CREATE TABLE $tableName (
        $starsID INTEGER PRIMARY KEY,
      );
    ''';
}