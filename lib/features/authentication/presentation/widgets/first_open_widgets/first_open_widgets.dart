import 'package:chat_app/core/injection/injection.dart';
import 'package:chat_app/features/authentication/presentation/manager/auth_manager_cubit.dart';
import 'package:flutter/material.dart';

Row signInIcons({required BuildContext context}) {
  const snackBar = SnackBar(
    content: Text(
      'Not available now 😢',
    ),
    duration: Duration(seconds: 1),
  );
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        icon: CircleAvatar(
          radius: 25,
          child: Image.asset('assets/images/icons/facebook.png'),
        ),
      ),
      IconButton(
        onPressed: () async {
          getIt<AuthManagerCubit>().signInWithGoogle(context: context);
        },
        icon: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.transparent,
          child: Image.asset('assets/images/icons/google.png'),
        ),
      ),
      IconButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        icon: CircleAvatar(
          radius: 25,
          child: Image.asset('assets/images/icons/linkedin.png'),
        ),
      ),
    ],
  );
}




