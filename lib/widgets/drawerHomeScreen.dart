import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/dataSources/localDatabase/sqflite.dart';
import 'package:fyp_project/pages/profileScreen.dart';
import 'package:fyp_project/utils/constants.dart';

import '../utils/util.dart';

class homeDrawer extends StatelessWidget {
  String loggedEmail;
  String loggedUsername;

  homeDrawer({Key? key, required this.loggedUsername, required this.loggedEmail}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.green,
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    const Icon(CupertinoIcons.profile_circled, size: 100, color: Colors.white,),
                    const SizedBox(height: 20.0,),
                    Text(loggedUsername,
                        style: const TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20.0,),
          const Divider(
            color: Colors.white,
            thickness: 2.5,
            height: 0,
          ),
          ListTile(
            title: const Text(Constants.homeDrawerOptionsText,
                style: TextStyle(fontSize: 20, color: Colors.white,
                fontWeight: FontWeight.bold)
            ),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.profile_circled, color: Colors.white),
            title: const Text(Constants.profileButtonText,
                style: TextStyle(fontSize: 15, color: Colors.white)
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) =>
                  ProfileScreen(loggedUsername: loggedUsername, loggedEmail: loggedEmail,)));
            },
          ),
          const SizedBox(height: 5.0,),
          ListTile(
            leading: const Icon(Icons.report_sharp, color: Colors.white),
            title: const Text(Constants.reportButtonText,
                style: TextStyle(fontSize: 15, color: Colors.white)
            ),
            onTap: (){
              Navigator.pushNamed(context, Constants.reportComplaintScreenPath);
            },
          ),
          const SizedBox(height: 5.0,),
          ListTile(
            leading: const Icon(Icons.logout_sharp, color: Colors.white),
            title: const Text(Constants.logOutButtonText, 
                style: TextStyle(fontSize: 15, color: Colors.white)),
            onTap: () async {
              Util.submittedSnackBar(context, Constants.userLogOutText);
              await SQLHelper.deleteItem(loggedEmail);
              Navigator.pushNamed(context, Constants.loginScreenPath);
            },
          ),
        ],
      ),
    );
  }
}
