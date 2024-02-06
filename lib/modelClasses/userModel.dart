class User{
  String email;
  String password;

  User({
        required this.email,
        required this.password,
  });


  Map<String, dynamic> toMap(){
    return{
      'email' : email,
      'password' : password
    };
  }

  static User fromMap(Map<String, dynamic> map){
    return User(
      email: map['email'],
      password: map['password'],
    );
  }

}
