import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_project/bloc/homeBloc/homeCubit.dart';
import 'package:fyp_project/bloc/internetBloc/internetCubit.dart';
import 'package:fyp_project/pages/InternetDisconnetionScreen.dart';
import 'package:fyp_project/utils/util.dart';

import '../modelClasses/userModel.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import '../widgets/drawerHomeScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<bool> _onBackPressed(BuildContext context) async {
    bool exit = await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<HomeCubit>().getDetails();
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
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Container(
                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.15),
                  child: Text(Constants.homeScreenText, style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  )),
                ),
              ),
              drawer: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return homeDrawer(loggedUsername: state.username,loggedEmail: state.email);
                },
              ),
            );
          }
          else {
            return InternetDisconnectionScreen();
          }
        },
      )),
    );
  }
}
