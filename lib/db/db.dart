import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database/stars.dart';

class DB{
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
    final Database db = await openDatabase(
      path,
      version: _version,
      onCreate: _onCreate
    );
    return db;
  }
  Future close() async => _db.close();

  /// 创建
  void _onCreate(Database db, int newVersion) async {
    final batch = db.batch();
    /// 表
    batch.execute(Stars().dropTable);

    await batch.commit();
  }

  /// 查询所有详情
  Future<List> selectAllStars() async {
    final db = await database;
    final List list = await db.query(
      Stars.tableName,
    );
    return list;
  }
}