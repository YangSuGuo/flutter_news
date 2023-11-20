import '../../db/db.dart';

class StarsServices{
  /// 获取所有收藏
  static Future<List<Map<String, dynamic>>> getStarsAllData() async {
    final starsData = await DB.db.selectAllStars();
    final List<Map<String, dynamic>> dataList = [];
    for (final value in starsData) {
      dataList.add(value);
    }
    return dataList;
  }
}