part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class FetchAllStreamLoadingState extends DashboardState {}

class FetchAllStreamSuccessState extends DashboardState {
  final List<StreamResponse> streams;

  const FetchAllStreamSuccessState(this.streams);
}

class FetchAllStreamErrorState extends DashboardState {
  final String error;

  const FetchAllStreamErrorState(this.error);
}

class FetchStreamByUserLoadingState extends DashboardState {}

class FetchStreamByUserSuccessState extends DashboardState {
  final List<StreamResponse> streams;

  const FetchStreamByUserSuccessState(this.streams);
}

class FetchStreamByUserErrorState extends DashboardState {
  final String error;

  const FetchStreamByUserErrorState(this.error);
}

class ApproveStreamLoadingState extends DashboardState {}

class ApproveStreamSuccessState extends DashboardState {
  final MessageResponse message;

  const ApproveStreamSuccessState(this.message);
}

class ApproveStreamErrorState extends DashboardState {
  final String error;

  const ApproveStreamErrorState(this.error);
}
