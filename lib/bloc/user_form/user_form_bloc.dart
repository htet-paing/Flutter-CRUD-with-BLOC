import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:crud_bloc/model/user_model.dart';
import 'package:crud_bloc/reposities/user_reposities.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
part 'user_form_event.dart';
part 'user_form_state.dart';

class UserFormBloc extends Bloc<UserFormEvent, UserFormState> {
  final _repository = UserRepository();
  UserFormBloc() : super(UserFormInitialState());

  @override
  Stream<UserFormState> mapEventToState(
    UserFormEvent event,
  ) async* {
    yield UserFormLoadingState();
    if (event is GetUserEvent) {
      try {
        yield UserFormLoadedState(user: event.user?.id == null ? User()
        : await _repository.getUser(event.user?.id));
      }catch(e) {
        yield UserFormErrorState(message: e.toString());
      }
    }else if (event is BackUserEvent) {
    yield UserFormInitialState();
    }else if (event is CreateUserEvent) {
      try{
        await _repository.createUser(event.user);
        yield UserFormSuccessState(successMessage: event.user.name + 'created');
      }catch(e) {
        yield UserFormErrorState(message: e.toString());
      }
    }else if (event is UpdateUserEvent) {
      try {
        await _repository.updateUser(event.user);
        yield UserFormSuccessState(successMessage: event.user.name + 'updated');
      }catch(e) {
        yield UserFormErrorState(message: e.toString());
      }
    }
  }
}
