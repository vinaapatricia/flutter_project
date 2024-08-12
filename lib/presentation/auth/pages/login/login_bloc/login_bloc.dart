import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_project/presentation/auth/services/auth_method.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthMethod authMethod = AuthMethod();

  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginRequested) {
      yield LoginLoading();
      try {
        final res = await authMethod.loginUser(
          email: event.email,
          password: event.password,
        );
        if (res == "success") {
          yield LoginSuccess();
        } else {
          yield LoginFailure(message: res);
        }
      } catch (e) {
        yield LoginFailure(message: 'Login failed. Please try again.');
      }
    }
  }
}
