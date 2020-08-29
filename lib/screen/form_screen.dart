import 'package:crud_bloc/bloc/user_form/user_form_bloc.dart';
import 'package:crud_bloc/bloc/user_list/user_list_bloc.dart';
import 'package:crud_bloc/data/model/user_model.dart';
import 'package:crud_bloc/widget/error_widget.dart';
import 'package:crud_bloc/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();


  UserFormBloc userFormBloc;
  UserListBloc userListBloc;
  
  @override
  Widget build(BuildContext context) {
    userFormBloc = BlocProvider.of<UserFormBloc>(context);
    userListBloc = BlocProvider.of<UserListBloc>(context);

    return WillPopScope(
      onWillPop: () async {
        userFormBloc.add(BackUserEvent());
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: BlocBuilder<UserFormBloc, UserFormState>(
            builder: (context, state) =>
            Text(state.user?.id == null ? 'Add' : 'Edit')
            
          )
        ),
        
        body: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: BlocListener<UserFormBloc, UserFormState>(
                listener: (context, state) {
                  if (state is UserFormSuccessState){
                  userListBloc.add(GetUsers());
                  Navigator.pop(context);

                  }
                },
                child: BlocBuilder<UserFormBloc, UserFormState>(
                  builder: (context, state) {
                    if (state is UserFormSuccessState) {
                      return loading();
                    }else if (state is UserFormErrorState) {
                      print("Error");
                      return error(state.message);
                    }else if (state is UserFormLoadedState) {
                      User user = state.user?.id == null ? User() : state.user;
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                          TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Name',
                              ),
                              initialValue: user?.name ?? '',
                              onChanged: (value) {
                                user?.name = value;
                              },
                              validator: (value) {
                                if (value.length < 1) {
                                  return 'Name cannot be empty';
                                }
                                return null;
                              }),
                          TextFormField(
                              keyboardType: TextInputType.emailAddress,

                              decoration: InputDecoration(
                                labelText: 'Username',
                              ),
                              initialValue: user?.userName ?? '',
                              onChanged: (value) {
                                user?.userName = value;
                              },
                              validator: (value) {
                                if (value.length < 1) {
                                  return 'Username cannot be empty';
                                }
                                return null;
                              }),
                          TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                              ),
                              initialValue: user?.email ?? '',
                              onChanged: (value) {
                                user?.email = value;
                              },
                              validator: (value) {
                                if (value.length < 1) {
                                  return 'Email cannot be empty';
                                }
                                return null;
                              }),
                          RaisedButton(
                            child: Text('Submit'),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                userFormBloc.add(user?.id == null
                                    ? CreateUserEvent(user: user)
                                    : UpdateUserEvent(user: user));
                              }
                            },
                          )
                        ],
                        ),
                      );
                    }
                    return Container();

                  }
                ),
              ),
            ),
          ),
        ),
        
      ),
    );
  }
}