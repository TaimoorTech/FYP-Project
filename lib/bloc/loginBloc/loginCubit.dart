import 'package:bloc/bloc.dart';
import 'package:fyp_project/dataSources/cloudDatabase/signupDatabase.dart';
import 'package:fyp_project/dataSources/localDatabase/sqflite.dart';
import '../../modelClasses/userModel.dart';
import '../../utils/util.dart';

part 'loginStates.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  void validateUserLogging(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      emit(state.copyWith(
        email: email,
        password: password,
        status: LoginStatus.emptyFieldError,
      ));
    } else if (!email.endsWith('@gmail.com')) {
      emit(state.copyWith(
        email: email,
        password: password,
        status: LoginStatus.emailError,
      ));
    } else {
      List<User> userDetailsList = await SignupDatabase.fetchAllData();
      if (userDetailsList.isEmpty) {
        emit(state.copyWith(
          email: email,
          password: password,
          status: LoginStatus.loginUnsuccessful,
        ));
      } else {
        int res = 0;
        for (final row in userDetailsList) {
          String hashedPassword = Util.hashPassword(password);
          if (row.email.trim() == email.trim() &&
              row.password.trim() == hashedPassword.trim()) {
            res = 1;
            User user = User(username: row.username, email: email, password: hashedPassword);
            await SQLHelper.createItem(user);
            emit(state.copyWith(
              username: row.username,
              email: email,
              password: password,
              status: LoginStatus.loginSuccessful,
            ));
            break;
          }
        }
        if (res == 0) {
          emit(state.copyWith(
            email: email,
            password: password,
            status: LoginStatus.loginUnsuccessful,
          ));
        }
      }
    }
  }
}
