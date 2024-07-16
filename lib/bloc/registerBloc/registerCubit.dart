import 'package:bloc/bloc.dart';
import 'package:fyp_project/dataSources/cloudDatabase/signupDatabase.dart';
import 'package:fyp_project/dataSources/localDatabase/sqflite.dart';
import '../../modelClasses/userModel.dart';
import '../../utils/util.dart';

part 'registerStates.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState());

  void validateRegisterUser(String username, String email, String password, String confirmPassword) {
    if (username.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      emit(state.copyWith(
        username: username,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        status: RegisterStatus.emptyFieldError,
      ));
    } else if (!email.endsWith('@gmail.com')) {
      emit(state.copyWith(
        username: username,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        status: RegisterStatus.emailError,
      ));
    } else if (password.length < 8) {
      emit(state.copyWith(
        username: username,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        status: RegisterStatus.passwordLengthError,
      ));
    } else if (password.trim() != confirmPassword.trim()) {
      emit(state.copyWith(
        username: username,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        status: RegisterStatus.passwordMatchError,
      ));
    } else {
      emit(state.copyWith(
        username: username,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        status: RegisterStatus.submitted,
      ));
    }
  }
}
