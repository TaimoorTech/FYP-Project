part of 'loginCubit.dart';

class LoginState{
  String email;
  String password;

  LoginState({
    required this.email,
    required this.password,
  });

}

class EmptyFieldState extends LoginState{
  EmptyFieldState({required super.email, required super.password});
}

class EmailErrorState extends LoginState{
  EmailErrorState({required super.email, required super.password});
}

class PasswordLengthErrorState extends LoginState{
  PasswordLengthErrorState({required super.email, required super.password});
}


class loginSuccessfulState extends LoginState{
  loginSuccessfulState({required super.email, required super.password});
}

class loginUnSuccessfulState extends LoginState{
  loginUnSuccessfulState({required super.email, required super.password});
}