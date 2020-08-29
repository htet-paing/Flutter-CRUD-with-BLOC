part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}
// Fired Just after the app is launched
class AppLoaded extends AuthenticationEvent{}

//Fired when a user has successfully logged in
class UserLoggedIn extends AuthenticationEvent{
  final AuthUser authUser;
  UserLoggedIn({@required this.authUser});

  @override
  List<Object> get props => [authUser];
}
// Fired when the user has logged out
class UserLoggedOut extends AuthenticationEvent{}


