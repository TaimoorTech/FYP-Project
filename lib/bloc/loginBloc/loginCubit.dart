import 'package:bloc/bloc.dart';
import 'package:fyp_project/pages/loginScreen.dart';
import 'package:hive/hive.dart';

import '../../dataSources/localDataSource/loginHive/userDatabase.dart';
import '../../dataSources/localDataSource/loginHive/userHiveBox.dart';
import '../../modelClasses/userModel.dart';

part 'loginStates.dart';

class LoginCubit extends Cubit<LoginState>{

  LoginCubit() : super(LoginState(email: '', password: ''));


  void validateUserLogging(String email, String password) async {
    if(email.trim().isEmpty || password.trim().isEmpty){
      emit(EmptyFieldState(email: email, password: password));
    }
    else if(email.endsWith('@gmail.com')==false){
      emit(EmailErrorState(email: email, password: password));
    }
    else{
      List<User> userDetailsList = UserDatabase.getUser();
      if(userDetailsList.isEmpty){
        emit(loginUnSuccessfulState(email: email, password: password));
      }
      else{
        int res = 0;
        if(userDetailsList[0].email.trim()==email.trim()
            && userDetailsList[0].password.trim()==password.trim()){
          res=1;
        }
        if(res==1){
          emit(loginSuccessfulState(email: email, password: password));
        }
        else{
          emit(loginUnSuccessfulState(email: email, password: password));
        }
      }

    }
  }


}