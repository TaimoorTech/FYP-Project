part of 'registerCubit.dart';

class RegisterState{
  String username;
  String email;
  String password;
  String confirmPassword;

  RegisterState({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword
  });

}

class EmptyFieldState extends RegisterState{
  EmptyFieldState({required super.username, required super.email, required super.password, required super.confirmPassword});
}

class EmailErrorState extends RegisterState{
  EmailErrorState({required super.username, required super.email, required super.password, required super.confirmPassword});
}

class PasswordMatchErrorState extends RegisterState{
  PasswordMatchErrorState({required super.username, required super.email, required super.password, required super.confirmPassword});
}

class PasswordLengthErrorState extends RegisterState{
  PasswordLengthErrorState({required super.username, required super.email, required super.password, required super.confirmPassword});
}


class SubmittedState extends RegisterState{
  SubmittedState({required super.username, required super.email, required super.password, required super.confirmPassword});
}

class UnSubmittedState extends RegisterState{
  UnSubmittedState({required super.username, required super.email, required super.password, required super.confirmPassword});
}