part of 'user_list_bloc.dart';

abstract class UserListEvent extends Equatable {
  final User user;
  final String query;

  const UserListEvent({this.user, this.query});

  @override
  List<Object> get props => [];
}
class GetUsers extends UserListEvent {
  final String query;
  GetUsers({this.query});
   @override
  List<Object> get props => [query];
}

class DeleteUser extends UserListEvent {
  final User user;
  final String query;
  DeleteUser({this.user, this.query});
  @override
  List<Object> get props => [user,query];
}


