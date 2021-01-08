import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:valorant_elo_tracker/dio/dio.dart';

import 'package:valorant_elo_tracker/repository/user/models/user.dart';
import 'package:valorant_elo_tracker/utils/utils.dart';

const String URL = 'https://auth.riotgames.com/api/v1/authorization';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthenticationRepository {
  AuthenticationRepository({@required this.dioClient})
      : assert(dioClient != null);

  final _controller = StreamController<User>();
  final DioClient dioClient;
  User _loggedInUser;

  Stream<User> get user async* {
    if (_loggedInUser == null) {
      yield User.empty;
    } else {
      yield _loggedInUser;
    }
    yield* _controller.stream;
  }

  Future<void> logIn({
    @required String username,
    @required String password,
    @required String region,
  }) async {
    final sessionBody = {
      "client_id": "play-valorant-web-prod",
      "nonce": "1",
      "redirect_uri": "https://playvalorant.com/opt_in" + "",
      "response_type": "token id_token",
      "scope": "account openid"
    };

    final authBody = {
      "type": "auth",
      "username": username,
      "password": password,
    };

    // Generate a session for the device.
    await dioClient.dio
        .post(URL, data: jsonEncode(sessionBody))
        .then((value) => print(value.data));

    // Use the generated session for logging in.
    var authResponse = await dioClient.dio.put(URL, data: jsonEncode(authBody));

    if (authResponse.data['error'] != null) {
      throw Exception("Authentication Failed");
    }

    var rawAccessToken = authResponse.data['response']['parameters']['uri'];
    final accessToken = parseAccessToken(rawAccessToken);
    final entitlementsToken = await _getEntitlementsToken(accessToken);
    final userId = await _getUserId(accessToken);

    _loggedInUser = User(
      entitlementsToken: entitlementsToken,
      accessToken: accessToken,
      id: userId,
      region: region,
    );

    _controller.add(_loggedInUser);
  }

  Future<String> _getEntitlementsToken(String accessToken) async {
    final entitlementsResponse = await dioClient.dio.post(
      'https://entitlements.auth.riotgames.com/api/token/v1',
      options: Options(
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      ),
      data: jsonEncode(<String, String>{}),
    );

    final entitlementsToken = entitlementsResponse.data['entitlements_token'];
    return entitlementsToken;
  }

  Future<String> _getUserId(String accessToken) async {
    final response = await dioClient.dio.post(
      'https://auth.riotgames.com/userinfo',
      options: Options(
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      ),
      data: jsonEncode(<String, String>{}),
    );

    return response.data['sub'];
  }

  void logOut() {
    _loggedInUser = null;
    dioClient.clearCookies();
    _controller.add(User.empty);
  }

  void dispose() => _controller.close();
}
