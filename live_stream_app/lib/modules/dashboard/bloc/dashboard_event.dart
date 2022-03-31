part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllStream extends DashboardEvent {}

class FetchStreamByUser extends DashboardEvent {
  final int userID;

  const FetchStreamByUser({required this.userID});
}

class ApproveStream extends DashboardEvent {
  final ApproveRequest approveRequest;

  const ApproveStream({required this.approveRequest});
}
