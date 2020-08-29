part of 'user_form_bloc.dart';

abstract class UserFormState extends Equatable {
  final User user;
  final String message;

   UserFormState({this.user, this.message});
  
  @override
  List<Object> get props => [];
}

class UserFormInitialState extends UserFormState {}

class UserFormLoadingState extends UserFormState {}

class UserFormLoadedState extends UserFormState {
  final User user;
  UserFormLoadedState({this.user});
  @override
  List<Object> get props => [user];
}

class UserFormSuccessState extends UserFormState {
  final String successMessage;
  UserFormSuccessState({this.successMessage});
  @override
  List<Object> get props => [successMessage];
}

class UserFormErrorState extends UserFormState {
  final String message;
  UserFormErrorState({this.message});
  @override
  List<Object> get props => [message];
}

