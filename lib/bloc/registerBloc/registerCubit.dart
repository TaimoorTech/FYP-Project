import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:fyp_project/dataSources/cloudDatabase/signupDatabase.dart';
import 'package:fyp_project/dataSources/localDatabase/sqflite.dart';
import 'package:crypto/crypto.dart';
import '../../modelClasses/userModel.dart';
import '../../utils/util.dart';

part 'registerStates.dart';

class RegisterCubit extends Cubit<RegisterState>{

  RegisterCubit() : super(RegisterState(username: '', email: '', password: '', confirmPassword: ''));



  Future<void> validateRegisterUser(String username, String email, String password, String confirmPassword) async {
    if(username.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty){
      emit(EmptyFieldState(username: username, email: email, password: password, confirmPassword: confirmPassword));
    }
    else if(email.endsWith('@gmail.com')==false){
      emit(EmailErrorState(username: username, email: email, password: password, confirmPassword: confirmPassword));
    }
    else if(password.length<8){
      emit(PasswordLengthErrorState(username: username, email: email, password: password, confirmPassword: confirmPassword));
    }
    else if(password.trim()!=confirmPassword.trim()){
      emit(PasswordMatchErrorState(username: username, email: email, password: password, confirmPassword: confirmPassword));
    }
    else{
      String hashedPassword = Util.hashPassword(password);

      User user = User(username: username, email: email, password: hashedPassword);
      await SQLHelper.deleteItem(email);
      int onlineRes = await SignupDatabase.addData(user);
      int res = await SQLHelper.createItem(user);
      if( (res==1) && (onlineRes==1) ){
        emit(SubmittedState(username: username, email: email, password: password, confirmPassword: confirmPassword));
      }
      else{
        emit(UnSubmittedState(username: username, email: email, password: password, confirmPassword: confirmPassword));
      }
    }
  }


}