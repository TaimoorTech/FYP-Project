part of 'loginCubit.dart';

class LoginState{
  String username;
  String email;
  String password;

  LoginState({
    required this.username,
    required this.email,
    required this.password,
  });

}

class EmptyFieldState extends LoginState{
  EmptyFieldState({required super.username, required super.email, required super.password});
}

class EmailErrorState extends LoginState{
  EmailErrorState({required super.username, required super.email, required super.password});
}


class loginSuccessfulState extends LoginState{
  loginSuccessfulState({required super.username, required super.email, required super.password});
}

class loginUnSuccessfulState extends LoginState{
  loginUnSuccessfulState({required super.username, required super.email, required super.password});
}