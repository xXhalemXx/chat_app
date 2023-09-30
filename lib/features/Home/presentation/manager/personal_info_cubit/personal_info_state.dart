part of 'personal_info_cubit.dart';

abstract class PersonalInfoState {}

class PersonalInfoInitial extends PersonalInfoState {}

class PersonalInfoLoading extends PersonalInfoState {}

class PersonalInfoSuccess extends PersonalInfoState {
  String? newUrl;
  String? newName;
  String? newPhone;

  PersonalInfoSuccess({this.newUrl, this.newName, this.newPhone});
}

class PersonalInfoFailed extends PersonalInfoState {}

class MessagesDelivered extends PersonalInfoState {
  List<MessageModel> allMessages;

  MessagesDelivered({required this.allMessages});
}
