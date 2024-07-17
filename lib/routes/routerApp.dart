import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_project/bloc/homeBloc/homeCubit.dart';
import 'package:fyp_project/bloc/loginBloc/loginCubit.dart';
import 'package:fyp_project/bloc/registerBloc/registerCubit.dart';
import 'package:fyp_project/pages/emailVerificationScreen.dart';
import 'package:fyp_project/pages/homeScreen.dart';
import 'package:fyp_project/pages/loginScreen.dart';
import 'package:fyp_project/pages/otp_screen.dart';
import 'package:fyp_project/pages/registerScreen.dart';
import 'package:fyp_project/pages/reportComplaintScreen.dart';
import 'package:fyp_project/pages/splashScreen.dart';
import 'package:fyp_project/utils/constants.dart';

class RouterApp {
  MaterialPageRoute? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Constants.defaultScreenPath:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Constants.emailVerificationScreenPath:
        return MaterialPageRoute(
            builder: (_) => const EmailVerificationScreen(name: '', email: '', password: '',));
      case Constants.registerScreenPath:
        return MaterialPageRoute(builder: (_) =>
            BlocProvider(
                create: (BuildContext context) => RegisterCubit(),
                child: RegisterScreen()));
      case Constants.loginScreenPath:
        return MaterialPageRoute(builder: (_) =>
            BlocProvider(
              create: (context) => LoginCubit(),
              child: LoginScreen(),
            ));
      case Constants.homeScreenPath:
        return MaterialPageRoute(builder: (_) =>
            BlocProvider(
              create: (context) => HomeCubit(),
              child: HomeScreen(),
            ));
      case Constants.reportComplaintScreenPath:
        return MaterialPageRoute(builder: (_) => ReportComplaintScreen());
      case Constants.otpScreenPath:
        return MaterialPageRoute(builder: (_) => OtpScreen(name: '', email: '', password: '', verificationCode: '',));
      default:
        return null;
    }
  }
}
