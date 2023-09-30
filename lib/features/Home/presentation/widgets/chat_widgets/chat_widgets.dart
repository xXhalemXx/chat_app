import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/injection/injection.dart';
import 'package:chat_app/core/styling/colors.dart';
import 'package:chat_app/features/Home/presentation/manager/personal_info_cubit/personal_info_cubit.dart';
import 'package:chat_app/features/authentication/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

double radiusValue = 15;

Widget receivedMessage(String message) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radiusValue),
          topRight: Radius.circular(radiusValue),
          bottomRight: Radius.circular(radiusValue),
        ),
      ),
      child: Text(message),
    ),
  );
}

Widget sendedMessage(String message) {
  return Align(
    alignment: Alignment.centerRight,
    child: Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: primaryLightColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radiusValue),
          topRight: Radius.circular(radiusValue),
          bottomLeft: Radius.circular(radiusValue),
        ),
      ),
      child: Text(message),
    ),
  );
}

Widget messageSender(
    {required TextEditingController messageController,
    required ScrollController scrollController,
    required UserModel sender,
    required UserModel receiver}) {
  return Container(
    height: 56,
    child: Row(
      children: [
        // A flexible widget to expand the input field
        Flexible(
          child: TextField(
            controller:
                messageController, // Use the controller for the text field
            decoration: InputDecoration(hintText: 'Type a message...'),
          ),
        ),

        // A button to send the message
        IconButton(
          icon: Icon(Icons.send), // Use an icon for the send button
          onPressed: () {
            getIt<PersonalInfoCubit>().sendMessage(
                sender: sender,
                receiver: receiver,
                messageController: messageController);
          }, // Call the _sendMessage method when pressed
        ),
      ],
    ),
  );
}

Widget chatView({
  required ScrollController scrollController,
  required UserModel sender,
  required UserModel receiver,
}) {
  return Builder(
    builder: (BuildContext context) {
      getIt<PersonalInfoCubit>()
          .getAllMessages(sender: sender, receiver: receiver,scrollController: scrollController,);
      return BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
        buildWhen: (p, c) {
          if (c is PersonalInfoInitial || c is MessagesDelivered) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          if (state is MessagesDelivered) {
            return Flexible(
              child: ListView.builder(
                itemCount: state.allMessages.length,
                controller: scrollController,
                itemBuilder: (context, index) {
                  if (state.allMessages[index].sender == sender.uId) {
                    return sendedMessage(state.allMessages[index].text);
                  } else {
                    return receivedMessage(state.allMessages[index].text);
                  }
                },
              ),
            );
          } else {
            return Container(
              height: MediaQuery.of(context).size.height*0.8,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      );
    },
  );
}

AppBar chatAppBar({String? photo, required String name}) {
  return AppBar(
    titleSpacing: 0.0,
    leadingWidth: 36,
    title: Row(
      children: [
        CircleAvatar(
          backgroundImage: photo == null || photo == ''
              ? AssetImage('assets/images/login_chat.png')
              : CachedNetworkImageProvider(photo) as ImageProvider,
        ),
        Text(' $name'),
      ],
    ),
    // Show the user photo in a circle avatar
  );
}
