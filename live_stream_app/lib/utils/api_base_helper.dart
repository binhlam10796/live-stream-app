import 'dart:async';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'api_logging_interceptor.dart';

class ApiBaseHelper {
  Dio _dio = Dio();

  ApiBaseHelper() {
    BaseOptions options =
        BaseOptions(receiveTimeout: 300000, connectTimeout: 300000);
    _dio = Dio(options);
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    _dio.interceptors.add(LoggingInterceptor());
  }

  Future<dynamic> getHttp(String uri,
      {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> postHttp(String uri,
      {data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final Response response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> putHttp(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      required Options options}) async {
    try {
      final response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> deleteHttp(String uri,
      {data,
      required Map<String, dynamic> queryParameters,
      required Options options}) async {
    _dio.interceptors.add(LoggingInterceptor());
    try {
      final response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } catch (e) {
      throw e;
    }
  }
}
