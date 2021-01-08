import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valorant_elo_tracker/consts/colors.dart';
import 'package:valorant_elo_tracker/repository/authentication/authentication_repository.dart';
import 'package:valorant_elo_tracker/repository/valorant/valorant_repository.dart';
import 'package:valorant_elo_tracker/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:valorant_elo_tracker/valorant/bloc/valorant_bloc.dart';

import 'authentication/bloc/authentication_bloc.dart';

class App extends StatelessWidget {
  const App(
      {Key key,
      @required this.authenticationRepository,
      @required this.valorantRepository})
      : assert(authenticationRepository != null),
        assert(valorantRepository != null);

  final AuthenticationRepository authenticationRepository;

  final ValorantRepository valorantRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: valorantRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (_) => ValorantBloc(valorantRepository: valorantRepository),
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Valorant Elo Checker",
      theme: ThemeData(
          fontFamily: "Anton",
          primaryColor: VALORANT_RED,
          scaffoldBackgroundColor: VALORANT_BLACK),
      debugShowCheckedModeBanner: false,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      builder: (context, router) {
        return router;
      },
    );
  }
}
