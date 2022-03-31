import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:live_stream_app/constants/message_response.dart';
import 'package:live_stream_app/modules/sign_up/model/sign_up_request.dart';
import 'package:live_stream_app/utils/api_exceptions.dart';

import '../sign_up_repository.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpRepository _signUpRepository = SignUpRepository();

  SignUpBloc() : super(SignUpInitial());

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is SignUpSubmitted) {
      try {
        yield SignUpLoadingState();
        await _signUpRepository.doSignUp(signUpRequest: event.signUpRequest);
        yield SignUpSuccessState();
      } catch (e) {
        yield SignUpErrorState(
            DioExceptions.fromDioError(e as DioError).message);
      }
    }

    if (event is UploadImage) {
      try {
        yield UploadImageLoadingState();
        MessageResponse message =
            await _signUpRepository.uploadImage(event.imageFile);
        yield UploadImageSuccessState(message.message ?? '');
      } catch (e) {
        yield UploadImageErrorState(
            DioExceptions.fromDioError(e as DioError).message);
      }
    }
  }
}
