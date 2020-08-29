import 'package:crud_bloc/bloc/authentication/authentication_bloc.dart';
import 'package:crud_bloc/bloc/user_form/user_form_bloc.dart';
import 'package:crud_bloc/bloc/user_list/user_list_bloc.dart';
import 'package:crud_bloc/data/model/auth_user.dart';
import 'package:crud_bloc/data/model/user_model.dart';
import 'package:crud_bloc/screen/form_screen.dart';
import 'package:crud_bloc/widget/error_widget.dart';
import 'package:crud_bloc/widget/loading_widget.dart';
import 'package:crud_bloc/widget/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListScreen extends StatefulWidget {
  final AuthUser authUser;
  ListScreen({this.authUser});
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  UserListBloc userListBloc;
  UserFormBloc userFormBloc;
  AuthenticationBloc authBloc;

  TextEditingController _searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    userListBloc = BlocProvider.of<UserListBloc>(context);
    userFormBloc = BlocProvider.of<UserFormBloc>(context);
    authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      appBar: AppBar(

        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              authBloc.add(UserLoggedOut());
            },
          )
        ],
        title: TextField(
          controller: _searchController,
          autocorrect: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                userListBloc.add(GetUsers(query: _searchController.text));
              },
            ),
            hintText: 'Search...',
          ),
        ),
      ),
      body: Center(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            userListBloc.add(GetUsers());
          },
          child: BlocListener<UserFormBloc, UserFormState>(
            listener: (context, state) {
              if (state is UserFormSuccessState) {
                if(state.successMessage.isNotEmpty) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.successMessage),
                      duration: Duration(seconds: 1),
                    )
                  );
                 
                }
            
              }
            },
            child: BlocBuilder<UserListBloc, UserListState>(
              builder: (context, state) {
                if (state is UserListLoadedState){
                  return Container(
                    child: state.users.isNotEmpty 
                        ? ListView.builder(
                          itemCount: (state.users.length),
                          itemBuilder: (context, index) {
                            User user = state.users[index];
                            return _userCard(user, context);
                          }
                        ) 
                        : NoData()
                  );

                }else if (state is UserListLoadingState) {
                  return loading();
                }else if (state is UserListErrorState) {
                  return error(state.message);
                }
                return Container();
              }
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton( 
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute<FormScreen>(
              builder: (context) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<UserListBloc>.value(
                      value: userListBloc
                    ),
                    BlocProvider<UserFormBloc>.value(
                      value: userFormBloc..add(GetUserEvent())
                    )
                  ],
                child: FormScreen()
                );
              }
            )
          );
        },
      ),
    );
  }

  Card _userCard(User user, BuildContext context) {
    return Card(
        child: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(padding: EdgeInsets.all(10), child: Text(user.name)),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<FormScreen>(
                      builder: (context) {
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider<UserFormBloc>.value(
                                value: userFormBloc
                                  ..add(GetUserEvent(user: user))
                            ),
                            BlocProvider<UserListBloc>.value(
                                value: userListBloc),
                          ],
                          child: FormScreen(),
                        );
                      },
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  userListBloc.add(DeleteUser(user: user));
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${user.name} Deleted"),
                      duration: Duration(seconds: 1),
                    )
                  );
                },
              )
            ],
          ),
        ],
      ),
    ));
  }
}
