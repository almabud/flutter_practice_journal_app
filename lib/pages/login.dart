import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:journal_client/services/firebase_auth.dart';

import '../blocks/login_bloc.dart';

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {
  late LoginBloc _loginBloc;

  void initState() {
    super.initState();
    _loginBloc = LoginBloc(AuthenticationService());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(bottom: PreferredSize(
          child: Icon(
            Icons.account_circle,
            size: 88.0,
            color: Colors.white,
          ),
          preferredSize: Size.fromHeight(40.0)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              left: 16.0, top: 32.0, right: 16.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StreamBuilder(
                    stream: _loginBloc.email,
                    builder: (BuildContext context, AsyncSnapshot snapshot) =>
                        TextField(
                          decoration: InputDecoration(
                              labelText: 'Email Address',
                              icon: Icon(Icons.mail_outline),
                              errorText: snapshot.error as String?
                          ),
                          onChanged: _loginBloc.emailChanged.add,
                        ),
                  ),
                  StreamBuilder(
                    stream: _loginBloc.password,
                    builder: (BuildContext context, AsyncSnapshot snapshot) =>
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              icon: Icon(Icons.security),
                              errorText: snapshot.error as String?),
                          onChanged: _loginBloc.passwordChanged.add,
                        ),
                  ),
                  SizedBox(height: 48.0),
                  _buildLoginAndCreateButtons(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginAndCreateButtons() {
    return StreamBuilder(
      initialData: 'Login',
      stream: _loginBloc.loginOrCreateButton,
      builder: ((BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == 'Login') {
          return _buttonsLogin();
        } else if (snapshot.data == 'Create Account') {
          return _buttonsCreateAccount();
        }else{
          return Container();
        }
      }),
    );
  }

  Column _buttonsLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 16.0,
                  backgroundColor: Colors.lightGreen.shade200,
                  disabledBackgroundColor: Colors.grey.shade100,
                ),

                child: Text('Login'),
                onPressed: snapshot.data
                    ? () => _loginBloc.loginOrCreateChanged.add('Login')
                    : null,
              ),
        ),
        TextButton(
          child: Text('Create Account'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('Create Account');
          },
        ),
      ],
    );
  }

  Column _buttonsCreateAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
          initialData: false,
          stream: _loginBloc.enableLoginCreateButton,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 16.0,
                  backgroundColor: Colors.lightGreen.shade200,
                  disabledBackgroundColor: Colors.grey.shade100,
                ),
                child: Text('Create Account'),
                onPressed: snapshot.data
                    ? () =>
                    _loginBloc.loginOrCreateChanged.add('Create Account')
                    : null,
              ),
        ),
        TextButton(
          child: Text('Login'),
          onPressed: () {
            _loginBloc.loginOrCreateButtonChanged.add('Login');
          },
        ),
      ],
    );
  }

  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}