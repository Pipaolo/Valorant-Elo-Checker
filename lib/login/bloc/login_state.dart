part of 'login_bloc.dart';

class LoginState extends Equatable {
  final FormzStatus status;
  final Username username;
  final Password password;
  final Region region;

  const LoginState(
      {this.status = FormzStatus.pure,
      this.username = const Username.pure(),
      this.password = const Password.pure(),
      this.region = const Region.pure()});

  LoginState copyWith({
    FormzStatus status,
    Username username,
    Password password,
    Region region,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      region: region ?? this.region,
    );
  }

  @override
  List<Object> get props => [status, username, password, region];
}
