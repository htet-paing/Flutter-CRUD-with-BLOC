part of 'user_form_bloc.dart';

abstract class UserFormEvent extends Equatable {
  final User user;
   UserFormEvent({this.user});

  @override
  List<Object> get props => [];
}

class CreateUserEvent extends UserFormEvent {
  final User user;
  CreateUserEvent({this.user});
  @override
  List<Object> get props => [user];
}

class GetUserEvent extends UserFormEvent {
  final User user;
  GetUserEvent({this.user});
  @override
  List<Object> get props => [user];
}

class UpdateUserEvent extends UserFormEvent {
  final User user;
  UpdateUserEvent({@required this.user});
  @override
  List<Object> get props => [user];
}

class BackUserEvent extends UserFormEvent{}