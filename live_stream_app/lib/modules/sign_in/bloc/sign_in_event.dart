part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInSubmitted extends SignInEvent {
  final String username;
  final String password;

  SignInSubmitted({
    required this.username,
    required this.password,
  });
}

class SignOutSubmitted extends SignInEvent {
  final int userID;

  const SignOutSubmitted({required this.userID});
}
