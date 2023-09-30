part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}
class HomeSuccess extends HomeState {
  List<UserModel> allUsers;
  HomeSuccess({required this.allUsers});
}
class HomeGetAllUsers extends HomeState {
  List<UserModel> allUsers;
  HomeGetAllUsers({required this.allUsers});
}
class HomeFailed extends HomeState {
  String errorMessage;
  HomeFailed({required this.errorMessage});
}
class HomeShowOrHidePassword extends HomeState {
  bool isPassword;
  HomeShowOrHidePassword({required this.isPassword});
}
