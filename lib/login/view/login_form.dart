import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:valorant_elo_tracker/consts/colors.dart';
import 'package:valorant_elo_tracker/login/bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text("Authentication Failure"),
                ),
              );
          }
        },
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _UsernameInput(),
              const Padding(padding: EdgeInsets.all(12)),
              _PasswordInput(),
              const Padding(padding: EdgeInsets.all(12)),
              _RegionInput(),
              const Padding(padding: EdgeInsets.all(12)),
              _SaveCredentialsInput(),
              _LoginButton(),
            ],
          ),
        ));
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: 'Username',
            errorText: state.username.invalid ? 'Invalid username' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: 'Password',
            errorText: state.password.invalid ? 'Invalid password' : null,
          ),
        );
      },
    );
  }
}

class _SaveCredentialsInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.saveCredentials != current.saveCredentials,
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              value: state.saveCredentials.value,
              onChanged: (e) => context.read<LoginBloc>().add(
                    LoginSaveCredentialsChanged(e),
                  ),
            ),
            Text(
              "Save Credentials",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RegionInput extends StatelessWidget {
  static const _regions = {
    'na': "North America",
    "ap": "Asia Pacific",
    "eu": "Europe",
    "kr": "Korea",
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.region != current.region,
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(8),
            child: DropdownButton(
              isExpanded: true,
              underline: Container(
                height: 1,
                color: VALORANT_RED,
              ),
              value: state.region.value,
              hint: Text("Region"),
              key: const Key('loginForm_regionInput_dropdownButton'),
              onChanged: (region) =>
                  context.read<LoginBloc>().add(LoginRegionChanged(region)),
              items: _regions.keys
                  .map(
                    (key) => DropdownMenuItem(
                      child: Text(_regions[key]),
                      value: key,
                    ),
                  )
                  .toList(),
            ),
          );
        });
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(VALORANT_RED),
              )
            : Container(
                width: double.infinity,
                child: RaisedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  child: const Text('Login'),
                  color: Colors.white,
                  onPressed: state.status.isValidated
                      ? () {
                          context.read<LoginBloc>().add(const LoginSubmitted());
                        }
                      : null,
                ),
              );
      },
    );
  }
}
