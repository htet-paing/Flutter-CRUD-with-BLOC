part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginWithEmailButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginWithEmailButtonPressed({@required this.email, @required this.password,});

  @override
  List<Object> get props => [email, password];
}
