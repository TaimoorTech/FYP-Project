import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_project/bloc/internetBloc/internetCubit.dart';
import 'package:fyp_project/routes/routerApp.dart';
import 'package:fyp_project/utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final RouterApp _routerApp = RouterApp();
  final Connectivity connectivity = Connectivity();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InternetCubit>(
      create: (context) => InternetCubit(connectivity: connectivity),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appTitle,
        theme: ThemeData(
          useMaterial3: true,
        ),
        onGenerateRoute: _routerApp.onGenerateRoute,
      ),
    );
  }
}
