import 'dart:async';

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:live_stream_app/constants/globals.dart';
import 'package:live_stream_app/modules/sign_in/model/sign_in_response.dart';
import 'package:live_stream_app/utils/api_exceptions.dart';

import '../sign_in_repository.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInRepository _signIpRepository = SignInRepository();

  SignInBloc() : super(SignInInitial());

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is SignInSubmitted) {
      try {
        yield SignInLoadingState();
        SignInResponse signInResponse = await _signIpRepository.doSignIn(
            username: event.username, password: event.password);
        userID = signInResponse.id ?? -1;
        accessToken = signInResponse.accessToken ?? '';
        refreshToken = signInResponse.refreshToken ?? '';
        roles = signInResponse.roles ?? [];
        yield SignInSuccessState();
      } catch (e) {
        yield SignInErrorState(
            DioExceptions.fromDioError(e as DioError).message);
      }
    }

    if (event is SignOutSubmitted) {
      try {
        yield SignOutLoadingState();
        await _signIpRepository.doSignOut(userId: event.userID);
        yield SignOutSuccessState();
      } catch (e) {
        yield SignOutErrorState(
            DioExceptions.fromDioError(e as DioError).message);
      }
    }
  }
}
