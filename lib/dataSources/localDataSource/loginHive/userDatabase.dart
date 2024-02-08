import 'package:fyp_project/dataSources/localDataSource/loginHive/userHiveBox.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../../modelClasses/userModel.dart';

part 'userDatabase.g.dart';

@HiveType(typeId: 1)
class UserDatabase{

  UserDatabase({
    required this.email,
    required this.password,
  });

  @HiveField(0)
  String email;

  @HiveField(1)
  String password;

  static int addUser(User newUser){
    Map<String, dynamic> values = newUser.toMap();
    String _email = values['email'];
    String _password = values['password'];
    try{
      userBox.put('$_email', UserDatabase(email: _email, password: _password));
      return 1;
    }
    catch(e){
      return 0;
    }

  }

  static List<User> getUser() {
    final result = userBox.toMap().map(
          (k, e) => MapEntry(
          k.toString(), UserDatabase.conversion(e)
      ),
    );
    List<Map<String, dynamic>> userDetails = [];
    result.values.forEach((v) => userDetails.add(v));
    return userDetails.map(User.fromMap).toList();
  }

  static Map<String, dynamic> conversion(UserDatabase db_val) {
    String _email = db_val.email;
    String _password = db_val.password;

    Map<String, dynamic> map = {'email': _email, 'password': _password};

    return map;
  }

  static Future<void> clearUser() async {
    userBox.clear();
  }

}


