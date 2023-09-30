import 'package:auto_size_text/auto_size_text.dart';
import 'package:chat_app/core/common_components/default_components.dart';
import 'package:chat_app/core/styling/colors.dart';
import 'package:flutter/material.dart';

class HomeFailedWidget extends StatelessWidget {
  final String errorMessage;

  HomeFailedWidget({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          addVerticalSpace(MediaQuery.of(context).size.height * 0.15),
          const Icon(
            Icons.error,
            size: 200,
            color: Colors.redAccent,
          ),
          addVerticalSpace(10),
          AutoSizeText(
            errorMessage,
            textAlign: TextAlign.center,
            maxLines: 4,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.redAccent),
          ),
          addVerticalSpace(20),
          defaultElevatedButton(
              text: 'try again',
              onPressed: () {},
              width: MediaQuery.of(context).size.width*0.5,
              backgroundColor: primaryLightColor,
              textColor: Colors.black54),
        ],
      ),
    );
  }
}
