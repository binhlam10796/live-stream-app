import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_stream_app/constants/constants.dart';
import 'package:live_stream_app/constants/message_response.dart';
import 'package:live_stream_app/modules/sign_up/model/sign_up_request.dart';
import 'package:live_stream_app/utils/api_base_helper.dart';

class SignUpRepository {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<MessageResponse> doSignUp({
    required SignUpRequest signUpRequest,
  }) async {
    try {
      final response = await _apiBaseHelper.postHttp(
        "$baseUrl/auth/signup",
        data: signUpRequest.toJson(),
      );
      return MessageResponse.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<MessageResponse> uploadImage(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap(
        {
          'file':
              await MultipartFile.fromFile(imageFile.path, filename: fileName),
        },
      );
      final response = await _apiBaseHelper.postHttp("$baseUrl/file/upload",
          data: formData,
          options: Options(
            headers: {
              'content-type': 'multipart/form-data',
              'accept': '*/*',
            },
          ));
      return MessageResponse.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
