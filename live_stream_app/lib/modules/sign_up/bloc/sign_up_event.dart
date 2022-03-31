part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpSubmitted extends SignUpEvent {
  final SignUpRequest signUpRequest;

  const SignUpSubmitted({required this.signUpRequest});
}

class UploadImage extends SignUpEvent {
  final File imageFile;

  const UploadImage({required this.imageFile});
}
