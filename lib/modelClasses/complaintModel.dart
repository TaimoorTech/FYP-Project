class Complaint{
  String date;
  String time;
  String location;
  String robberyType;
  String district;

  Complaint({
    required this.date,
    required this.time,
    required this.location,
    required this.robberyType,
    required this.district
  });


  Map<String, dynamic> toMap(){
    return{
      'date' : date,
      'time' : time,
      'location' : location,
      'robberyType' : robberyType,
      'district' : district
    };
  }

  static Complaint fromMap(Map<String, dynamic> map){
    return Complaint(
      date: map['date'],
      time: map['time'],
      location: map['location'],
      robberyType: map['robberyType'],
      district: map['district'],
    );
  }

}
