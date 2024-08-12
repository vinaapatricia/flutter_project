import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/presentation/auth/services/auth_method.dart';

import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthMethod authMethod;

  RegisterBloc(this.authMethod) : super(RegisterInitial()) {
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoading());

      final String res = await authMethod.registerUser(
        email: event.email,
        password: event.password,
        phone: event.phone,
        name: event.name,
        confirmPassword: event.confirmPassword,
      );

      if (res == "success") {
        emit(RegisterSuccess());
      } else {
        emit(RegisterFailure(error: res));
      }
    });
  }
}
