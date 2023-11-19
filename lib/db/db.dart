import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/stars.dart';
import 'database/stars.dart';

class DB {
  DB._();

  static final DB db = DB._();
  late Database _db;

  /// 数据库版本号
  final _version = 1;

  /// 数据库名称
  final _databaseName = 'ZhiHuDB.db';

  Future<Database> get database async {
    _db = await createDatabase();
    return _db;
  }

  /// 创建
  Future<Database> createDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, _databaseName);
    final Database db =
        await openDatabase(path, version: _version, onCreate: _onCreate);
    return db;
  }

  Future close() async => _db.close();

  /// 创建
  void _onCreate(Database db, int newVersion) async {
    final batch = db.batch();

    /// 表
    batch.execute(Stars().createTable);
    await batch.commit();
  }

  /// 查询所有收藏
  Future<List> selectAllStars() async {
    final db = await database;
    final List list = await db.query(
      Stars.tableName,
    );
    return list;
  }

  /// 查询收藏详情
  /// [starsID] 查询id (9766161)
  Future<List> selectStars(int id) async {
    final db = await database;
    final List list = await db.query(
      Stars.tableName,
      where: '''
        ${Stars.starsID} like ? 
      ''',
      whereArgs: ['$id%'],
    );
    return list;
  }

  /// 新增收藏
  Future<bool> insertStars(StarsData starsData) async {
    final db = await database;
    final int result = await db.insert(Stars.tableName, starsData.toJson());
    print(result);
    return result > 0;
  }
}
