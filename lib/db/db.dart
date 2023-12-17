import 'package:item_news/db/database/history.dart';
import 'package:item_news/pages/Item/model/stories_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../pages/History/model/history_model.dart';
import '../pages/Stars/model/stars_model.dart';
import 'database/stars.dart';

// todo 数据库更新逻辑

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
    final Database db = await openDatabase(path, version: _version, onCreate: _onCreate);
    return db;
  }

  Future close() async => _db.close();

  /// 创表
  void _onCreate(Database db, int newVersion) async {
    final batch = db.batch();
    // 收藏
    batch.execute(Stars().createTable);
    // batch.execute(Stars().dropTable);
    // 历史
    batch.execute(History().createTable);
    // batch.execute(History().dropTable);
    await batch.commit();
  }

  ///////////////////////////////// 收藏 /////////////////////////////////

  /// 查询所有收藏
  Future<List<StoriesData>> selectAllStars() async {
    final db = await database;
    final List<Map<String, dynamic>> list = await db.query(
      Stars.tableName,
      orderBy: '${Stars.collectTime} DESC',
    );
    List<StoriesData> starsList =
        list.map((data) => StoriesData.fromJsonInside(data)).toList();
    return starsList;
  }

  /// 按ID查找收藏
  Future<List> selectStars(int id) async {
    final db = await database;
    final List list = await db.query(
      Stars.tableName,
      where: '''
        ${Stars.id} like ? 
      ''',
      whereArgs: ['$id%'],
    );
    return list;
  }

  /// 新增收藏
  Future<bool> insertStars(StarsData starsData) async {
    final db = await database;
    final int result = await db.insert(Stars.tableName, starsData.toJson());
    return result > 0;
  }

  /// 删除收藏
  Future<bool> deleteStars(StarsData starsData) async {
    final db = await database;
    final int result = await db.delete(
      Stars.tableName,
      where: '${Stars.id} = ?',
      whereArgs: [starsData.id],
    );
    return result > 0;
  }

  ///////////////////////////////// 历史 /////////////////////////////////

  /// 查询所有历史记录
  Future<List<StoriesData>> selectAllHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> list = await db.query(
      History.tableName,
      orderBy: '${History.reading_time} DESC',
    );
    List<StoriesData> historyList =
        list.map((data) => StoriesData.fromJsonInside(data)).toList();
    return historyList;
  }

  /// 按ID查找历史记录
  Future<List> selectHistory(int id) async {
    final db = await database;
    final List list = await db.query(
      History.tableName,
      where: '''
        ${History.id} like ? 
      ''',
      whereArgs: ['$id%'],
    );
    return list;
  }

  /// 新增历史记录
  Future<bool> insertHistory(HistoryData historyData) async {
    final db = await database;
    final int result = await db.insert(History.tableName, historyData.toJson());
    return result > 0;
  }

  /// 更新历史记录
  Future<bool> updateHistory(HistoryData historyData) async {
    final db = await database;
    final int result = await db.update(
      History.tableName,
      historyData.toJson(),
      where: '${History.id} = ?',
      whereArgs: [historyData.id],
    );
    return result > 0;
  }
}
