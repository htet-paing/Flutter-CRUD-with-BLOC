import 'package:flutter/cupertino.dart';

class AuthUser {
  final String name;
  final String email;

  AuthUser({@required this.name, @required this.email});
  
  @override
  String toString() => 'AuthUser {name: $name, email: $email}';
}