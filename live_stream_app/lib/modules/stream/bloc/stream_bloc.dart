import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:live_stream_app/modules/stream/stream_repository.dart';
import 'package:live_stream_app/utils/api_exceptions.dart';

import '../../../constants/message_response.dart';
import '../model/stream_request.dart';

part 'stream_event.dart';
part 'stream_state.dart';

class StreamBloc extends Bloc<StreamEvent, StreamState> {
  final StreamRepository _streamRepository = StreamRepository();

  StreamBloc() : super(StreamInitial());

  @override
  Stream<StreamState> mapEventToState(
    StreamEvent event,
  ) async* {
    if (event is UploadStream) {
      try {
        yield UploadStreamLoadingState();
        MessageResponse message =
            await _streamRepository.uploadStream(event.streamRequest);
        yield UploadStreamSuccessState(message);
      } catch (e) {
        yield UploadStreamErrorState(
            DioExceptions.fromDioError(e as DioError).message);
      }
    }
  }
}
