import 'package:auto_route/annotations.dart';
import 'package:valorant_elo_tracker/login/login.dart';
import 'package:valorant_elo_tracker/home/home.dart';
import 'package:valorant_elo_tracker/splash/splash.dart';

@MaterialAutoRouter(routes: <AutoRoute>[
  AutoRoute(page: SplashPage, initial: true),
  AutoRoute(page: LoginPage),
  AutoRoute(page: HomePage),
])
class $AppRouter {}
