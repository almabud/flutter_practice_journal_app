import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../services/authentication_api.dart';

class AuthenticationBloc{
  final AuthenticationApi authenticationApi;
  final StreamController<String> _authenticationController = StreamController<String>();
  Sink<String> get addUser => _authenticationController.sink;
  Stream<String> get user => _authenticationController.stream;
  final StreamController<bool> _logoutController = StreamController<bool>();
  Sink<bool> get logoutUser => _logoutController.sink;
  Stream<bool> get listLogoutUser => _logoutController.stream;

  AuthenticationBloc(this.authenticationApi){
    onAuthChanged();
  }

  void dispose(){
    _authenticationController.close();
    _logoutController.close();
  }

  void onAuthChanged(){
    authenticationApi
        .getFirebaseAuth()
        .authStateChanges()
        .listen((User ?user){
          final String uid = user != null ? user.uid : '';
          addUser.add(uid);
    });
    _logoutController.stream.listen((logout) {
      if (logout == true){
        _signOut();
      }
    });
  }

  void _signOut(){
    authenticationApi.signOut();
  }
}