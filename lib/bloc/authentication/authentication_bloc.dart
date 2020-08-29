import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crud_bloc/data/model/auth_user.dart';
import 'package:crud_bloc/data/reposities/user_reposities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository repository;

  AuthenticationBloc(this.repository) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    yield AuthenticationLoading();
    if (event is AppLoaded) {
      try {
        await Future.delayed(Duration(milliseconds: 500));
        final authCurrentUser = await repository.getAuthCurrentUser();
        if (authCurrentUser != null) {
          yield AuthenticationAuthenticated(authUser: authCurrentUser);
        }else {
          yield AuthenticationNotAuthenticated();
        }

      }catch (e) {
        yield AuthenticationFailure(message: e.toString());
      }
    }
    if (event is UserLoggedIn) {
      try {
        yield AuthenticationAuthenticated(authUser: event.authUser);

      }catch(e) {
        yield AuthenticationFailure(message: e.toString());
      }
    }
    if (event is UserLoggedOut) {
      try {
        await repository.signOut();
        yield AuthenticationNotAuthenticated();

      }catch(e) {
        yield AuthenticationFailure(message: e.toString());
      }     
    }
  }
}
