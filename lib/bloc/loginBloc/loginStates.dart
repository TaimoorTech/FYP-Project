part of 'loginCubit.dart';

enum LoginStatus {
  initial,
  emptyFieldError,
  emailError,
  loginSuccessful,
  loginUnsuccessful,
}

class LoginState {
  final String username;
  final String email;
  final String password;
  final LoginStatus status;

  LoginState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.status = LoginStatus.initial,
  });

  LoginState copyWith({
    String? username,
    String? email,
    String? password,
    LoginStatus? status,
  }) {
    return LoginState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}
