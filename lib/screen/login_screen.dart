import 'package:crud_bloc/bloc/authentication/authentication_bloc.dart';
import 'package:crud_bloc/bloc/login/login_bloc.dart';
import 'package:crud_bloc/data/reposities/user_reposities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthenticationBloc authBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(16),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            authBloc = BlocProvider.of<AuthenticationBloc>(context);

            if (state is AuthenticationNotAuthenticated) {
              return _AuthForm();
            }
            if (state is AuthenticationFailure) {
              //show error message
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(state.message),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text('Retry'),
                      onPressed: (){
                        authBloc.add(AppLoaded());
                      },
                    )
                  ],
                ),
              );
            }
            // show splash screen
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2
              ),
            );
          }
        ),
      ),      
    );
  }
}



class _AuthForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final repository = RepositoryProvider.of<UserRepository>(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Container(
      alignment: Alignment.center,
      child: BlocProvider<LoginBloc>(
        
        create: (context) => LoginBloc(repository, authBloc),
        child: _SignInForm(),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override
  __SignInFormState createState() => __SignInFormState();
}

class __SignInFormState extends State<_SignInForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _autoValidate = false;

  LoginBloc _loginBloc;

  @override
  Widget build(BuildContext context) {
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    _onLoginButtonPressed() {
      if (_key.currentState.validate()) {
        _loginBloc.add(LoginWithEmailButtonPressed(email: _emailController.text, password: _passwordController.text));

      }else {
        setState(() {
          _autoValidate =true;
        });
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          _showError(state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _key,
            autovalidate: _autoValidate,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email address',
                      filled: true,
                      isDense: true
                    ),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      isDense: true
                    ),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Text('LOG IN'),
                    onPressed: state is LoginLoading ? () {} : _onLoginButtonPressed,
                  )
                ],
              ),
            ),
          );

        }
      ),
    );
  }

  void _showError(String error) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Theme.of(context).errorColor
      )
    );
  }
}