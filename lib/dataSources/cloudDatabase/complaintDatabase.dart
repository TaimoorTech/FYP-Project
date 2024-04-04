import 'package:fyp_project/dataSources/cloudDatabase/postgresComplaintConnection.dart';
import 'package:fyp_project/dataSources/cloudDatabase/postgresConnection.dart';
import 'package:postgres/postgres.dart';
import '../../modelClasses/complaintModel.dart';

class ComplaintDatabase {

  static Future<String?> createTable() async{
    try {
      await complaintConnection.query('''
          CREATE TABLE IF NOT EXISTS Complaint(
          date text,
          time text,
          location text,
          robberyType text,
          district text
          )
        ''').then((value) => (){
        return "table created successfully";
      });
    } on PostgreSQLException catch (e) {
      print(e.message);
      return e.message;
    }
    return "";
  }

  static Future<int> addData(Complaint newComplaint) async {
    await ComplaintDatabase.createTable();
    String date = newComplaint.date;
    String time = newComplaint.time;
    String location = newComplaint.location;
    String robberyType = newComplaint.robberyType;
    String district = newComplaint.district;
    try {
      await complaintConnection.query('''
      INSERT INTO Complaint(date,time,location,robberyType,district)
      VALUES ('$date','$time','$location', '$robberyType', '$district')
    ''');
      return 1;
    }  on PostgreSQLException catch (e) {
      print(e.message);
      return 0;
    }
  }

}