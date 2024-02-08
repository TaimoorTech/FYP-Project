import 'package:flutter/material.dart';
import 'package:fyp_project/dataSources/localDataSource/loginHive/userDatabase.dart';
import 'package:fyp_project/utils/constants.dart';

import '../dataSources/localDataSource/loginHive/userHiveBox.dart';
import '../modelClasses/userModel.dart';

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
    int res = hasUserLoggedIn();
    if(res==1){
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pushNamed(Constants.homeScreenPath);
      });
    }else{
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pushNamed(Constants.loginScreenPath);
      });
    }
  }


  int hasUserLoggedIn() {
    List<User> userDetailsList = UserDatabase.getUser();
    if(userDetailsList.isEmpty){
      return 0;
    }
    else{
      return 1;
    }
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
