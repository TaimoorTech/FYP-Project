

import 'package:fyp_project/dataSources/cloudDatabase/postgresConnection.dart';
import 'package:postgres/postgres.dart';

import '../../modelClasses/userModel.dart';

class SignupDatabase {

  static Future<String?> createTable() async{
    try {
      await connection.query('''
          CREATE TABLE IF NOT EXISTS Users(
          username text,
          email text,
          password text,
          )
        ''').then((value) => (){
        return "table created successfully";
      });
    } on PostgreSQLException catch (e) {
      print(e.message);
      return e.message;
    }
    return "";
  }

  static Future<int> addData(User newUser) async {
    await createTable();
    String username = newUser.username;
    String email = newUser.email;
    String password = newUser.password;
    try {
      await connection.query('''
      INSERT INTO Users(username,email,password)
      VALUES ('$username','$email','$password')
    ''');
      return 1;
    }  on PostgreSQLException catch (e) {
      print(e.message);
      return 0;
    }
  }

  static Future<List<User>> fetchAllData() async {
    List<User> userLists = [];
    try {
      dynamic results = await connection.query("SELECT * FROM Users");
      if (results.isEmpty) {
        print("No Record Found");
        return userLists;
      } else {
        for (final row in results) {
          User user = User(username: row[0], email: row[1], password: row[2]);
          userLists.add(user);
        }
        return userLists;
      }
    } on PostgreSQLException catch (e) {
      print(e.message);
      return userLists;
    }
  }
}