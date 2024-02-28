import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_project/bloc/homeBloc/homeCubit.dart';
import 'package:fyp_project/bloc/internetBloc/internetCubit.dart';
import 'package:fyp_project/pages/InternetDisconnectionScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../modelClasses/crimeModel.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import '../widgets/drawerHomeScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PredictionService _predictionService = PredictionService();
  List<LatLng> _coordinates = [];
  List<double> _crimeScores = [];

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getDetails();
    _fetchPredictions();
  }

  void _fetchPredictions() async {
    try {
      final predictions = await _predictionService.fetchPredictions();
      setState(() {
        _coordinates = predictions.map<LatLng>((prediction) {
          return LatLng(prediction[1], prediction[2]);
        }).toList();
        _crimeScores = predictions.map<double>((prediction) {
          return prediction[0].toDouble();
        }).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Some error occurred '),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Set<Circle> _createCircles() {
    Set<Circle> circles = {};
    for (int i = 0; i < _coordinates.length; i++) {
      circles.add(Circle(
        circleId: CircleId('circle$i'),
        center: _coordinates[i],
        radius: 100, // Adjust the radius as needed
        fillColor: _getCircleColor(_crimeScores[i]),
        strokeWidth: 0,
      ));
    }
    return circles;
  }

  Color _getCircleColor(double crimeScore) {
    if (crimeScore <= 1) {
      return Colors.green.withOpacity(0.5);
    } else if (crimeScore <= 4) {
      return Colors.yellow.withOpacity(0.5);
    } else {
      return Colors.red.withOpacity(0.5);
    }
  }

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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _onBackPressed(context);
      },
      child: SafeArea(
        child: BlocBuilder<InternetCubit, InternetState>(
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
                body: _coordinates.isEmpty || _crimeScores.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                  onMapCreated: (GoogleMapController controller) {},
                  initialCameraPosition: CameraPosition(
                    target:_coordinates.first,
                    zoom: 14.0,
                  ),
                  circles: _createCircles(),
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
