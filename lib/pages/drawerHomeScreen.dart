import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_project/dataSources/localDatabase/sqflite.dart';
import 'package:fyp_project/utils/constants.dart';

class homeDrawer extends StatelessWidget {
  String loggedEmail;

  homeDrawer({Key? key, required this.loggedEmail}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(
                color: Colors.white
              ),
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                margin: EdgeInsets.zero,
                accountName: const Text("Taimoor",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                accountEmail: Text(loggedEmail,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15))
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 2.5,
              height: 0,
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Options",
                  style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            ListTile(
              leading: Icon(Icons.logout_sharp),
              title:
              const Text("Log Out", style: TextStyle(fontSize: 15, color: Colors.black)),
              onTap: () async {
                await SQLHelper.deleteItem(loggedEmail);
                Navigator.pushNamed(context, Constants.loginScreenPath);
              },
            ),
          ],
        ),
      ),
    );
  }
}
