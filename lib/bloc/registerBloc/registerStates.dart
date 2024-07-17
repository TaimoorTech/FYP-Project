part of 'registerCubit.dart';

/// Enum representing the different statuses of the registration form.
enum RegisterStatus {
  initial,
  emptyFieldError,
  emailError,
  passwordMatchError,
  passwordLengthError,
  submitted,
  unsubmitted,
}

/// Base state class for registration, containing user input data.
class RegisterState {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final RegisterStatus status;

  RegisterState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.status = RegisterStatus.initial,
  });

  RegisterState copyWith({
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    RegisterStatus? status,
  }) {
    return RegisterState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
    );
  }
}
