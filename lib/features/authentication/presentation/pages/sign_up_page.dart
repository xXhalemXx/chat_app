import 'package:chat_app/core/common_components/default_components.dart';
import 'package:chat_app/core/injection/injection.dart';
import 'package:chat_app/features/authentication/presentation/manager/auth_manager_cubit.dart';
import 'package:chat_app/features/authentication/presentation/widgets/sign_up_widgets/sign_up_widgets.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        getIt.resetLazySingleton<AuthManagerCubit>();
        return true;
      },
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                addVerticalSpace(MediaQuery.of(context).size.height * 0.05),
                Image.asset(
                  'assets/images/sign_up.png',
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                defaultTextFiled(
                  textEditingController: nameController,
                  labelText: 'Name',
                  validator: (value) {
                    return getIt<AuthManagerCubit>().nameValidator(value);
                  },
                  isPassword: false,
                  prefixIcon: Icons.person,
                ),
                addVerticalSpace(10),
                defaultTextFiled(
                    textEditingController: emailController,
                    labelText: 'Email',
                    validator: (value) {
                      return getIt<AuthManagerCubit>().emailValidator(value);
                    },
                    isPassword: false,
                    prefixIcon: Icons.email),
                addVerticalSpace(10),
                defaultTextFiled(
                  textEditingController: phoneController,
                  labelText: 'Phone(optional)',
                  validator: (value) {
                    return null;
                  },
                  isPassword: false,
                  prefixIcon: Icons.phone,
                ),
                addVerticalSpace(10),
                passwordFieldForSignUp(passwordController),
                addVerticalSpace(10),
                signUpButton(emailController, passwordController,
                    nameController, phoneController, formKey, context),
                addVerticalSpace(10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
