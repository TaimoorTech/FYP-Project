import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_project/bloc/internetBloc/internetCubit.dart';
import 'package:fyp_project/dataSources/localDataSource/loginHive/userDatabase.dart';
import 'package:fyp_project/dataSources/localDataSource/loginHive/userHiveBox.dart';
import 'package:fyp_project/pages/InternetDisconnetionScreen.dart';

import '../utils/constants.dart';
import '../utils/enums.dart';
import 'drawerHomeScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String loggedEmail;

  Future<bool> _onBackPressed(BuildContext context) async {
    bool exit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(Constants.dialogTitle),
        content: const Text(Constants.dialogContent),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(Constants.dialogTextNo,
                style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text(
              Constants.dialogTextYes,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (exit == true) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  void getLoggedInfo(){
    var userDetails = UserDatabase.getUser();
    loggedEmail = userDetails[0].email;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _onBackPressed(context);
      },
      child: SafeArea(child: BlocBuilder<InternetCubit, InternetState>(
        builder: (context, state) {
          if ((state is InternetConnected) &&
              (state.connectionType == ConnectionType.Wifi ||
                  state.connectionType == ConnectionType.Mobile)) {
            return Scaffold(
              drawer: homeDrawer(loggedEmail: loggedEmail),
              body: Column(
                children: [
                  Center(child: Text("Home Screen", style: TextStyle(fontSize: 30))),
                ],
              ),
            );
          }
          else{
            return InternetDisconnectionScreen();
          }
        },
      )),
    );
  }
}
