import 'package:bloc/bloc.dart';
import 'package:fyp_project/dataSources/cloudDatabase/signupDatabase.dart';
import 'package:fyp_project/dataSources/localDatabase/sqflite.dart';
import 'package:fyp_project/pages/loginScreen.dart';
import '../../modelClasses/userModel.dart';

part 'loginStates.dart';

class LoginCubit extends Cubit<LoginState>{

  LoginCubit() : super(LoginState(email: '', password: '', username: ''));




  void validateUserLogging(String email, String password) async {
    if(email.trim().isEmpty || password.trim().isEmpty){
      emit(EmptyFieldState(email: email, password: password, username: ''));
    }
    else if(email.endsWith('@gmail.com')==false){
      emit(EmailErrorState(email: email, password: password, username: ''));
    }
    else{
      List<User> userDetailsList = await SignupDatabase.fetchAllData();
      if(userDetailsList.isEmpty){
        emit(loginUnSuccessfulState(email: email, password: password, username: ''));
      }
      else{
        int res = 0;
        for(final row in userDetailsList){
          if(row.email.trim()==email.trim()
              && row.password.trim()==password.trim()){
            res=1;
          }
          if(res==1){
            User user = new User(username: row.username, email: email, password: password);
            int res = await SQLHelper.createItem(user);
            emit(loginSuccessfulState(username: row.username, email: email, password: password));
          }
        }
        if(res==0){
          emit(loginUnSuccessfulState(email: email, password: password, username: ''));
        }
      }

    }
  }


}