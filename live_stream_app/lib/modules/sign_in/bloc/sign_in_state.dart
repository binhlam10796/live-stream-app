part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoadingState extends SignInState {}

class SignInSuccessState extends SignInState {}

class SignInErrorState extends SignInState {
  final String error;

  const SignInErrorState(this.error);
}

class SignOutLoadingState extends SignInState {}

class SignOutSuccessState extends SignInState {}

class SignOutErrorState extends SignInState {
  final String error;

  const SignOutErrorState(this.error);
}
