import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

class UserRepository {
  Future<Map<dynamic, dynamic>> getUser() async {
    final box = await Hive.openBox('auth');
    final rawUser = await box.get("user");

    return rawUser;
  }

  Future<void> storeUser({
    @required String username,
    @required String password,
    @required String region,
  }) async {
    final box = await Hive.openBox("auth");
    box.put("user", {
      "username": username,
      "password": password,
      "region": region,
    });
  }

  Future<void> removeUser() async {
    final box = await Hive.openBox('auth');
    await box.clear();
  }

  Future<bool> checkStoredUser() async {
    final box = await Hive.openBox("auth");
    return box.get("user") != null;
  }
}
