import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crud_bloc/model/user_model.dart';
import 'package:crud_bloc/reposities/user_reposities.dart';
import 'package:equatable/equatable.dart';

part 'user_list_event.dart';
part 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final _repository = UserRepository();
  UserListBloc() : super(UserListInitialState());

  @override
  Stream<UserListState> mapEventToState(
    UserListEvent event,
  ) async* {
    yield UserListLoadingState();
    if (event is GetUsers) {
      try {
        List<User> users = await _repository.getUsers(query: event.query);
        yield UserListLoadedState(users: users);

      }catch(e) {
        yield UserListErrorState(message: e.toString());
      }
    }else if (event is DeleteUser){
      try {
        await _repository.deleteUser(event.user.id);
        yield UserListLoadedState(users: await _repository.getUsers(query: event.query));

      }catch(e) {
        yield UserListErrorState(message: e.toString());
      }
    }
  }
}
