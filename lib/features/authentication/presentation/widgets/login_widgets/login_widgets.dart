import 'package:chat_app/core/common_components/default_components.dart';
import 'package:chat_app/core/injection/injection.dart';
import 'package:chat_app/features/authentication/presentation/manager/auth_manager_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget signUpText(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('Don\'t have an account'),
      TextButton(onPressed: () {}, child: const Text('Register now?')),
    ],
  );
}

Widget passwordFieldForLogin(TextEditingController passwordController) {
  return BlocBuilder<AuthManagerCubit, AuthManagerState>(
      buildWhen: (previous, current) {
    if (current is ShowOrHidPassword) {
      return true;
    } else {
      return false;
    }
  }, builder: (_, currentState) {
    return defaultTextFiled(
        textEditingController: passwordController,
        labelText: 'Password',
        validator: (value) {
          return getIt<AuthManagerCubit>().passwordValidator(value);
        },
        isPassword: getIt<AuthManagerCubit>().isPasswordLogin,
        prefixIcon: Icons.lock,
        suffixIcon: getIt<AuthManagerCubit>().isPasswordLogin
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
        onPressed: () {
          getIt<AuthManagerCubit>().showOrHidPasswordLogin();
        });
  });
}

loginButton(
    TextEditingController emailController,
    TextEditingController passwordController,
    GlobalKey<FormState> formKey,
    BuildContext context) {
  return BlocBuilder<AuthManagerCubit, AuthManagerState>(
    buildWhen: (c,p){
      if(c is AuthManagerInitial||c is AuthManagerError||c is AuthManagerLoading){
        return true;
      }else{
        return false;
      }
    },
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
                    emailController, passwordController, formKey, context);
              },
              width: MediaQuery.of(context).size.width * 0.95),
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
                emailController, passwordController, formKey, context);
          },
          width: MediaQuery.of(context).size.width * 0.95);
    }
  });
}
