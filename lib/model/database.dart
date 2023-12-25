import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'entity.dart';

class DatabaseOperate {
  static Database? _database;

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  DatabaseOperate._internal();

  static Future<void> init() async {
    _database ??= await openDatabase(
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) {
        // db.execute("CREATE TABLE messages("
        //     "createdAt INTEGER PRIMARY KEY,"
        //     "content TEXT,"
        //     "questionId TEXT,"
        //     "toUserId TEXT,"
        //     "type INTEGER,"
        //     "fromUserId TEXT)");
      },
      version: 1,
    );
  }

  static insert<T extends Entity>(String table, T data) async {
    int insertSuccess = await _database!.insert(
      table,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (insertSuccess == 0) {
      print('插入数据失败');
    }
  }

  //增(批量)：messages表的数据
  static Future<void> insertBatch<T extends Entity>(List<T> data,
      {Function(T)? withInsertOther}) async {
    Batch batch = _database!.batch();
    for (T datum in data) {
      batch.insert('messages', datum.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      if (withInsertOther != null) {
        withInsertOther(datum);
      }
    }
    batch.commit();
  }

  static Future<void> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    int? offset,
    int? limit,
    String? orderBy,
  }) async {
    int deleteSuccess = await _database!.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
    if (deleteSuccess == 0) {
      print('删除失败');
    }
  }

  //清空表
  static deleteAll() {
    // _database!.execute("DELETE FROM messages");
  }

  static Future<List<Map<String, Object?>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    int? offset,
    int? limit,
    String? orderBy,
  }) async {
    final List<Map<String, dynamic>> maps = await _database!.query(
      table,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      where: where,
      whereArgs: whereArgs,
    );
    return maps;
  }
}
