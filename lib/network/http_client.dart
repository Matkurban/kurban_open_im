import 'package:dio/dio.dart';
import 'package:kurban_open_im/config/app_config.dart';
import 'package:kurban_open_im/network/interceptor/auth_interceptor.dart';
import 'package:kurban_open_im/network/interceptor/loading_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class HttpClient {
  static late Dio dio;

  static HttpClient? instance;

  factory HttpClient() => instance ?? HttpClient._();

  HttpClient._() {
    dio = _createDio;
  }

  Dio get _createDio {
    var dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.appAuthUrl,
        connectTimeout: Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );
    dio.interceptors.addAll([
      AuthInterceptor(),
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseMessage: true,
        ),
      ),
    ]);
    return dio;
  }

  /// GET请求
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool openLoading = false,
  }) async {
    _handleLoading(openLoading);
    final Response response = await dio.get(
      url,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }

  /// POST请求
  Future<Response> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool openLoading = false,
  }) async {
    _handleLoading(openLoading);
    final Response response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }

  /// PUT请求
  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool openLoading = false,
  }) async {
    _handleLoading(openLoading);
    final Response response = await dio.put(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }

  /// DELETE请求
  Future<Response> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool openLoading = false,
  }) async {
    _handleLoading(openLoading);
    final Response response = await dio.delete(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// 下载请求
  Future<Response> download(
    String urlPath,
    dynamic savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    FileAccessMode fileAccessMode = FileAccessMode.write,
    String lengthHeader = Headers.contentLengthHeader,
    Object? data,
    Options? options,
    bool openLoading = false,
  }) async {
    _handleLoading(openLoading);
    final Response response = await dio.download(
      urlPath,
      savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      deleteOnError: deleteOnError,
      fileAccessMode: fileAccessMode,
      lengthHeader: lengthHeader,
      data: data,
      options: options,
    );
    return response;
  }

  static void _handleLoading(bool openLoading) {
    if (openLoading) {
      dio.interceptors.add(LoadingInterceptor());
    } else {
      dio.interceptors.removeWhere((inter) {
        return inter is LoadingInterceptor;
      });
    }
  }
}
