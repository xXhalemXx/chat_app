import 'package:chat_app/core/common_components/default_components.dart';
import 'package:chat_app/core/injection/injection.dart';
import 'package:chat_app/features/authentication/presentation/manager/auth_manager_cubit.dart';
import 'package:chat_app/features/authentication/presentation/widgets/login_widgets/login_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        getIt.resetLazySingleton<AuthManagerCubit>();
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    addVerticalSpace(MediaQuery.of(context).size.height * 0.06),
                    Image.asset(
                      'assets/images/login_chat.png',
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                    addVerticalSpace(30),
                    defaultTextFiled(
                        textEditingController: emailController,
                        labelText: "Email",
                        validator: (value) {
                          return getIt<AuthManagerCubit>()
                              .emailValidator(value);
                        },
                        isPassword: false,
                        prefixIcon: Icons.email),
                    addVerticalSpace(10),
                    passwordFieldForLogin(passwordController),
                    addVerticalSpace(10),
                    BlocBuilder<AuthManagerCubit, AuthManagerState>(
                        builder: (_, currentState) {
                      if (currentState is AuthManagerLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (currentState is AuthManagerError) {
                        return Column(
                          children: [
                            defaultElevatedButton(
                                text: 'Login',
                                onPressed: () {
                                  getIt<AuthManagerCubit>().signInUsingEmail(
                                      emailController,
                                      passwordController,
                                      formKey,
                                      context);
                                },
                                width:
                                    MediaQuery.of(context).size.width * 0.95),
                            Text(
                              currentState.error,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return defaultElevatedButton(
                            text: 'Login',
                            onPressed: () {
                              getIt<AuthManagerCubit>().signInUsingEmail(
                                  emailController,
                                  passwordController,
                                  formKey,
                                  context);
                            },
                            width: MediaQuery.of(context).size.width * 0.95);
                      }
                    }),
                    addVerticalSpace(10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
