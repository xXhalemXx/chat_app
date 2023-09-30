import 'dart:io';
import 'package:chat_app/core/common_components/default_components.dart';
import 'package:chat_app/core/data_sources/cache_data.dart';
import 'package:chat_app/core/injection/injection.dart';
import 'package:chat_app/features/Home/presentation/manager/personal_info_cubit/personal_info_cubit.dart';
import 'package:chat_app/features/Home/presentation/pages/chat_page.dart';
import 'package:chat_app/features/Home/presentation/pages/settings_page.dart';
import 'package:chat_app/features/authentication/data/models/user_model.dart';
import 'package:chat_app/features/authentication/presentation/manager/auth_manager_cubit.dart';
import 'package:chat_app/features/authentication/presentation/pages/first_open.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  UserModel? currentUser;
  bool needRefresh=false;

  bool isPassword = true;

  showOrHidPasswordSettings() {
    isPassword = !isPassword;
    emit(HomeShowOrHidePassword(isPassword: isPassword));
  }

  getUserData() async {
    try {
      String? uId = await getIt<CacheData>().getString(key: 'uId');
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uId!).get();
      UserModel user =
          UserModel.fromJason(documentSnapshot.data() as Map<String, dynamic>);
      currentUser = user;
      return user;
    } catch (e) {
      defaultErrorToast(message: e.toString());
    }
  }

  logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    getIt<CacheData>().setString(key: 'uId', value: '');
    getIt.resetLazySingleton<HomeCubit>();
    getIt.resetLazySingleton<PersonalInfoCubit>();
    getIt.resetLazySingleton<AuthManagerCubit>();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<AuthManagerCubit>(),
          child: FirstOpen(),
        ),
      ),
    );
  }

  getAllUsers() async {
    try {
      List<UserModel> allUsers = [];
      CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot = await usersRef.get();
      List<QueryDocumentSnapshot> allDocs = querySnapshot.docs;
      for (var doc in allDocs) {
        if (doc.id != currentUser!.uId) {
          allUsers.add(UserModel.fromJason(doc.data() as Map<String, dynamic>));
        }
      }
      emit(HomeGetAllUsers(allUsers: allUsers));
    } on SocketException catch (_) {
      emit(
        HomeFailed(errorMessage: 'No internet connection'),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        HomeFailed(errorMessage: e.message!),
      );
    } catch (e) {
      emit(
        HomeFailed(errorMessage: e.toString()),
      );
    }
  }

  getUsersHaveChatWith() async {
    try {
      List<UserModel> allUsers = [];
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      List<QueryDocumentSnapshot> allDocs = querySnapshot.docs;
      for (var doc in allDocs) {
        Map<String, dynamic> docMap = doc.data() as Map<String, dynamic>;
        if (docMap['uId'] != currentUser!.uId) {
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(doc.id)
              .collection('chats')
              .get();
          for (var element in querySnapshot.docs) {
            if (element.id == currentUser!.uId) {
              allUsers.add(UserModel.fromJason(docMap));
              break;
            }
          }
        }
      }
      emit(HomeSuccess(allUsers: allUsers));
    } on SocketException catch (_) {
      emit(
        HomeFailed(errorMessage: 'No internet connection'),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        HomeFailed(errorMessage: e.message!),
      );
    } catch (e) {
      emit(
        HomeFailed(errorMessage: e.toString()),
      );
    }
  }

  navigateToSettings({required BuildContext context}) async {
    //getIt.resetLazySingleton<PersonalInfoCubit>();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<HomeCubit>(),
              ),
              BlocProvider(
                create: (_) => getIt<PersonalInfoCubit>(),
              ),
            ],
            child: SettingsPage(
              currentUser: currentUser!,
            )),
      ),
    );
  }

  navigateToChatPage(
      {required BuildContext context, required UserModel sender}) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => getIt<PersonalInfoCubit>(),
            ),
          ],
          child: ChatPage(
            sender: sender,
            receiver: currentUser!,
          ),
        ),
      ),
    );
  }

  checkIfWeNeedReload({required UserModel receiver}) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uId)
          .collection('chats')
          .doc(receiver.uId)
          .collection('messages')
          .get();
      if(querySnapshot.docs.length<=0){
        needRefresh =true;
      }
    } on SocketException catch (_) {
      defaultErrorToast(message: 'No internet connection');
    } on FirebaseAuthException catch (e) {
      defaultErrorToast(message: e.message!);
    } catch (e) {
      defaultErrorToast(message: e.toString());
    }
  }

  reloadMainIfNeeded(){
    if(needRefresh ==true){
      getUsersHaveChatWith();
    }
    needRefresh=false;
  }
}
