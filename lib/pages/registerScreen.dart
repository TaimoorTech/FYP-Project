import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_project/bloc/internetBloc/internetCubit.dart';
import 'package:fyp_project/bloc/registerBloc/registerCubit.dart';
import 'package:fyp_project/pages/InternetDisconnectionScreen.dart';

import '../modelClasses/userModel.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import '../utils/util.dart';



class RegisterScreen extends StatefulWidget {
  String confirmed_email;

  RegisterScreen({super.key, required this.confirmed_email});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState(confirmed_email);
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;
  String username = " ";
  String email = " ";
  String password = " ";
  String confirmPassword = " ";
  // final bool enabled;

  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();

  String confirmed_email;

  _RegisterScreenState(this.confirmed_email);

  Future<bool> _onBackPressed() async {
    Navigator.pushNamed(context, Constants.loginScreenPath);
    return Future.value(true);
  }



  @override
  Widget build(BuildContext context) {
    // final VoidCallback? onPressed = enabled ? () {} : null;
    return WillPopScope(
      onWillPop: () async {
        return await _onBackPressed();
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
                    mainAxisSize: MainAxisSize.max,
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
                      Text(Constants.createAccountText,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        maxLength: 35,
                        maxLines: 1,
                        controller: nameTextController,
                        decoration: const InputDecoration(
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 14),
                            labelText: Constants.usernameTextField,
                            suffixIcon: Icon(Icons.person),
                            suffixIconColor: Colors.black),
                        onChanged: (val) => {username = val},
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        readOnly: true,
                        maxLines: 1,
                        initialValue: confirmed_email,
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
                        keyboardType: TextInputType.visiblePassword,
                        maxLength: 35,
                        maxLines: 1,
                        obscureText: passwordVisible,
                        controller: passwordTextController,
                        decoration: InputDecoration(
                            labelText: "Enter Password",
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
                            helperText: Constants.passwordHelperText,
                            helperStyle:
                                TextStyle(color: Colors.green, fontSize: 12),
                            suffixIconColor: Colors.black),
                        onChanged: (val) => {password = val},
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        maxLength: 35,
                        maxLines: 1,
                        controller: confirmPasswordTextController,
                        obscureText: confirmPasswordVisible,
                        decoration: InputDecoration(
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 14),
                            labelText: Constants.confirmPasswordTextField,
                            suffixIcon: IconButton(
                              icon: Icon(confirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(
                                  () {
                                    confirmPasswordVisible =
                                        !confirmPasswordVisible;
                                  },
                                );
                              },
                            ),
                            suffixIconColor: Colors.black),
                        onChanged: (val) => {confirmPassword = val},
                      ),
                      SizedBox(height: 30),
                      Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: double.infinity,
                          height: 34,
                          child: BlocListener<RegisterCubit, RegisterState>(
                            listener: (context, state) async {
                              if (state is EmptyFieldState) {
                                Util.errorSnackBar(context, Constants.emptyFieldErrorText);
                              } else if (state is EmailErrorState) {
                                Util.errorSnackBar(context, Constants.correctEmailErrorText);
                              } else if (state is PasswordLengthErrorState) {
                                Util.errorSnackBar(context, Constants.passwordLengthErrorText);
                              } else if (state is PasswordMatchErrorState) {
                                Util.errorSnackBar(context, Constants.passwordNotMatchText);
                              } else if (state is SubmittedState) {
                                Util.submittedSnackBar(context, Constants.userSuccessfullyRegistrationText);
                                await Future.delayed(Duration(seconds: 2));
                                Util.submittedSnackBar(context, Constants.userSigningInText);
                                await Future.delayed(Duration(seconds: 2));
                                Navigator.pushNamed(context, Constants.homeScreenPath); //home Screen
                              }else if (state is UnSubmittedState){
                                Util.errorSnackBar(context, Constants.userUnSuccessfullyRegistrationText);
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
                                child: Text(Constants.registerButtonText,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                onPressed: () {
                                  context.read<RegisterCubit>().validateRegisterUser(username, confirmed_email,
                                          password, confirmPassword);
                                }),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        alignment: Alignment.center,
                        child: Text( Constants.alreadyAccountText,
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(height: 25),
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
                              child: Text(Constants.loginButtonText,
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 20)),
                              onPressed: () {
                                Navigator.pushNamed(context, Constants.loginScreenPath); //login Screen
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
