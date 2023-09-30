import 'package:chat_app/features/Home/presentation/widgets/home_widgets/home_widgets.dart';
import 'package:chat_app/features/authentication/data/models/user_model.dart';
import 'package:flutter/material.dart';

class HomeSuccessWidget extends StatelessWidget {
  final List<UserModel> allUsers;

  HomeSuccessWidget({Key? key, required this.allUsers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: ListView.builder(
          itemCount: allUsers.length,
          itemBuilder: (context, index) {
            return userChat(
              context: context,
              user: allUsers[index],
            );
          }),
    );
  }
}
