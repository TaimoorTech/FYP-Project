import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_project/bloc/internetBloc/internetCubit.dart';
import 'package:fyp_project/bloc/registerBloc/registerCubit.dart';
import 'package:fyp_project/pages/InternetDisconnectionScreen.dart';
import 'package:fyp_project/pages/otp_screen.dart';
import '../bloc/otpBloc/otp_cubit.dart';
import '../emailVerification/emailVerificationService.dart';
import 'dart:math';
import '../utils/constants.dart';
import '../utils/enums.dart';
import '../utils/util.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;

  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();

  Future<void> _onBackPressed() async {
    Navigator.pushNamed(context, Constants.loginScreenPath);
  }

  String generateOtp() {
    final random = Random();
    final otp = (random.nextInt(900000) + 100000).toString();
    return otp;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        }
        _onBackPressed();
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
            ),Container(
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
                        const SizedBox(height: 25),
                        Container(
                          alignment: Alignment.center,
                          child: Image.asset(Constants.appIcon,
                              height: 60, width: 60, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          Constants.createAccountText,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          maxLines: 1,
                          controller: nameTextController,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(fontSize: 14),
                            labelText: Constants.usernameTextField,
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          maxLines: 1,
                          controller: emailTextController,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(fontSize: 14),
                            labelText: Constants.emailTextField,
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Your password must be at least 8 characters long and combine letters with numerals and/or special characters.',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          maxLines: 1,
                          obscureText: passwordVisible,
                          controller: passwordTextController,
                          decoration: InputDecoration(
                            labelText: Constants.passwordTextField ,
                            labelStyle: const TextStyle(fontSize: 14),
                            border: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
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
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          maxLines: 1,
                          controller: confirmPasswordTextController,
                          obscureText: confirmPasswordVisible,
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(fontSize: 14),
                            labelText: Constants.confirmPasswordTextField,
                            border: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(confirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  confirmPasswordVisible =
                                  !confirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          alignment: Alignment.center,
                          child: BlocListener<RegisterCubit, RegisterState>(
                            listener: (context, state) async {
                              switch (state.status) {
                                case RegisterStatus.emptyFieldError:
                                  Util.errorSnackBar(
                                      context, Constants.emptyFieldErrorText);
                                  break;
                                case RegisterStatus.emailError:
                                  Util.errorSnackBar(
                                      context, Constants.correctEmailErrorText);
                                  break;
                                case RegisterStatus.passwordLengthError:
                                  Util.errorSnackBar(context,
                                      Constants.passwordLengthErrorText);
                                  break;
                                case RegisterStatus.passwordMatchError:
                                  Util.errorSnackBar(
                                      context, Constants.passwordNotMatchText);
                                  break;
                                case RegisterStatus.submitted:
                                  final otp = generateOtp();
                                  EmailVerificationService.sendVerificationCode(
                                      context, emailTextController.text.trim(), otp);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => OtpCubit(),
                                        child: OtpScreen(
                                          name: nameTextController.text.trim(),
                                          email: emailTextController.text.trim(),
                                          password: passwordTextController.text.trim(),
                                          verificationCode: otp,
                                        ),
                                      ),
                                    ),
                                  );
                                  break;
                                case RegisterStatus.unsubmitted:
                                  Util.errorSnackBar(
                                      context,
                                      Constants
                                          .userUnSuccessfullyRegistrationText);
                                  break;
                                default:
                                  break;
                              }
                            },
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                  ),
                                  backgroundColor: Colors.greenAccent[700],
                                ),
                                child: const Text(
                                  Constants.signupButtonText,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                onPressed: () {
                                  final name = nameTextController.text.trim();
                                  final email = emailTextController.text.trim();
                                  final password = passwordTextController.text.trim();
                                  final confirmPassword = confirmPasswordTextController.text.trim();

                                  if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                                    Util.errorSnackBar(context, Constants.emptyFieldErrorText);
                                    return;
                                  }

                                  context.read<RegisterCubit>().validateRegisterUser(
                                    name,
                                    email,
                                    password,
                                    confirmPassword,
                                  );
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
                              Constants.alreadyAccountText,
                              style: TextStyle(fontSize: 14),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, Constants.loginScreenPath);
                              },
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: const Text(
                                Constants.loginButtonText,
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
    ]
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
