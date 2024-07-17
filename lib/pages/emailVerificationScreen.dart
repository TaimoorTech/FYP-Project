import 'dart:math';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_project/bloc/internetBloc/internetCubit.dart';
import 'package:fyp_project/dataSources/cloudDatabase/signupDatabase.dart';
import 'package:fyp_project/pages/registerScreen.dart';
import '../bloc/registerBloc/registerCubit.dart';
import '../emailVerification/emailVerificationService.dart';
import '../modelClasses/userModel.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import '../utils/util.dart';
import 'InternetDisconnectionScreen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  const EmailVerificationScreen({
    super.key,
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  String verificationCode = " ";
  String generatedVerificationCode = " ";
  static late EmailAuth emailAuth;

  static final _random = Random();
  final TextEditingController verificationCodeTextController = TextEditingController();

  static String _generateVerificationCode() {
    return _random.nextInt(999999).toString().padLeft(6, '0');
  }

  @override
  void initState() {
    super.initState();
    verificationCodeTextController.text = "";
    verificationCode = "";
    generatedVerificationCode = "";
  }

  Future<bool> _onBackPressed() async {
    Navigator.pushNamed(context, Constants.registerScreenPath);
    return Future.value(true);
  }

  void sendOTP() async {
    emailAuth = EmailAuth(
      sessionName: "Test Session",
    );
    bool result = await emailAuth.sendOtp(recipientMail: widget.email, otpLength: 5);
    if (result) {
      Util.submittedSnackBar(context, 'Message sent: ');
    } else {
      Util.errorSnackBar(context, 'Message not sent. Error:');
    }
  }

  void verifyOTP(BuildContext context) {
    var res = emailAuth.validateOtp(
        recipientMail: widget.email,
        userOtp: verificationCodeTextController.text.toString());
    if (res) {
      Util.submittedSnackBar(context, 'OTP Verified');
      _registerUser();
    } else {
      Util.errorSnackBar(context, 'Invalid OTP');
    }
  }

  void _registerUser() async {
    User newUser = User(
      username: widget.name,
      email: widget.email,
      password: widget.password,
    );
    await SignupDatabase.addData(newUser);
    Navigator.pushNamed(context, Constants.homeScreenPath);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: ((didpop) {
          if (didpop){
            return;
          }
          _onBackPressed();
        }),
      child: SafeArea(
        child: BlocBuilder<InternetCubit, InternetState>(
          builder: (context, state) {
            if (state is InternetConnected &&
                (state.connectionType == ConnectionType.Wifi || state.connectionType == ConnectionType.Mobile)) {
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
                        Center(
                          child: Image.asset(
                            Constants.appIcon,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          Constants.verifyEmailAddressText,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildVerificationCodeTextField(),
                        const SizedBox(height: 70),
                        _buildGetVerificationCodeButton(context),
                        const SizedBox(height: 70),
                        _buildConfirmVerificationCodeButton(context),
                      ],
                    ),
                  ),
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

  Widget _buildVerificationCodeTextField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      maxLength: 6,
      maxLines: 1,
      controller: verificationCodeTextController,
      decoration: const InputDecoration(
        labelStyle: TextStyle(color: Colors.black, fontSize: 14),
        labelText: Constants.verificationCodeTextField,
        suffixIcon: Icon(Icons.verified_user_sharp),
        suffixIconColor: Colors.black,
      ),
      onChanged: (val) => {verificationCode = val.trim()},
    );
  }

  Widget _buildGetVerificationCodeButton(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        height: 34,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            elevation: 10,
            backgroundColor: Colors.green,
          ),
          child: const Text(
            Constants.getVerificationCodeButtonText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            generatedVerificationCode = _generateVerificationCode();
            await EmailVerificationService.sendVerificationCode(context, widget.email, generatedVerificationCode);
          },
        ),
      ),
    );
  }

  Widget _buildConfirmVerificationCodeButton(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        height: 34,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            elevation: 10,
            backgroundColor: Colors.green,
          ),
          child: const Text(
            Constants.confirmVerificationCodeButtonText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            verifyOTP(context);
          },
        ),
      ),
    );
  }
}
