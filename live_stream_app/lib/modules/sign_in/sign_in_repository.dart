import 'package:live_stream_app/constants/constants.dart';
import 'package:live_stream_app/constants/message_response.dart';
import 'package:live_stream_app/utils/api_base_helper.dart';

import 'model/sign_in_response.dart';

class SignInRepository {
  final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  Future<SignInResponse> doSignIn({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _apiBaseHelper.postHttp(
        "$baseUrl/auth/signin",
        data: {
          "username": username,
          "password": password,
        },
      );
      return SignInResponse.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<MessageResponse> doSignOut({
    required int userId,
  }) async {
    try {
      final response = await _apiBaseHelper.postHttp(
        "$baseUrl/auth/signout",
        data: {
          "userId": userId,
        },
      );
      return MessageResponse.fromJson(response);
    } catch (e) {
      throw e;
    }
  }
}
