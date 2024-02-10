import 'package:fyp_project/modelClasses/userModel.dart';
import 'package:sqflite/sqflite.dart' as sql;


class SQLHelper {
  static Future<void> createTables(sql.Database database) async{
    await database.execute(
        """CREATE TABLE user(
      email Text,
      password Text
      )
      """
    );
  }

  static Future<sql.Database> db() async{
    return sql.openDatabase(
        "userDB.db",
        version: 1,
        onCreate: (sql.Database database, int version) async {
          await createTables(database);
        }
    );
  }

  static Future<int> createItem(final User newUser) async{
    final db = await SQLHelper.db();
    try{
      int id = await db.insert(
          "user",
          newUser.toMap(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace
      );
      return 1;
    } catch(e){
      return 0;
    }

  }

  static Future<List<User>> getAllItems() async {
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> result = await db.query("user");
    return result.map(User.fromMap).toList();
  }

  static Future<void> deleteItem(String email) async{
    final db = await SQLHelper.db();
    try{
      await db.delete("user", where: "email = ?", whereArgs: [email]);
    }
    catch (err){err.toString();}
  }

}
