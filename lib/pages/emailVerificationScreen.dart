import 'dart:math';

import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_project/bloc/internetBloc/internetCubit.dart';
import 'package:fyp_project/pages/registerScreen.dart';

import '../bloc/registerBloc/registerCubit.dart';
import '../emailVerification/emailVerificationService.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import '../utils/util.dart';
import 'InternetDisconnetionScreen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {

  String email = " ";
  String verificationCode = " ";
  String generatedVerificationCode = " ";
  static late EmailAuth emailAuth;


  static final _random = Random();
  static TextEditingController emailTextController = TextEditingController();
  static TextEditingController verificationCodeTextController = TextEditingController();

  static String _generateVerificationCode() {
    // You can customize the length and format of the verification code
    return _random.nextInt(999999).toString().padLeft(6, '0');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailTextController.text="";
    verificationCodeTextController.text="";
    email="";
    verificationCode="";
    generatedVerificationCode="";
  }

  Future<bool> _onBackPressed() async {
    Navigator.pushNamed(context, Constants.loginScreenPath);
    return Future.value(true);
  }



  static void sentOTP(BuildContext context) async {
    emailAuth = EmailAuth(
      sessionName: "Test Session",
    );
    bool result = await emailAuth.sendOtp(recipientMail: emailTextController.value.text, otpLength: 5);
    if (result) {
      Util.submittedSnackBar(context, 'Message sent: ');
    } else {
      Util.errorSnackBar(context, 'Message not sent. Error:');
    }
  }

  void verifyOTP(BuildContext context) {
    var res = emailAuth.validateOtp(
        recipientMail: emailTextController.text.toString(),
        userOtp: verificationCodeTextController.text.toString());
    if(res){
      Util.submittedSnackBar(context, 'OTP Verified');
    }
    else{
      Util.errorSnackBar(context, 'Invalid OTP');
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _onBackPressed();
      },
      child: SafeArea(child: BlocBuilder<InternetCubit, InternetState>(
        builder: (context, state) {
          if ((state is InternetConnected) &&
              (state.connectionType == ConnectionType.Wifi || state.connectionType == ConnectionType.Mobile))
          {
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
                        Text(Constants.verifyEmailAddressText,
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          maxLength: 35,
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
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          maxLines: 1,
                          controller: verificationCodeTextController,
                          decoration: const InputDecoration(
                              labelStyle:
                              TextStyle(color: Colors.black, fontSize: 14),
                              labelText: Constants.verificationCodeTextField,
                              suffixIcon: Icon(Icons.verified_user_sharp),
                              suffixIconColor: Colors.black),
                          onChanged: (val) => {verificationCode = val.trim()},
                        ),
                        const SizedBox(
                          height: 70,
                        ),
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
                                  backgroundColor: Colors.green,
                                ),
                                child: Text(Constants.getVerificationCodeButtonText,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                onPressed: () async {
                                      generatedVerificationCode = _generateVerificationCode();
                                      await EmailVerificationService.sendVerificationCode(context, email, generatedVerificationCode);
                                      // sentOTP(context);
                                }),
                          ),
                        ),
                        const SizedBox(
                          height: 70,
                        ),
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
                                  backgroundColor: Colors.green,
                                ),
                                child: Text(Constants.confirmVerificationCodeButtonText,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                onPressed: () {
                                  if(verificationCode==generatedVerificationCode){
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) => RegisterCubit(),
                                          child: RegisterScreen(confirmed_email: emailTextController.text),
                                        )
                                    ));//Register Screen
                                  }
                                  else{
                                    Util.errorSnackBar(context, 'Wrong Verification code');
                                  }
                                  // verifyOTP(context);

                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
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
