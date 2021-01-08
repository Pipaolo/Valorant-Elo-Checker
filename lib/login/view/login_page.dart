import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valorant_elo_tracker/authentication/bloc/authentication_bloc.dart';
import 'package:valorant_elo_tracker/consts/colors.dart';

import 'package:valorant_elo_tracker/login/bloc/login_bloc.dart';
import 'package:valorant_elo_tracker/repository/authentication/authentication_repository.dart';
import 'package:valorant_elo_tracker/repository/user/user_repository.dart';
import 'package:valorant_elo_tracker/router/router.gr.dart';
import 'package:valorant_elo_tracker/valorant/bloc/valorant_bloc.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            BlocProvider.of<ValorantBloc>(context)
              ..add(ValorantCompetitiveDetailsFetched(user: state.user));
            AutoRouter.of(context).replace(HomePageRoute());
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          centerTitle: true,
        ),
        backgroundColor: VALORANT_BLACK,
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: BlocProvider(
            create: (context) {
              return LoginBloc(
                authenticationRepository:
                    RepositoryProvider.of<AuthenticationRepository>(context),
                userRepository: RepositoryProvider.of<UserRepository>(context),
              );
            },
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
