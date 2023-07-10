import 'package:flutter/cupertino.dart';

import 'authentication_bloc.dart';

class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBloc authenticationBloc;

  const AuthenticationBlocProvider(
      {super.key, required Widget child, required this.authenticationBloc})
      : super(child: child);

  static AuthenticationBlocProvider of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>()
    as AuthenticationBlocProvider);
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider old) =>
      authenticationBloc != old.authenticationBloc;
}