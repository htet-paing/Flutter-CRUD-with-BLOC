import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crud_bloc/bloc/authentication/authentication_bloc.dart';
import 'package:crud_bloc/data/reposities/user_reposities.dart';
import 'package:crud_bloc/widget/authentication_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository repository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc(this.repository, this.authenticationBloc) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {

    if (event is LoginWithEmailButtonPressed) {
      yield LoginLoading();

      try{
        final authUser = await repository.signInWithEmailAndPassword(event.email, event.password);
        if (authUser != null) {
          //push new authentication event
          authenticationBloc.add(UserLoggedIn(authUser: authUser));
          yield LoginSuccess();
          yield LoginInitial();
        }else {
          yield LoginFailure(error: 'Something very weird just happened');
        }

      } on AuthenticationException catch(e) {
        yield LoginFailure(error: e.message);
      }
      catch (e) {
        yield LoginFailure(error: e.message ?? 'An unknown error occured');
      }
    }
  }
}
