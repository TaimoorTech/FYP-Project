import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {
  @override
  List<Object> get props => [];
}

class OtpInitial extends OtpState {}

class OtpVerified extends OtpState {}

class OtpSuccess extends OtpState {}

class OtpError extends OtpState {}

class OtpResent extends OtpState {}
