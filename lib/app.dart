import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:valorant_elo_tracker/consts/colors.dart';
import 'package:valorant_elo_tracker/repository/authentication/authentication_repository.dart';
import 'package:valorant_elo_tracker/repository/valorant/valorant_repository.dart';
import 'package:valorant_elo_tracker/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:valorant_elo_tracker/valorant/bloc/valorant_bloc.dart';

import 'authentication/bloc/authentication_bloc.dart';
import 'repository/user/user_repository.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
    @required this.valorantRepository,
    @required this.userRepository,
    @required this.logger,
  })  : assert(authenticationRepository != null),
        assert(valorantRepository != null),
        assert(userRepository != null),
        assert(logger != null);

  final AuthenticationRepository authenticationRepository;
  final ValorantRepository valorantRepository;
  final UserRepository userRepository;
  final Logger logger;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: valorantRepository),
        RepositoryProvider.value(value: userRepository),
        RepositoryProvider.value(value: logger),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
              userRepository: userRepository,
              logger: logger,
            )..add(AuthenticationStoredUserChecked()),
          ),
          BlocProvider(
            create: (_) => ValorantBloc(
              valorantRepository: valorantRepository,
              logger: logger,
            ),
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
        accentColor: VALORANT_RED,
        scaffoldBackgroundColor: VALORANT_BLACK,
        unselectedWidgetColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      builder: (context, router) {
        return router;
      },
      // builder: (context, router) {
      //   return LogConsoleOnShake(child: router);
      // },
    );
  }
}
