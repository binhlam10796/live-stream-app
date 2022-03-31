import 'package:dio/dio.dart';
import 'package:live_stream_app/constants/constants.dart';
import 'package:live_stream_app/constants/globals.dart';
import 'package:live_stream_app/constants/message_response.dart';
import 'package:live_stream_app/modules/stream/model/stream_request.dart';
import 'package:live_stream_app/utils/api_base_helper.dart';

class StreamRepository {
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
}
