import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DbHelper {
  static Future<Database> dataBaseForUsername() async {
    //......................................Getting access to DB
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
        // searches for db ,if not found,it creats db
        path.join(dbPath, 'username.db'), onCreate: (db, version) {
      return db
          .execute('CREATE TABLE username(id TEXT PRIMARY KEY,username TEXT)');
    }, version: 1);

    //......................................Getting access to DB
  }

  static Future<Database> dataBaseForTimeTable() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'TimeTable'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE TimeTable(id TEXT PRIMARY KEY,timeTable TEXT)');
    }, version: 1);
  }

  static Future<Database> dataBaseForOwnerId() async {
    //......................................Getting access to DB
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
        // searches for db ,if not found,it creats db
        path.join(dbPath, 'ownerId.db'), onCreate: (db, version) {
      return db
          .execute('CREATE TABLE ownerId(id TEXT PRIMARY KEY,ownerId INTEGER)');
    }, version: 1);

    //......................................Getting access to DB
  }

  static Future<Database> dataBaseForAccessToken() async {
    //......................................Getting access to DB
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
        // searches for db ,if not found,it creats db
        path.join(dbPath, 'DtuOtgAccessToken.db'), onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE AccessToken(id TEXT PRIMARY KEY,accessToken TEXT,dateTime TEXT)');
    }, version: 1);

    //......................................Getting access to DB
  }

  static Future<Database> dataBaseForEmailAndUsername() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'EmailAndUsername.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE EmailAndUsername(id TEXT PRIMARY KEY,email TEXT,username TEXT)');
    }, version: 1);
  }

  static Future<Database> dataBaseForProfile() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'Profile.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE Profile(id TEXT PRIMARY KEY,name TEXT,rollNumber TEXT,branch TEXT,year TEXT,batch TEXT)');
    }, version: 1);
  }

  static Future<void> insertAccessToken(
    String table,
    Map<String, Object> newAccessToken,
  ) async {
    final dbForAccessToken = await DbHelper.dataBaseForAccessToken();
    dbForAccessToken.insert(table, newAccessToken,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> insertUsername(
    String table,
    Map<String, Object> username,
  ) async {
    final dbForUsername = await DbHelper.dataBaseForUsername();
    dbForUsername.insert(table, username,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> insertOwnerId(
    String table,
    Map<String, Object> ownerId,
  ) async {
    print('inserting owner id///////////////////////////////');
    final dbForownerid = await DbHelper.dataBaseForOwnerId();
    dbForownerid.insert(table, ownerId,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> insertTimeTable(
    String table,
    Map<String, Object> timeTable,
  ) async {
    final dbForTimeTable = await DbHelper.dataBaseForTimeTable();
    dbForTimeTable.insert(table, timeTable,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> insertProfile(
    String table,
    Map<String, Object> profile,
  ) async {
    final dbForProfile = await DbHelper.dataBaseForProfile();
    dbForProfile.insert(table, profile,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> insertEmailAndUsername(
    String table,
    Map<String, Object> emailAndUsername,
  ) async {
    final dbForEmailAndUsername = await DbHelper.dataBaseForEmailAndUsername();
    dbForEmailAndUsername.insert(table, emailAndUsername,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  ///
  ///Delete
  ///
  static Future<void> deleteTimeTableDatabase() async {
    Database db = await DbHelper.dataBaseForTimeTable();
    String path = db.path;
    await sql.deleteDatabase(path);
  }

  ///
  static Future<int> deleteAccessTokenData(String id) async {
    final db = await DbHelper.dataBaseForAccessToken();
    var result =
        await db.delete('AccessToken', where: 'id = ?', whereArgs: ['$id']);

    return result;
  }

  ///
  ///
  ///
  static Future<List<Map<String, dynamic>>> getAccessTokenData() async {
    final db = await DbHelper.dataBaseForAccessToken();
    return db.query('AccessToken');
  }

  static Future<List<Map<String, dynamic>>> getTimeTableData() async {
    final db = await DbHelper.dataBaseForTimeTable();
    return db.query('TimeTable');
  }

  static Future<List<Map<String, dynamic>>> getUsernameData() async {
    final db = await DbHelper.dataBaseForUsername();
    return db.query('username');
  }

  static Future<List<Map<String, dynamic>>> getOwnerIdData() async {
    final db = await DbHelper.dataBaseForOwnerId();
    return db.query('ownerId');
  }

  static Future<List<Map<String, dynamic>>> getProfileData() async {
    final db = await DbHelper.dataBaseForProfile();
    return db.query('Profile');
  }

  static Future<List<Map<String, dynamic>>> getEmailAndUsername() async {
    final db = await DbHelper.dataBaseForEmailAndUsername();
    return db.query('EmailAndUsername');
  }
}
