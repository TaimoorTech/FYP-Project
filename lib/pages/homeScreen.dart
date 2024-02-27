import 'dart:async';
import 'dart:convert';
import 'package:fyp_project/utils/util.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_project/bloc/homeBloc/homeCubit.dart';
import 'package:fyp_project/bloc/internetBloc/internetCubit.dart';
import 'package:fyp_project/pages/InternetDisconnectionScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import '../widgets/drawerHomeScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _googleMapController = Completer();

  static const CameraPosition _cameraPosition = CameraPosition(
      target: LatLng(24.879255699968876, 67.17533365991154),
      zoom: 18
  );



  Future<bool> _onBackPressed(BuildContext context) async {
    bool exit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(Constants.dialogTitle),
        content: const Text(Constants.dialogContent),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(Constants.dialogTextNo,
                style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text(
              Constants.dialogTextYes,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (exit == true) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<HomeCubit>().getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _onBackPressed(context);
      },
      child: SafeArea(child: BlocBuilder<InternetCubit, InternetState>(
        builder: (context, state) {
          if ((state is InternetConnected) &&
              (state.connectionType == ConnectionType.Wifi ||
                  state.connectionType == ConnectionType.Mobile)) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
              ),
              drawer: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return homeDrawer(
                      loggedUsername: state.username, loggedEmail: state.email);
                },
              ),
              body: GoogleMap(
                initialCameraPosition: _cameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _googleMapController.complete(controller);
                },
              ),
            );
          } else {
            return const InternetDisconnectionScreen();
          }
        },
      )),
    );
  }


}
