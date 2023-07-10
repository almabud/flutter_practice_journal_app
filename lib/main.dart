import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:journal_client/pages/home.dart';
import 'package:journal_client/pages/login.dart';
import 'package:journal_client/services/db_firestore.dart';
import 'package:journal_client/services/firebase_auth.dart';

import 'blocks/authentication_bloc.dart';
import 'blocks/authentication_provider.dart';
import 'blocks/home_bloc.dart';
import 'blocks/home_bloc_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthenticationService _authenticationService =
        AuthenticationService();
    final AuthenticationBloc _authenticationBloc =
        AuthenticationBloc(_authenticationService);
    return AuthenticationBlocProvider(
      authenticationBloc: _authenticationBloc,
      child: StreamBuilder(
        initialData: null,
        stream: _authenticationBloc.user,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildMaterialApp(Scaffold(
                body: Container(
              color: Colors.lightGreen,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )));
          } else if (snapshot.hasData && snapshot.data != '') {
            return HomeBlocProvider(
              homeBloc: HomeBloc(DbFirestoreService(), _authenticationService),
              uid: snapshot.data,
              child: _buildMaterialApp(Home()),
            );
          } else {
            return _buildMaterialApp(Login());
          }
        },
      ),
    );
  }

  MaterialApp _buildMaterialApp(Widget homePage) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Security Inherited',
      theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          canvasColor: Colors.lightGreen.shade50,
          bottomAppBarTheme: BottomAppBarTheme(color: Colors.lightGreen)),
      home: homePage,
    );
  }
}
