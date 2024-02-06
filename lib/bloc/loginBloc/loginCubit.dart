import 'package:bloc/bloc.dart';
import 'package:fyp_project/pages/loginScreen.dart';

part 'loginStates.dart';

class LoginCubit extends Cubit<LoginState>{

  LoginCubit() : super(LoginState(email: '', password: ''));


  void validateUserLogging(String email, String password){
    if(email.trim().isEmpty || password.trim().isEmpty){
      emit(EmptyFieldState(email: email, password: password));
    }
    else if(email.endsWith('@gmail.com')==false){
      emit(EmailErrorState(email: email, password: password));
    }
    else if(password.length<8){
      emit(PasswordLengthErrorState(email: email, password: password));
    }
    else{
      emit(loginSuccessfulState(email: email, password: password));
    }
  }


}