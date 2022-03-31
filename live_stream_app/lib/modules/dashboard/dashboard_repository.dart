import 'package:dio/dio.dart';
import 'package:live_stream_app/constants/constants.dart';
import 'package:live_stream_app/constants/globals.dart';
import 'package:live_stream_app/constants/message_response.dart';
import 'package:live_stream_app/modules/dashboard/model/approve_request.dart';
import 'package:live_stream_app/modules/stream/model/stream_request.dart';
import 'package:live_stream_app/modules/dashboard/model/stream_response.dart';
import 'package:live_stream_app/utils/api_base_helper.dart';

class DashboardRepository {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<MessageResponse> uploadStream(StreamRequest streamRequest) async {
    try {
      final response = await _apiBaseHelper.postHttp(
        "$baseUrl/stream/upload",
        options: Options(
          headers: {
            "authorization": "Bearer $accessToken",
          },
        ),
        data: streamRequest.toJson(),
      );
      return MessageResponse.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<List<StreamResponse>> fetchAllStream() async {
    try {
      final response = await _apiBaseHelper.getHttp(
        "$baseUrl/stream/all-stream",
        options: Options(
          headers: {
            "authorization": "Bearer $accessToken",
          },
        ),
      );
      return (response as List)
          .map((dynamic data) =>
              StreamResponse.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  Future<List<StreamResponse>> fetchStreamByUser({
    required int userId,
  }) async {
    try {
      final response = await _apiBaseHelper.getHttp(
        "$baseUrl/stream/by-user",
        queryParameters: {
          "userID": userId,
        },
        options: Options(
          headers: {
            "authorization": "Bearer $accessToken",
          },
        ),
      );
      return (response as List)
          .map((dynamic data) =>
              StreamResponse.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  Future<MessageResponse> approveStream(ApproveRequest approveRequest) async {
    try {
      final response = await _apiBaseHelper.putHttp(
        "$baseUrl/stream/approve",
        data: approveRequest.toJson(),
        options: Options(
          headers: {
            "authorization": "Bearer $accessToken",
          },
        ),
      );
      return MessageResponse.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
