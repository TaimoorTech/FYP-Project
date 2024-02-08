import 'package:flutter/material.dart';

import '../utils/constants.dart';

class InternetDisconnectionScreen extends StatelessWidget {
  const InternetDisconnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.3),
        padding: EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(Constants.wifiDisconnectedIcon,
                  height: 100, width: 100, fit: BoxFit.cover),
              SizedBox(height: 15),
              Text(Constants.noInternetDetectedText ,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text( Constants.checkInternetConnectionText,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );;
  }
}
