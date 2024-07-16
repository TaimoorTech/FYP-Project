import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_project/bloc/internetBloc/internetCubit.dart';
import 'package:fyp_project/bloc/loginBloc/loginCubit.dart';

import '../utils/constants.dart';
import '../utils/enums.dart';
import '../utils/util.dart';
import 'InternetDisconnectionScreen.dart';

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

  Future<bool> _showBackDialog(BuildContext context) async {
    bool exit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(Constants.dialogTitle),
        content: const Text(Constants.dialogContent),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(Constants.dialogTextNo, style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text(Constants.dialogTextYes, style: TextStyle(color: Colors.red),),
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
  void initState() {
    super.initState();
    emailTextController.text = "";
    passwordTextController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop){
          return;
        }
        _showBackDialog(context);
      }),
      child: SafeArea(
        child: BlocBuilder<InternetCubit, InternetState>(
          builder: (context, state) {
            if ((state is InternetConnected) &&
                (state.connectionType == ConnectionType.Wifi ||
                    state.connectionType == ConnectionType.Mobile)) {
              return Scaffold(
                body: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Constants.backgroundImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      alignment: Alignment.topCenter,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 25),
                            Container(
                              alignment: Alignment.center,
                              child: Image.asset(Constants.appIcon,
                                  height: 60, width: 60, fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 25),
                            const Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 38,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Hey! Good to see you again',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 80),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              controller: emailTextController,
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(fontSize: 14),
                                labelText: Constants.emailTextField,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                              onChanged: (val) => {email = val.trim()},
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              maxLines: 1,
                              obscureText: passwordVisible,
                              controller: passwordTextController,
                              decoration: InputDecoration(
                                labelText: Constants.passwordTextField,
                                labelStyle: const TextStyle(fontSize: 14),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                ),
                              ),
                              onChanged: (val) => {password = val.trim()},
                            ),
                            const SizedBox(height: 10),
                            Container(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Add your forgot password logic here
                                },
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                                ),
                                child: const Text(
                                  Constants.forgotButtonText,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: BlocListener<LoginCubit, LoginState>(
                                listener: (context, state) async {
                                  switch (state.status) {
                                    case LoginStatus.emptyFieldError:
                                      Util.errorSnackBar(context, Constants.emptyFieldErrorText);
                                      break;
                                    case LoginStatus.emailError:
                                      Util.errorSnackBar(context, Constants.correctEmailErrorText);
                                      break;
                                    case LoginStatus.loginSuccessful:
                                      Util.submittedSnackBar(context, Constants.userSuccessfullyLoggingText);
                                      await Future.delayed(const Duration(seconds: 2));
                                      Util.submittedSnackBar(context, Constants.userLoginInText);
                                      await Future.delayed(const Duration(seconds: 2));
                                      Navigator.pushNamed(context, Constants.homeScreenPath); // Home Screen
                                      break;
                                    case LoginStatus.loginUnsuccessful:
                                      Util.errorSnackBar(context, Constants.userUnSuccessfullyLoggingText);
                                      break;
                                    default:
                                      Util.errorSnackBar(context, Constants.unknownErrorText);
                                      break;
                                  }
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5))),
                                      backgroundColor: Colors.greenAccent[700],
                                    ),
                                    child: const Text(Constants.loginButtonText,
                                        style: TextStyle(color: Colors.white, fontSize: 16)),
                                    onPressed: () {
                                      context
                                          .read<LoginCubit>()
                                          .validateUserLogging(email, password);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  Constants.doNotHaveAccountText,
                                  style: TextStyle(fontSize: 14),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, Constants.registerScreenPath);
                                  },
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                                  ),
                                  child: const Text(
                                    Constants.signupButtonText,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const InternetDisconnectionScreen();
            }
          },
        ),
      ),
    );
  }
}
