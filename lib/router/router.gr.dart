// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import '../splash/splash.dart' as _i2;
import '../login/login.dart' as _i3;
import '../home/home.dart' as _i4;

class AppRouter extends _i1.RootStackRouter {
  AppRouter();

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    SplashPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i2.SplashPage());
    },
    LoginPageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i3.LoginPage());
    },
    HomePageRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i4.HomePage());
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig<SplashPageRoute>(SplashPageRoute.name,
            path: '/',
            routeBuilder: (match) => SplashPageRoute.fromMatch(match)),
        _i1.RouteConfig<LoginPageRoute>(LoginPageRoute.name,
            path: '/login-page',
            routeBuilder: (match) => LoginPageRoute.fromMatch(match)),
        _i1.RouteConfig<HomePageRoute>(HomePageRoute.name,
            path: '/home-page',
            routeBuilder: (match) => HomePageRoute.fromMatch(match))
      ];
}

class SplashPageRoute extends _i1.PageRouteInfo {
  const SplashPageRoute() : super(name, path: '/');

  SplashPageRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'SplashPageRoute';
}

class LoginPageRoute extends _i1.PageRouteInfo {
  const LoginPageRoute() : super(name, path: '/login-page');

  LoginPageRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'LoginPageRoute';
}

class HomePageRoute extends _i1.PageRouteInfo {
  const HomePageRoute() : super(name, path: '/home-page');

  HomePageRoute.fromMatch(_i1.RouteMatch match) : super.fromMatch(match);

  static const String name = 'HomePageRoute';
}
