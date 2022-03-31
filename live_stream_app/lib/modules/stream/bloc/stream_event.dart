part of 'stream_bloc.dart';

abstract class StreamEvent extends Equatable {
  const StreamEvent();

  @override
  List<Object?> get props => [];
}

class UploadStream extends StreamEvent {
  final StreamRequest streamRequest;

  const UploadStream({required this.streamRequest});
}
