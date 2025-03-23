part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LoadingAuth extends AuthState {}

final class SuccessAuth extends AuthState {}

final class ErrorAuth extends AuthState {
  final String errorMessage;
  ErrorAuth({required this.errorMessage});
}
