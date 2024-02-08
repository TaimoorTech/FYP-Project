import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/utils/constants.dart';

import '../dataSources/localDataSource/loginHive/userDatabase.dart';

class homeDrawer extends StatelessWidget {
  String loggedEmail;

  homeDrawer({Key? key, required this.loggedEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              child: DrawerHeader(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Icon(CupertinoIcons.profile_circled),
                    SizedBox(height: 10),
                    Text(loggedEmail, style: TextStyle(fontSize: 20, color: Colors.black)),
                  ],
                ),
              ),
            ),
            const Divider(
              thickness: 2.5,
              height: 0,
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Options",
                  textScaleFactor: 1.2,
                  style: TextStyle( fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: Icon(Icons.logout_sharp),
              title:
              const Text("Log Out", style: TextStyle(fontSize: 20, color: Colors.black)),
              onTap: () {
                UserDatabase.clearUser();
                Navigator.pushNamed(context, Constants.loginScreenPath);
              },
            ),
          ],
        ),
      ),
    );
  }
}
