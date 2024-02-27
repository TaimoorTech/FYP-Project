import 'package:flutter/material.dart';
import 'package:fyp_project/dataSources/localDatabase/sqflite.dart';
import 'package:fyp_project/utils/constants.dart';
import 'package:postgres/postgres.dart';

import '../dataSources/cloudDatabase/postgresConnection.dart';
import '../modelClasses/userModel.dart';
import '../utils/util.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 5), () async {
      connection = PostgreSQLConnection(
          Constants.dbHostForEmulator, Constants.port, Constants.postgresDB,
          username: Constants.dbUsername, password: Constants.dbPassword,
          useSSL: true
      );
      requestForDBConnectionStart(context);

      List<User> userDetailsList = await SQLHelper.getAllItems();
      if(userDetailsList.isEmpty){
          Navigator.of(context).pushNamed(Constants.loginScreenPath);
      }else{
          Util.submittedSnackBar(context, Constants.userLoginInText);
          Navigator.of(context).pushNamed(Constants.homeScreenPath);

      }
    });
  }

  static Future<void> requestForDBConnectionStart(BuildContext context) async {
    await connection.open().then((value) =>
        Util.submittedSnackBar(context, "Connection Establish"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.33),
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(Constants.appIcon, height: 100, width: 100,
                    fit: BoxFit.cover),
                const SizedBox(height: 40),
                const Text(Constants.splashScreenTitle,
                    style: TextStyle(
                        color: Colors.green, fontSize: 36,
                        fontWeight: FontWeight.bold,
                    )
                ),
              ],
            ),
          ),
        )
    );
  }
}
