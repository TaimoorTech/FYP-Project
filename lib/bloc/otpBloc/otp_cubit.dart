import 'package:bloc/bloc.dart';
import 'package:fyp_project/emailVerification/emailVerificationService.dart';
import 'otp_state.dart';
import 'package:fyp_project/dataSources/cloudDatabase/signupDatabase.dart';
import 'package:fyp_project/dataSources/localDatabase/sqflite.dart';
import 'package:fyp_project/modelClasses/userModel.dart';
import 'package:fyp_project/utils/util.dart';
import 'package:flutter/material.dart'; // Add this import

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  Future<void> verifyOtp(String enteredOtp, String actualOtp, {required String name, required String email, required String password}) async {
    if (enteredOtp == actualOtp) {
      emit(OtpVerified());

      String hashedPassword = Util.hashPassword(password);
      User user = User(username: name, email: email, password: hashedPassword);

      await SQLHelper.deleteItem(email);
      int onlineRes = await SignupDatabase.addData(user);
      int res = await SQLHelper.createItem(user);

      if (res == 1 && onlineRes == 1) {
        emit(OtpSuccess());
      } else {
        emit(OtpError());
      }
    } else {
      emit(OtpError());
    }
  }

  Future<void> resendOtp(BuildContext context, String email, String otp) async {
    // Simulate sending OTP email
    try {
      await EmailVerificationService.sendVerificationCode(context, email, otp);
      emit(OtpResent());
    } catch (e) {
      emit(OtpError());
    }
  }
}
