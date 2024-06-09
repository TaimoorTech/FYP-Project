import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/internetBloc/internetCubit.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import 'InternetDisconnectionScreen.dart';

class ProfileScreen extends StatelessWidget {
  String loggedUsername;
  String loggedEmail;

  ProfileScreen(
      {Key? key, required this.loggedUsername, required this.loggedEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: BlocBuilder<InternetCubit, InternetState>(
      builder: (BuildContext context, InternetState state) {
        if ((state is InternetConnected) &&
            (state.connectionType == ConnectionType.Wifi ||
                state.connectionType == ConnectionType.Mobile)) {
          return Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(
                  color: Colors.green, //change your color here
                ),
                backgroundColor: Colors.white,
                centerTitle: true,
                title: const Text(
                  Constants.profileButtonText,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ),
              body: Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle,
                          size: 150,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    // Align(alignment: Alignment.center,
                    //     child: Text(loggedUsername, style: TextStyle(fontSize: 20),)),
                    // const SizedBox(height: 10,),
                    // Align(alignment: Alignment.center,
                    //     child: Text(loggedEmail, style: TextStyle(fontSize: 14, color: Colors.green),)),
                    // const SizedBox(height: 30,),
                    const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          'Personal Details',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 40,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: const TextStyle(color: Colors.green),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(color: Colors.green)),
                        suffixIcon: const Icon(
                          CupertinoIcons.profile_circled,
                          color: Colors.green,
                        ),
                        filled: true,
                        fillColor: Colors.green[50],
                      ),
                      child: Text(
                        loggedUsername,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        labelStyle: const TextStyle(color: Colors.green),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(color: Colors.green)),
                        suffixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.green,
                        ),
                        filled: true,
                        fillColor: Colors.green[50],
                      ),
                      child: Text(
                        loggedEmail,
                      ),
                    ),
                  ],
                ),
              ));
        } else {
          return const InternetDisconnectionScreen();
        }
      },
    ));
  }
}
