import 'package:crud_bloc/bloc/user_form/user_form_bloc.dart';
import 'package:crud_bloc/screen/list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_list/user_list_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserListBloc>(
          create: (ctx) => UserListBloc()..add(GetUsers()),
        ),
        BlocProvider<UserFormBloc>(
          create: (ctx) => UserFormBloc(),
        )
      ], 
      child: MaterialApp(
        title: 'CRUD BLOC',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(       
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ListScreen(),
      )
    );
  }
}