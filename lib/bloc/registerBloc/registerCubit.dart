import 'package:bloc/bloc.dart';
import 'package:fyp_project/dataSources/localDataSource/loginHive/userDatabase.dart';

import '../../modelClasses/userModel.dart';

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
      User user = User(email: email, password: password);
      await UserDatabase.clearUser();
      int res = await UserDatabase.addUser(user);
      if(res==1){
        emit(SubmittedState(username: username, email: email, password: password, confirmPassword: confirmPassword));
      }
      else{
        emit(UnSubmittedState(username: username, email: email, password: password, confirmPassword: confirmPassword));
      }
    }
  }


}