part of 'stream_bloc.dart';

abstract class StreamState extends Equatable {
  const StreamState();

  @override
  List<Object> get props => [];
}

class StreamInitial extends StreamState {}

class UploadStreamLoadingState extends StreamState {}

class UploadStreamSuccessState extends StreamState {
  final MessageResponse message;

  const UploadStreamSuccessState(this.message);
}

class UploadStreamErrorState extends StreamState {
  final String error;

  const UploadStreamErrorState(this.error);
}
