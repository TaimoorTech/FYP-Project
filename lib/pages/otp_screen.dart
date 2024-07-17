import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import '../bloc/otpBloc/otp_cubit.dart';
import '../bloc/otpBloc/otp_state.dart';
import '../utils/util.dart';
import '../utils/constants.dart';

class OtpScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String verificationCode;

  const OtpScreen({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.verificationCode,
  });

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();

  Future<void> _onBackPressed() async {
    Navigator.pushNamed(context, Constants.registerScreenPath);
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
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.all(20.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // Change to min to center vertically
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset(Constants.appIcon,
                          height: 60, width: 60, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      Constants.enterotpText,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Pinput(
                        length: 6,
                        controller: otpController,
                        defaultPinTheme: PinTheme(
                          width: 50,
                          height: 50,
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 50,
                          height: 50,
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        submittedPinTheme: PinTheme(
                          width: 50,
                          height: 50,
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      alignment: Alignment.center,
                      child: BlocListener<OtpCubit, OtpState>(
                        listener: (context, state) {
                          if (state is OtpVerified) {
                            Util.submittedSnackBar(
                                context, 'OTP Verified Successfully!');
                            // You can add additional navigation or actions here
                          } else if (state is OtpSuccess) {
                            Util.submittedSnackBar(context,
                                'Registration Completed Successfully!');
                            Navigator.pushNamed(
                                context, Constants.homeScreenPath);
                            // Navigate to home screen or perform any other action
                          } else if (state is OtpError) {
                            Util.errorSnackBar(
                                context, 'Invalid OTP. Please try again.');
                          } else if (state is OtpResent) {
                            Util.submittedSnackBar(context,
                                'A new OTP has been sent to your email.');
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
                              Constants.verifyOtpButtonText,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              final enteredOtp = otpController.text.trim();
                              context.read<OtpCubit>().verifyOtp(
                                    enteredOtp,
                                    widget.verificationCode,
                                    name: widget.name,
                                    email: widget.email,
                                    password: widget.password,
                                  );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          Constants.doNotReceiveOtpButtonText,
                          style: TextStyle(fontSize: 14),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<OtpCubit>().resendOtp(
                                context, widget.email, widget.verificationCode);
                          },
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: const Text(
                            Constants.resendButtonText,
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
          ),
        ),
      ),
    );
  }
}
