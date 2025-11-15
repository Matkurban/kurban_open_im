import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["operationID"] = DateTime.now().millisecondsSinceEpoch.toString();
    super.onRequest(options, handler);
  }
}
