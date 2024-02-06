import 'package:bloc/bloc.dart';

part 'registerStates.dart';

class RegisterCubit extends Cubit<RegisterState>{

  RegisterCubit() : super(RegisterState(username: '', email: '', password: '', confirmPassword: ''));


  void validateRegisterUser(String username, String email, String password, String confirmPassword){
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
      emit(SubmittedState(username: username, email: email, password: password, confirmPassword: confirmPassword));
    }
  }


}