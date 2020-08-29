part of 'user_list_bloc.dart';

abstract class UserListState extends Equatable {
  final List<User> users;
  final String message;

  const UserListState({this.users, this.message});
  
  @override
  List<Object> get props => [];
}

class UserListInitialState extends UserListState {}
class UserListLoadingState extends UserListState {}

class UserListLoadedState extends UserListState {
  final List<User> users;
  UserListLoadedState({this.users});
  @override
  List<Object> get props => [users];
}

class UserListErrorState extends UserListState {
  final String message;
  UserListErrorState({this.message});
  @override
  List<Object> get props => [message];
}

