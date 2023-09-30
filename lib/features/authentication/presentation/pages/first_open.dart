import 'package:chat_app/core/common_components/default_components.dart';
import 'package:chat_app/core/injection/injection.dart';
import 'package:chat_app/features/authentication/presentation/manager/auth_manager_cubit.dart';
import 'package:chat_app/features/authentication/presentation/widgets/first_open_widgets/first_open_widgets.dart';
import 'package:flutter/material.dart';

class FirstOpen extends StatelessWidget {
  const FirstOpen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: SizedBox()),
              Expanded(
                  flex: 5, child: Image.asset('assets/images/first_page.png')),
              Expanded(
                  flex: 1,
                  child: Text(
                    'Hello',
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: Colors.grey[600]),
                  )),
              Expanded(
                flex: 1,
                child: Text(
                  'Welcome in chat app where you can communicate with your friends',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.grey[500]),
                ),
              ),
              addVerticalSpace(10),
              Expanded(
                flex: 1,
                child: defaultElevatedButton(
                    text: 'Login',
                    onPressed: () {
                      getIt<AuthManagerCubit>()
                          .navigateToLogIn(context: context);
                    }),
              ),
              addVerticalSpace(10),
              Expanded(
                flex: 1,
                child: defaultOutlinedButton(
                  text: 'Sign Up',
                  onPressed: () {
                    getIt<AuthManagerCubit>()
                        .navigateToSignUp(context: context);
                  },
                ),
              ),
              addVerticalSpace(10),
              Text(
                'Sign In using',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.grey[500]),
              ),
              Expanded(flex: 1, child: signInIcons(context: context)),
              const Expanded(flex: 3, child: SizedBox())
            ],
          ),
        ),
      ),
    );
  }
}
