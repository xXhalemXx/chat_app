import 'package:chat_app/core/injection/injection.dart';
import 'package:chat_app/features/Home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:chat_app/features/Home/presentation/manager/personal_info_cubit/personal_info_cubit.dart';
import 'package:chat_app/features/Home/presentation/widgets/chat_widgets/chat_widgets.dart';
import 'package:chat_app/features/authentication/data/models/user_model.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key, required this.receiver, required this.sender})
      : super(key: key);

  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();
  final UserModel receiver;
  final UserModel sender;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        getIt.resetLazySingleton<PersonalInfoCubit>();
        getIt<HomeCubit>().reloadMainIfNeeded();
        return true;
      },
      child: Scaffold(
        appBar: chatAppBar(photo: sender.photo, name: sender.name),
        body: Column(
          children: [
            chatView(
                scrollController: scrollController,
                sender: sender,
                receiver: receiver),
            Divider(height: 1),
            messageSender(
              scrollController: scrollController,
              messageController: messageController,
              sender: sender,
              receiver: receiver,
            ),
          ],
        ),
      ),
    );
  }
}


