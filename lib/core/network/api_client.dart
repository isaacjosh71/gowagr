import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiClient {
  late final Dio _dio;
  static const int _timeout = 30000;

  ApiClient() {
    _dio = Dio(BaseOptions(
      connectTimeout: Duration(milliseconds: _timeout),
      receiveTimeout: Duration(milliseconds: _timeout),
      sendTimeout: Duration(milliseconds: _timeout),
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
  }

  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
      }) async {
    if (!await _hasInternetConnection()) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: 'No internet connection',
        type: DioExceptionType.connectionError,
      );
    }

    return await _dio.get(path, queryParameters: queryParameters);
  }
}