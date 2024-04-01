import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/homeBloc/homeCubit.dart';
import '../bloc/internetBloc/internetCubit.dart';
import '../dataSources/localDatabase/sqflite.dart';
import '../modelClasses/userModel.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import 'InternetDisconnectionScreen.dart';


class ProfileScreen extends StatelessWidget {


  String loggedUsername;
  String loggedEmail;

  ProfileScreen({Key? key, required this.loggedUsername, required this.loggedEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlocBuilder<InternetCubit, InternetState>(
          builder: (BuildContext context, InternetState state) {
            if ((state is InternetConnected) &&
                (state.connectionType == ConnectionType.Wifi ||
                    state.connectionType == ConnectionType.Mobile)) {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(Constants.profileButtonText,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                      color: Colors.black),
                  ),
                ),
                body: Container(
                      padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(CupertinoIcons.profile_circled, size: 100,
                                color: Colors.black,),
                            ],
                          ),
                          const SizedBox(height: 50.0),
                          TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            readOnly: true,
                            maxLines: 1,
                            initialValue: loggedUsername,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                                prefixIcon: Icon(Icons.person),
                                prefixIconColor: Colors.black
                            ),
                          ),
                          const SizedBox(height: 50.0,),
                          TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            readOnly: true,
                            maxLines: 1,
                            initialValue: loggedEmail,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                                prefixIcon: Icon(Icons.email_sharp),
                                prefixIconColor: Colors.black,
                            ),
                          ),

                        ],
                      ),
                    )
              );
            }
            else {
              return const InternetDisconnectionScreen();
            }
          },

        )
    );
  }
}
