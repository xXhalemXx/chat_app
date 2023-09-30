import 'package:chat_app/core/common_components/default_components.dart';
import 'package:chat_app/core/injection/injection.dart';
import 'package:chat_app/features/authentication/presentation/manager/auth_manager_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget loginFromSignUp(BuildContext context) {
  return Row(
    children: [
      Text('Already have an account'),
      TextButton(
          onPressed: () {
            getIt<AuthManagerCubit>().navigateToLogIn(context: context);
          },
          child: Text('Login')),
    ],
  );
}

Widget passwordFieldForSignUp(TextEditingController passwordController) {
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
        isPassword: getIt<AuthManagerCubit>().isPasswordSignUp,
        prefixIcon: Icons.lock,
        suffixIcon: getIt<AuthManagerCubit>().isPasswordSignUp
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
        onPressed: () {
          getIt<AuthManagerCubit>().showOrHidPasswordSignUp();
        });
  });
}

Widget signUpButton(
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController nameController,
    TextEditingController phoneController,
    GlobalKey<FormState> formKey,
    BuildContext context) {
  return BlocBuilder<AuthManagerCubit, AuthManagerState>(buildWhen: (c, p) {
    if (c is AuthManagerInitial ||
        c is AuthManagerError ||
        c is AuthManagerLoading) {
      return true;
    } else {
      return false;
    }
  }, builder: (_, currentState) {
    if (currentState is AuthManagerLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (currentState is AuthManagerError) {
      return Column(
        children: [
          defaultElevatedButton(
              text: 'Sign Up',
              onPressed: () async {
                await getIt<AuthManagerCubit>().signUpNewUser(
                    emailController,
                    passwordController,
                    nameController,
                    phoneController,
                    formKey,
                    context);
              }),
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
          text: 'Sign Up',
          onPressed: () async {
            await getIt<AuthManagerCubit>().signUpNewUser(
                emailController,
                passwordController,
                nameController,
                phoneController,
                formKey,
                context);
          });
    }
  });
}
