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
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Padding(padding:  const EdgeInsets.only(top: 20.0)),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    const SizedBox(width: 10.0,),
                    const Icon(CupertinoIcons.profile_circled, size: 50, color: Colors.black,),
                    const SizedBox(width: 10.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(loggedUsername,
                          style: const TextStyle(color: Colors.black,
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      Text(loggedEmail,
                          style: const TextStyle(color: Colors.black, fontSize: 15)),
                    ],
                    ),

                ],
              ),
            ),
          ),
          const SizedBox(height: 30.0,),
          const Divider(
            color: Colors.black,
            thickness: 1.5,
            height: 0,
          ),
          const SizedBox(height: 5.0,),
          // ListTile(
          //   title: const Text(Constants.homeDrawerOptionsText,
          //       style: TextStyle(fontSize: 20, color: Colors.white,
          //       fontWeight: FontWeight.bold)
          //   ),
          //   onTap: (){},
          // ),
          ListTile(
            leading: const Icon(Icons.manage_accounts_rounded, color: Colors.black, size: 15),
            title: const Text(Constants.profileButtonText,
                style: TextStyle(fontSize: 15, color: Colors.black)
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 15,),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) =>
                  ProfileScreen(loggedUsername: loggedUsername, loggedEmail: loggedEmail,)));
            },
          ),
          const SizedBox(height: 5.0,),
          Align(child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("Preferences",
                style: TextStyle(fontSize: 13)),
          ), alignment: Alignment.centerLeft,),
          SizedBox(
            height: 40,
            child: ListTile(
              leading: const Icon(Icons.report_sharp, color: Colors.black, size: 15),
              title: const Text(Constants.reportButtonText,
                  style: TextStyle(fontSize: 15, color: Colors.black)
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 15,),
              onTap: (){
                Navigator.pushNamed(context, Constants.reportComplaintScreenPath);
              },
            ),
          ),
          SizedBox(
            height: 40,
            child: ListTile(
              leading: const Icon(Icons.support_agent_sharp, color: Colors.black, size: 15),
              title: const Text(Constants.contactSupportButtonText,
                  style: TextStyle(fontSize: 15, color: Colors.black)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 15,),
              onTap: () async {},
            ),
          ),
          const SizedBox(height: 10,),
          SizedBox(
            height: 40,
            child: ListTile(
              leading: const Icon(Icons.logout_sharp, color: Colors.black, size: 15),
              title: const Text(Constants.logOutButtonText,
                  style: TextStyle(fontSize: 15, color: Colors.black)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 15,),
              onTap: () async {
                Util.submittedSnackBar(context, Constants.userLogOutText);
                await SQLHelper.deleteItem(loggedEmail);
                Navigator.pushNamed(context, Constants.loginScreenPath);
              },
            ),
          ),
        ],
      ),
    );
  }
}
