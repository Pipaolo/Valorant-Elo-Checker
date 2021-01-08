import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class DioClient {
  final Dio dio = Dio();

  PersistCookieJar _cookieJar;

  Future<void> setup() async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;

    _cookieJar = PersistCookieJar(
      dir: tempPath,
      ignoreExpires: true,
    );
    dio.interceptors.add(CookieManager(_cookieJar));

    // Make sure to clear cookies everytime before setting up Dio
    clearCookies();
  }

  void clearCookies() {
    _cookieJar.deleteAll();
  }
}
