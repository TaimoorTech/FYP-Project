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
  final TextEditingController _selectLocationController = TextEditingController();
  String tokenForSession = '37465';
  var timeZoneValue = -1;
  List<dynamic> listForPlaces = [];
  var uuid = Uuid();
  int listLength = 0;
  num destinationLongitude = 0;
  num destinationLatitude = 0;

  static const CameraPosition _cameraPosition = CameraPosition(
      target: LatLng(24.879255699968876, 67.17533365991154),
      zoom: 18
  );

  final Set<Circle> _circles = {
    Circle(
      circleId: const CircleId('PTCL OFFICE'),
      center: const LatLng(24.891771911143024, 67.17449681067855),
      radius: 100,
      fillColor: Colors.redAccent.withOpacity(0.3),
      strokeColor: Colors.transparent,
      strokeWidth: 0
    ),
     Circle(
        circleId: const CircleId('SHAMSI HOSPITAL'),
        center: const LatLng(24.88028741074736, 67.17110649861667),
        radius: 100,
        fillColor: Colors.lightGreenAccent.withOpacity(0.3),
        strokeColor: Colors.transparent,
        strokeWidth: 0
    ),
     Circle(
        circleId: const CircleId('JAMIA MILIA COLLEGE'),
        center: const LatLng(24.873201525391952, 67.17887417561923),
        radius: 100,
        fillColor: Colors.lightBlueAccent.withOpacity(0.3),
        strokeColor: Colors.transparent,
        strokeWidth: 0
    ),
  };

  final Set<Marker> _markers = {
    const Marker(
        markerId: MarkerId('PTCL OFFICE'),
        position: LatLng(24.891771911143024, 67.17449681067855),
        infoWindow: InfoWindow(title: 'PTCL OFFICE')
    ),
    const Marker(
        markerId: MarkerId('SHAMSI HOSPITAL'),
        position: LatLng(24.88028741074736, 67.17110649861667),
        infoWindow: InfoWindow(title: 'SHAMSI HOSPITAL')
    ),
    const Marker(
        markerId: MarkerId('JAMIA MILIA COLLEGE'),
        position: LatLng(24.873201525391952, 67.17887417561923),
        infoWindow: InfoWindow(title: 'JAMIA MILIA COLLEGE')
    )
  };


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

  void makeSuggestion(String input) async {
    String googlePlacesApiKey = 'AIzaSyCZsKhh0DgnmgB62UlRxTQMgCHw2LPivgg';
    String groundURL ='https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$groundURL?input=$input&key=$googlePlacesApiKey&sessiontoken=$tokenForSession';

    var responseResult = await http.get(Uri.parse(request));

    var resultData = responseResult.body.toString();
    print("Result Data");
    print(resultData);

    if(responseResult.statusCode==200){
      setState(() {
        listForPlaces = jsonDecode(responseResult.body.toString()) ['predictions'];
      });
    }
    else{
      Util.errorSnackBar(context, "No Place Found...");
    }
  }

  void onModify(){
    if(tokenForSession==null){
      setState(() {
        tokenForSession=uuid.v4();

      });
    }
    makeSuggestion(_selectLocationController.text.toString());
  }

  void showForm() {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => ModelBottomSheet()
    );
  }

  Widget ModelBottomSheet(){
    return Container(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom+120),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text("Search Destination Location",
            style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _selectLocationController,
            decoration: const InputDecoration(hintText: "Enter Destination"),
            onChanged: (val){
              setState(() {
                listLength=1;
              });
            },
            onSubmitted: (val){
              setState(() {
                listLength=0;
              });
            },
          ),
          Expanded(child: ListView.builder(
              itemCount: listForPlaces.length,
              itemBuilder: (context, index){
                return ListTile(
                    onTap: () async {
                      List<Location> locations = await locationFromAddress(listForPlaces[index] ['description']);
                      setState(() {
                        destinationLongitude = locations.last.longitude;
                        destinationLatitude = locations.last.latitude;
                        print(destinationLatitude);
                        print(destinationLongitude);
                      });
                    },
                    title: Text(listForPlaces[index]['description']),
                );
              }
          )
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField(
              value: -1,
              items: const [
                DropdownMenuItem(
                    child: Text("Select Time Zone"),
                    value: -1,
                ),
                DropdownMenuItem(
                    child: Text("12pm-5pm"),
                    value: 0,
                ),
                DropdownMenuItem(
                    child: Text("5am - 12pm"),
                    value: 1,
                ),
                DropdownMenuItem(
                    child: Text("5pm-8pm"),
                    value: 2,
                ),
                DropdownMenuItem(
                    child: Text("8pm - 5am"),
                    value: 3,
                ),
              ],
              onChanged: (val){
                setState(() {
                  timeZoneValue = val!;
                });
              }
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              child: const Text("Done", style: TextStyle(color: Colors.green)),
              onPressed: () {

              },
          )
        ],
      ),
    );
 }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<HomeCubit>().getDetails();
    _selectLocationController.addListener(() {
      onModify();
    });
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
              // floatingActionButton: Container(
              //   margin: EdgeInsets.only(top: 30),
              //   child: Align(
              //     alignment: Alignment.topRight,
              //     child: FloatingActionButton(
              //       backgroundColor: Colors.white,
              //       onPressed: () async {
              //         _selectLocationController.text='';
              //         showForm();
              //       },
              //       child: const Icon(
              //           Icons.search_sharp, color: Colors.green,
              //       ),
              //     ),
              //   ),
              // ),
              body: GoogleMap(
                circles: _circles,
                markers: _markers,
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
