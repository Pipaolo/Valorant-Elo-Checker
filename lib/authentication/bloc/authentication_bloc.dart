import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:valorant_elo_tracker/repository/authentication/authentication_repository.dart';
import 'package:valorant_elo_tracker/repository/user/models/user.dart';
import 'package:valorant_elo_tracker/repository/user/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  StreamSubscription<User> _authenticationUserSubscription;

  AuthenticationBloc(
      {@required AuthenticationRepository authenticationRepository,
      @required UserRepository userRepository})
      : assert(authenticationRepository != null),
        assert(userRepository != null),
        _userRepository = userRepository,
        _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    _authenticationUserSubscription = _authenticationRepository.user
        .listen((user) => add(AuthenticationUserChanged(user)));
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      yield await _mapAuthenticationStatusChangedToState(event);
    } else if (event is AuthenticationStoredUserChecked) {
      final isUserStored = await _userRepository.checkStoredUser();
      if (isUserStored) {
        final savedUser = await _userRepository.getUser();
        await _authenticationRepository.logIn(
            username: savedUser['username'],
            password: savedUser['password'],
            region: savedUser['region']);
      } else {
        yield AuthenticationState.unauthenticated();
      }
    } else if (event is AuthenticationLogoutRequested) {
      _userRepository.removeUser();
      _authenticationRepository.logOut();
    }
  }

  @override
  Future<void> close() {
    _authenticationUserSubscription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  Future<AuthenticationState> _mapAuthenticationStatusChangedToState(
      AuthenticationUserChanged event) async {
    if (event.user != User.empty) {
      return AuthenticationState.authenticated(event.user);
    } else {
      return AuthenticationState.unauthenticated();
    }
  }
}
