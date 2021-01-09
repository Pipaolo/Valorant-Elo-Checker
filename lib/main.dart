import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:valorant_elo_tracker/app.dart';
import 'package:valorant_elo_tracker/dio/dio.dart';
import 'package:valorant_elo_tracker/logger/logger.dart';
import 'package:valorant_elo_tracker/repository/authentication/authentication_repository.dart';
import 'package:valorant_elo_tracker/repository/user/user_repository.dart';

import 'package:valorant_elo_tracker/repository/valorant/valorant_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dioClient = DioClient();
  await dioClient.setup();
  await Hive.initFlutter();

  runApp(
    App(
      authenticationRepository: AuthenticationRepository(
        dioClient: dioClient,
      ),
      valorantRepository: ValorantRepository(),
      userRepository: UserRepository(),
      logger: Logger(
        printer:
            PrettyPrinter(printEmojis: false, printTime: true, methodCount: 0),
        output: ValorantLogOutput(),
      ),
    ),
  );
}
