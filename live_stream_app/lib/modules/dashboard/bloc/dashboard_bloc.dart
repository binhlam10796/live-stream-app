import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:live_stream_app/constants/message_response.dart';
import 'package:live_stream_app/modules/dashboard/dashboard_repository.dart';
import 'package:live_stream_app/modules/dashboard/model/approve_request.dart';
import 'package:live_stream_app/modules/dashboard/model/stream_response.dart';
import 'package:live_stream_app/utils/api_exceptions.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _dashboardRepository = DashboardRepository();

  DashboardBloc() : super(DashboardInitial());

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    if (event is FetchAllStream) {
      try {
        yield FetchAllStreamLoadingState();
        List<StreamResponse> _stream =
            await _dashboardRepository.fetchAllStream();
        yield FetchAllStreamSuccessState(_stream);
      } catch (e) {
        yield FetchAllStreamErrorState(
            DioExceptions.fromDioError(e as DioError).message);
      }
    }

    if (event is FetchStreamByUser) {
      try {
        yield FetchStreamByUserLoadingState();
        List<StreamResponse> stream =
            await _dashboardRepository.fetchStreamByUser(userId: event.userID);
        yield FetchStreamByUserSuccessState(stream);
      } catch (e) {
        yield FetchStreamByUserErrorState(
            DioExceptions.fromDioError(e as DioError).message);
      }
    }

    if (event is ApproveStream) {
      try {
        yield ApproveStreamLoadingState();
        MessageResponse message =
            await _dashboardRepository.approveStream(event.approveRequest);
        yield ApproveStreamSuccessState(message);
      } catch (e) {
        yield ApproveStreamErrorState(
            DioExceptions.fromDioError(e as DioError).message);
      }
    }
  }
}
