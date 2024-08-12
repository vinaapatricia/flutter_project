import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterButtonPressed extends RegisterEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String phone;
  final String name;

  RegisterButtonPressed({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phone,
    required this.name,
  });

  @override
  List<Object> get props => [email, password, confirmPassword, phone, name];
}
