import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_project/dataSources/cloudDatabase/complaintDatabase.dart';
import 'package:fyp_project/modelClasses/complaintModel.dart';

import '../bloc/internetBloc/internetCubit.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import 'package:intl/intl.dart' as intl;
import '../utils/util.dart';
import 'InternetDisconnectionScreen.dart';

class ReportComplaintScreen extends StatefulWidget {
  const ReportComplaintScreen({super.key});

  @override
  State<ReportComplaintScreen> createState() => _ReportComplaintScreenState();
}

class _ReportComplaintScreenState extends State<ReportComplaintScreen> {

   final TextEditingController dueDateController = TextEditingController();
   final TextEditingController finishedTimeController = TextEditingController();
   final TextEditingController locationController = TextEditingController();
   TextEditingController robberyTypeController = TextEditingController();
   final TextEditingController districtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String robberyType="";
    List robberyItems = ["Theft", "Robbery"];
    String district="";
    List districtItems=["Karachi South", "Karachi West", "Karachi East",
      "Karachi Central", "Korangi", "Malir"];
    return SafeArea(
        child: BlocBuilder<InternetCubit, InternetState>(
          builder: (BuildContext context, InternetState state){
            if ((state is InternetConnected) &&
                (state.connectionType == ConnectionType.Wifi ||
                    state.connectionType == ConnectionType.Mobile)) {
                return Scaffold(
                  appBar: AppBar(
                    iconTheme: const IconThemeData(
                      color: Colors.green, //change your color here
                    ),
                    centerTitle: true,
                    title: const Text(Constants.reportButtonText,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                  body: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          Text("Complaint Registration", style: TextStyle(color: Colors.green,
                          fontWeight: FontWeight.bold, fontSize: 20)),
                          const SizedBox(height: 30),
                          TextField(
                            controller: dueDateController,
                            decoration: getDecoration("Enter Date",
                                Icon(Icons.calendar_month_sharp, color: Colors.green),
                            dueDateController),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100)
                              );
                              if(pickedDate != null) {
                                dueDateController.text = intl.DateFormat("dd-MM-yyyy").format(pickedDate);
                              }
                            },
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            maxLines: 1,
                            controller: finishedTimeController,
                            decoration: getDecoration("Enter Time",
                                Icon(CupertinoIcons.time_solid, color: Colors.green),
                            finishedTimeController),
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now(),
                                builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              );
                              if(pickedTime != null){
                                final localizations = MaterialLocalizations.of(context);
                                String formattedTime = localizations.formatTimeOfDay(pickedTime, alwaysUse24HourFormat: true);
                                finishedTimeController.text = formattedTime;
                              }
                            },
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            controller: locationController,
                            decoration: getDecoration("Enter Accident Location",
                                Icon(Icons.location_on_sharp, color: Colors.green),
                            locationController),
                            onChanged: (val) {
                              locationController.text = val;
                            },
                          ),
                          const SizedBox(height: 30),
                          DropdownButtonFormField(
                              isExpanded: true,
                              value: robberyTypeController.text.isNotEmpty ? robberyTypeController.text : null,
                              decoration: getDecoration("Enter Robbery Type",
                                  Icon(Icons.report_problem, color: Colors.green),
                              robberyTypeController),
                              items: robberyItems.map((valueItem) {
                                return DropdownMenuItem(
                                  value: valueItem,
                                  child: new Text(valueItem),
                                );
                              }).toList(),
                              onChanged: (val){
                                setState(() {
                                    robberyTypeController.text=val.toString();
                                });
                              }
                              ),
                          const SizedBox(height: 30),
                          DropdownButtonFormField(
                              isExpanded: true,
                              value: districtController.text.isNotEmpty ? districtController.text : null,
                              decoration: getDecoration("Enter District",
                                  Icon(Icons.location_city_sharp, color: Colors.green),
                              districtController),
                              items: districtItems.map((valueItem) {
                                return DropdownMenuItem(
                                  value: valueItem,
                                  child: new Text(valueItem),
                                );
                              }).toList(),
                              onChanged: (val){
                                setState(() {
                                  districtController.text=val.toString();
                                });
                              }
                          ),
                          const SizedBox(height: 50),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    minimumSize: MaterialStateProperty.all<Size>
                                      (Size(MediaQuery.of(context).size.width*0.4, 50)),
                                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.pressed)) {
                                          return Color(0xFFDDDDDD); // Change this to desired press color
                                        }
                                        return Colors.white; // Change this to desired press color
                                      },
                                    ),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side:
                                        BorderSide(color: Colors.green), // Border color and width
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(13)),
                                  ),
                                  onPressed: (){
                                    setState(() {
                                      dueDateController.text="";
                                      finishedTimeController.text="";
                                      locationController.text="";
                                      robberyTypeController.text="";
                                      districtController.text="";
                                    });
                                  },
                                  child: Text("Clear", style: TextStyle(color: Colors.green))),
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                    minimumSize: MaterialStateProperty.all<Size>
                                      (Size(MediaQuery.of(context).size.width*0.4, 50)),
                                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.pressed)) {
                                          return Colors.lightGreen; // Change this to desired press color
                                        }
                                        return Colors.green; // Change this to desired press color
                                      },
                                    ),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(color: Colors.green), // Border color and width
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(13)),
                                  ),
                                  onPressed: () async {
                                    if(dueDateController.text.isEmpty ||
                                        finishedTimeController.text.isEmpty ||
                                        locationController.text.isEmpty ||
                                        robberyTypeController.text.isEmpty ||
                                        districtController.text.isEmpty
                                    ){
                                      Util.errorSnackBar(context, "Please Fill All The Fields");
                                    }
                                    else{
                                      Complaint complaint = Complaint
                                        (date: dueDateController.text,
                                          time: finishedTimeController.text,
                                          location: locationController.text,
                                          robberyType: robberyTypeController.text,
                                          district: districtController.text);
                                      int onlineRes = await ComplaintDatabase.addData(complaint);
                                      if(onlineRes == 1){
                                        Util.submittedSnackBar(context, "Complaint Registration has been completed successfully");
                                      }
                                      else{
                                        Util.errorSnackBar(context, "Complaint Registration has been failed");
                                      }
                                    }

                                  },
                                  child: Text("Submit", style: TextStyle(color: Colors.white)))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                
                );
            }
            else{
              return const InternetDisconnectionScreen();
            }
          },
        )
    );
  }
  
  InputDecoration getDecoration(String text, Icon icon, TextEditingController textEditingController) {
    return InputDecoration(
      hintText: text,
      hintStyle: TextStyle(color: Colors.green),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green),
        borderRadius: BorderRadius.circular(5.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.green,
        ),
      ),
      prefixIcon: icon,
      filled: true,
      fillColor: Colors.green[50],
      labelText: textEditingController.text.isNotEmpty ? text : null,
      labelStyle: TextStyle(color: Colors.green),
    );
  }
  
}
