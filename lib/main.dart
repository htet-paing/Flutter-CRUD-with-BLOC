import 'package:crud_bloc/bloc/authentication/authentication_bloc.dart';
import 'package:crud_bloc/bloc/user_form/user_form_bloc.dart';
import 'package:crud_bloc/data/reposities/user_reposities.dart';
import 'package:crud_bloc/screen/list_screen.dart';
import 'package:crud_bloc/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_list/user_list_bloc.dart';

void main() {
  runApp(
    
    //Injects the Authentication service
    RepositoryProvider<UserRepository>(
      create: (context){
        return UserRepositoryImpl();
      },
      //Inject the authentication BLoC
      child: MultiBlocProvider(
        providers: [
          BlocProvider<UserListBloc>(
          create: (ctx){
            final repository = RepositoryProvider.of<UserRepository>(ctx);
            return UserListBloc(repository)..add(GetUsers());
          },
        ),
        BlocProvider<UserFormBloc>(
          create: (ctx) {
            final repository = RepositoryProvider.of<UserRepository>(ctx);
            return UserFormBloc(repository);
          },
        ),
        BlocProvider<AuthenticationBloc>(
          create: (ctx) {
            final repository = RepositoryProvider.of<UserRepository>(ctx);
            return AuthenticationBloc(repository)..add(AppLoaded());
          },
        ),

        ], 
        child: MyApp()
      ),
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD BLOC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(       
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            //show home page
            return ListScreen(authUser: state.authUser);
          }
          //otherwise show login page
          return LoginScreen();
        }
      ),
    );
  }
}