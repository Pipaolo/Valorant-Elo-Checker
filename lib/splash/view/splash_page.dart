import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valorant_elo_tracker/authentication/bloc/authentication_bloc.dart';
import 'package:valorant_elo_tracker/consts/colors.dart';
import 'package:valorant_elo_tracker/repository/authentication/authentication_repository.dart';
import 'package:valorant_elo_tracker/router/router.gr.dart';
import 'package:valorant_elo_tracker/valorant/bloc/valorant_bloc.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final deviceWidth = mediaQuery.width;
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            BlocProvider.of<ValorantBloc>(context)
              ..add(ValorantCompetitiveDetailsFetched(user: state.user));
            AutoRouter.of(context).replace(HomePageRoute());
            break;
          case AuthenticationStatus.unauthenticated:
            AutoRouter.of(context).replace(LoginPageRoute());
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Valorant Elo Tracker",
              style: TextStyle(color: VALORANT_RED, fontSize: deviceWidth * .1),
            ),
            const SizedBox(height: 100),
            CircularProgressIndicator()
          ],
        )),
      ),
    );
  }
}
