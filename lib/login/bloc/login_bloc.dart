import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:valorant_elo_tracker/login/login.dart';

import 'package:valorant_elo_tracker/repository/authentication/authentication_repository.dart';
import 'package:valorant_elo_tracker/repository/user/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  LoginBloc({
    @required AuthenticationRepository authenticationRepository,
    @required UserRepository userRepository,
  })  : assert(authenticationRepository != null),
        assert(userRepository != null),
        _userRepository = userRepository,
        _authenticationRepository = authenticationRepository,
        super(const LoginState());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginUsernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is LoginRegionChanged) {
      yield _mapRegionChangedToState(event, state);
    } else if (event is LoginSaveCredentialsChanged) {
      yield _mapSaveCredentialsChangedToState(event, state);
    } else if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(event, state);
    }
  }

  LoginState _mapUsernameChangedToState(
      LoginUsernameChanged event, LoginState state) {
    final username = Username.dirty(event.username);
    return state.copyWith(
        username: username,
        status: Formz.validate(
            [state.password, state.region, state.saveCredentials, username]));
  }

  LoginState _mapPasswordChangedToState(
      LoginPasswordChanged event, LoginState state) {
    final password = Password.dirty(event.password);
    return state.copyWith(
        password: password,
        status: Formz.validate(
            [state.username, state.region, state.saveCredentials, password]));
  }

  LoginState _mapRegionChangedToState(
      LoginRegionChanged event, LoginState state) {
    final region = Region.dirty(event.region);
    return state.copyWith(
        region: region,
        status: Formz.validate(
            [state.username, state.password, state.saveCredentials, region]));
  }

  LoginState _mapSaveCredentialsChangedToState(
      LoginSaveCredentialsChanged event, LoginState state) {
    final saveCredentials = SaveCredentials.dirty(event.saveCredentials);
    return state.copyWith(
      saveCredentials: saveCredentials,
      status: Formz.validate(
          [state.username, state.password, state.region, saveCredentials]),
    );
  }

  Stream<LoginState> _mapLoginSubmittedToState(
      LoginSubmitted event, LoginState state) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await _authenticationRepository.logIn(
          username: state.username.value,
          password: state.password.value,
          region: state.region.value,
        );

        if (state.saveCredentials.value) {
          await _userRepository.storeUser(
              username: state.username.value,
              password: state.password.value,
              region: state.region.value);
        }

        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
