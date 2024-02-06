import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_project/bloc/internetBloc/internetCubit.dart';
import 'package:fyp_project/bloc/loginBloc/loginCubit.dart';

import '../utils/constants.dart';
import '../utils/enums.dart';
import '../utils/util.dart';
import 'InternetDisconnetionScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = " ";
  String password = " ";

  bool passwordVisible = true;

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  Future<bool> _onWillPop(BuildContext context) async {
    bool exit = await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(Constants.dialogTitle),
        content: new Text(Constants.dialogContent),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(Constants.dialogTextNo, style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: new Text(Constants.dialogTextYes, style: TextStyle(color: Colors.red),),
          ),
        ],
      ),
    );

    if (exit == true) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return Future.value(true);
    }
    else{
      return Future.value(false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _onWillPop(context);
      },
      child: SafeArea(child: BlocBuilder<InternetCubit, InternetState>(
        builder: (context, state) {
          if ((state is InternetConnected) &&
              (state.connectionType == ConnectionType.Wifi ||
                  state.connectionType == ConnectionType.Mobile)) {
            return Scaffold(
              body: Container(
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(Constants.appIcon,
                            height: 60, width: 60, fit: BoxFit.cover),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(Constants.loginText,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        // autofocus: true,
                        maxLines: 1,
                        controller: emailTextController,
                        decoration: const InputDecoration(
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 14),
                            labelText: Constants.emailTextField,
                            suffixIcon: Icon(Icons.email_sharp),
                            suffixIconColor: Colors.black),
                        onChanged: (val) => {email = val},
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        // autofocus: true,
                        maxLines: 1,
                        obscureText: passwordVisible,
                        controller: passwordTextController,
                        decoration: InputDecoration(
                          labelText: Constants.passwordTextField,
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 14),
                          suffixIcon: IconButton(
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(
                                () {
                                  passwordVisible = !passwordVisible;
                                },
                              );
                            },
                          ),
                        ),
                        onChanged: (val) => {password = val},
                      ),
                      SizedBox(height: 60),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity,
                          height: 34,
                          child: BlocListener<LoginCubit, LoginState>(
                            listener: (context, state) async {
                              if (state is EmptyFieldState) {
                                Util.errorSnackBar(context, Constants.emptyFieldErrorText);
                              } else if (state is EmailErrorState) {
                                Util.errorSnackBar(context, Constants.correctEmailErrorText);
                              } else if (state is PasswordLengthErrorState) {
                                Util.errorSnackBar(context, Constants.passwordLengthErrorText);
                              } else if (state is loginSuccessfulState) {
                                state.email = " ";
                                state.password = " ";
                                Util.submittedSnackBar(context, Constants.userSuccessfullyLoggingText);
                                await Future.delayed(Duration(seconds: 2));
                                Util.submittedSnackBar(context, Constants.userLoginInText);
                                await Future.delayed(Duration(seconds: 2));
                                Navigator.pushNamed(context, Constants.homeScreenPath); //home Screen
                              }
                            },
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  elevation: 10,
                                  backgroundColor: Colors.green,
                                ),
                                child: Text(Constants.loginButtonText,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                onPressed: () {
                                  context
                                      .read<LoginCubit>()
                                      .validateUserLogging(email, password);
                                }),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(Constants.doNotHaveAccountText,
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(
                              height: 5,
                            ),
                            Text(Constants.registerNowText,
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: double.infinity,
                          height: 34,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                elevation: 10,
                                backgroundColor: Colors.white,
                              ),
                              child: Text(Constants.registerButtonText,
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 20)),
                              onPressed: () {
                                Navigator.pushNamed(context,
                                    Constants.emailVerificationScreenPath); //register
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return InternetDisconnectionScreen();
          }
        },
      )),
    );
  }
}
