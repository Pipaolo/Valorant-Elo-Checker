import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valorant_elo_tracker/authentication/bloc/authentication_bloc.dart';
import 'package:valorant_elo_tracker/repository/authentication/authentication_repository.dart';
import 'package:valorant_elo_tracker/router/router.gr.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            print(state.user.entitlementsToken);
            AutoRouter.of(context).replace(HomePageRoute());
            break;
          case AuthenticationStatus.unauthenticated:
            AutoRouter.of(context).replace(LoginPageRoute());
            break;
          default:
            break;
        }
      },
      child: Scaffold(),
    );
  }
}
