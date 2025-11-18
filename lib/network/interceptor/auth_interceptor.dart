import 'package:dio/dio.dart';
import 'package:kurban_open_im/constant/constants.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["operationID"] = DateTime.now().millisecondsSinceEpoch.toString();
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    error(
      "${err.requestOptions.path}\n${err.response.toString()}",
      error: err.error,
      stackTrace: err.stackTrace,
    );
    super.onError(err, handler);
  }
}
