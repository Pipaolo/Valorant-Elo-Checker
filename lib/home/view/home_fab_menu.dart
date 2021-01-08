import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boom_menu/flutter_boom_menu.dart';
import 'package:valorant_elo_tracker/authentication/bloc/authentication_bloc.dart';
import 'package:valorant_elo_tracker/consts/colors.dart';
import 'package:valorant_elo_tracker/router/router.gr.dart';

class HomeFabMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BoomMenu(
      animatedIcon: AnimatedIcons.menu_close,
      overlayColor: VALORANT_BLACK,
      children: [
        MenuItem(
          title: "Logout",
          subtitle: 'Logout from the current session.',
          onTap: () => _handleLogoutButtonPressed(context),
          child: Icon(Icons.logout),
        ),
      ],
    );
  }

  void _handleLogoutButtonPressed(BuildContext context) {
    BlocProvider.of<AuthenticationBloc>(context)
      ..add(AuthenticationLogoutRequested());
    AutoRouter.of(context).replace(LoginPageRoute());
  }
}
