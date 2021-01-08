import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class DioClient {
  final Dio dio = Dio();

  DioClient() {
    final cookieJar = CookieJar();
    this.dio.interceptors.add(CookieManager(cookieJar));
  }
}
