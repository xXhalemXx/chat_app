part of 'auth_manager_cubit.dart';

abstract class AuthManagerState {}

class AuthManagerInitial extends AuthManagerState {}
class AuthManagerLoading extends AuthManagerState {}
class AuthManagerError extends AuthManagerState {
  String error;
  AuthManagerError({required this.error});
}

class ShowOrHidPassword extends AuthManagerState {
  bool isPassword;
  ShowOrHidPassword({required this.isPassword});
}
