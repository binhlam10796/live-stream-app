import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
    logPrint(
        '****************************** API Request - Start ******************************');

    printKV('URI', options.uri);
    printKV('METHOD', options.method);
    logPrint('HEADERS:');
    options.headers.forEach((key, v) => printKV(' - $key', v));
    logPrint('BODY:');
    printAll(options.data ?? "");

    logPrint(
        '****************************** API Request - End ******************************');
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    logPrint(
        '****************************** Api Error - Start ******************************:');

    logPrint('URI: ${err.requestOptions.uri}');
    if (err.response != null) {
      logPrint('STATUS CODE: ${err.response!.statusCode?.toString()}');
    }
    logPrint('$err');
    if (err.response != null) {
      printKV('REDIRECT', err.response!.realUri);
      logPrint('BODY:');
      printAll(err.response?.toString());
    }

    logPrint(
        '****************************** Api Error - End ******************************:');
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    logPrint(
        '****************************** Api Response - Start ******************************');

    printKV('URI', response.requestOptions.uri);
    printKV('STATUS CODE', response.statusCode as int);
    printKV('REDIRECT', response.isRedirect as bool);
    logPrint('BODY:');
    printAll(response.data ?? "");

    logPrint(
        '****************************** Api Response - End ******************************');
  }

  void printKV(String key, Object v) {
    logPrint('$key: $v');
  }

  void printAll(msg) {
    msg.toString().split('\n').forEach(logPrint);
  }

  void logPrint(String s) {
    log(s);
  }
}
