part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoadingState extends SignUpState {}

class SignUpSuccessState extends SignUpState {}

class SignUpErrorState extends SignUpState {
  final String error;

  const SignUpErrorState(this.error);
}

class UploadImageLoadingState extends SignUpState {}

class UploadImageSuccessState extends SignUpState {
  final String fileID;

  const UploadImageSuccessState(this.fileID);
}

class UploadImageErrorState extends SignUpState {
  final String error;

  const UploadImageErrorState(this.error);
}
