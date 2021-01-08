import 'package:flutter/material.dart';
import 'package:valorant_elo_tracker/app.dart';
import 'package:valorant_elo_tracker/dio/dio.dart';
import 'package:valorant_elo_tracker/repository/authentication/authentication_repository.dart';

import 'package:valorant_elo_tracker/repository/valorant/valorant_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dioClient = DioClient();
  await dioClient.setup();

  runApp(App(
    authenticationRepository: AuthenticationRepository(
      dioClient: dioClient,
    ),
    valorantRepository: ValorantRepository(),
  ));
}
