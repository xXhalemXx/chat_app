import 'dart:io';
import 'package:chat_app/core/common_components/default_components.dart';
import 'package:chat_app/core/data_sources/cache_data.dart';
import 'package:chat_app/core/injection/injection.dart';
import 'package:chat_app/features/Home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:chat_app/features/Home/presentation/manager/personal_info_cubit/personal_info_cubit.dart';
import 'package:chat_app/features/Home/presentation/pages/home_page.dart';
import 'package:chat_app/features/authentication/data/models/user_model.dart';
import 'package:chat_app/features/authentication/presentation/pages/login_page.dart';
import 'package:chat_app/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_manager_state.dart';

class AuthManagerCubit extends Cubit<AuthManagerState> {
  AuthManagerCubit() : super(AuthManagerInitial());
  bool isPasswordLogin = true;
  bool isPasswordSignUp = true;

  showOrHidPasswordLogin() {
    isPasswordLogin = !isPasswordLogin;
    emit(ShowOrHidPassword(isPassword: isPasswordLogin));
  }

  showOrHidPasswordSignUp() {
    isPasswordSignUp = !isPasswordSignUp;
    emit(ShowOrHidPassword(isPassword: isPasswordSignUp));
  }

  signInWithGoogle({required BuildContext context}) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid ?? '')
          .get();
      if (!documentSnapshot.exists) {
        await saveUserInFireStore(
            name: user?.displayName.toString() ?? '',
            phone: user?.phoneNumber ?? '',
            email: gUser.email,
            uId: user?.uid ?? '');
      }
      await getIt<CacheData>().setString(key: 'uId', value: user?.uid);
      await getIt<HomeCubit>().getUserData();
      getIt<HomeCubit>().getUsersHaveChatWith();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(providers: [
              BlocProvider(
                create: (_) => getIt<HomeCubit>(),
              ),
              BlocProvider(
                create: (_) => getIt<PersonalInfoCubit>(),
              ),
            ], child: HomePage()),
          ),
          (route) => false);
    } on FirebaseException catch (e) {
      defaultErrorToast(message: e.message!);
    } on SocketException catch (e) {
      defaultErrorToast(message: e.message);
    } on PlatformException catch (_) {
      defaultErrorToast(message: 'Check your connection');
    } catch (e) {
      defaultErrorToast(message: e.toString());
    }
  }

  signInUsingEmail(
      TextEditingController emailController,
      TextEditingController passwordController,
      GlobalKey<FormState> formKey,
      BuildContext context) async {
    if (formKey.currentState!.validate()) {
      emit(AuthManagerLoading());
      try {
        UserCredential credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.value.text,
                password: passwordController.value.text);
        await getIt<CacheData>()
            .setString(key: 'uId', value: credential.user?.uid ?? '');
        emit(AuthManagerInitial());
        await getIt.resetLazySingleton<AuthManagerCubit>();
        await getIt<HomeCubit>().getUserData();
        getIt<HomeCubit>().getUsersHaveChatWith();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(providers: [
              BlocProvider(
                create: (_) => getIt<HomeCubit>(),
              ),
              BlocProvider(
                create: (_) => getIt<PersonalInfoCubit>(),
              ),
            ], child: HomePage()),
          ),
          (route) => false,
        );
      } on SocketException catch (_) {
        emit(AuthManagerError(error: 'No internet connection'));
      } on FirebaseAuthException catch (e) {
        emit(AuthManagerError(error: e.message!));
      } catch (e) {
        emit(AuthManagerError(error: e.toString()));
      }
    }
  }

  signUpNewUser(
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController nameController,
      TextEditingController phoneController,
      GlobalKey<FormState> formKey,
      BuildContext context) async {
    if (formKey.currentState!.validate()) {
      emit(AuthManagerLoading());
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.value.text,
                password: passwordController.value.text);
        defaultSuccessToast(message: 'Successfully registered');
        await saveUserInFireStore(
            name: nameController.text,
            phone: phoneController.text,
            email: emailController.text,
            uId: userCredential.user!.uid);
        emit(AuthManagerInitial());
        getIt.resetLazySingleton<AuthManagerCubit>();
        Navigator.pop(context);
        navigateToLogIn(context: context);
      } on SocketException catch (_) {
        emit(AuthManagerError(error: 'No internet connection'));
      } on FirebaseAuthException catch (e) {
        emit(AuthManagerError(error: e.message!));
      } catch (e) {
        emit(AuthManagerError(error: e.toString()));
      }
    }
  }

  saveUserInFireStore({
    required String name,
    required String phone,
    required String email,
    required String uId,
  }) async {
    UserModel userModel =
        UserModel(email: email, phone: phone, name: name, uId: uId, photo: '');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap());
  }

  String? emailValidator(String? value) {
    final validCharacters = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value == null || value.isEmpty || value == '') {
      return 'You need to fill this field';
    } else if (!validCharacters.hasMatch(value)) {
      return 'Enter valid email address';
    }
    return null;
  }

  String? nameValidator(String? value) {
    final validCharacters = RegExp(r'[a-zA-Z0-9._]');
    if (value == null || value.isEmpty || value == '') {
      return 'You need to fill this field';
    } else if (!validCharacters.hasMatch(value)) {
      return 'Enter valid name';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty || value == '') {
      return 'You need to fill this field';
    } else if (value.length < 6) {
      return 'Too short password';
    }
    return null;
  }

  navigateToSignUp({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<AuthManagerCubit>(
          create: (_) => getIt<AuthManagerCubit>(),
          child: SignUpPage(),
        ),
      ),
    );
  }

  navigateToLogIn({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => getIt<AuthManagerCubit>(),
            ),
            BlocProvider(
              create: (_) => getIt<HomeCubit>(),
            ),
          ],
          child: LoginPage(),
        ),
      ),
    );
  }
}
