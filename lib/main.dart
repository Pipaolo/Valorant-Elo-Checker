import 'package:flutter/material.dart';
import 'package:valorant_elo_tracker/app.dart';
import 'package:valorant_elo_tracker/repository/authentication/authentication_repository.dart';

import 'package:valorant_elo_tracker/repository/valorant/valorant_repository.dart';

void main() {
  runApp(App(
    authenticationRepository: AuthenticationRepository(),
    valorantRepository: ValorantRepository(),
  ));
}
