import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app/core/common_components/default_components.dart';
import 'package:chat_app/core/data_sources/cache_data.dart';
import 'package:chat_app/core/injection/injection.dart';
import 'package:chat_app/features/Home/data/remote/models/message_model.dart';
import 'package:chat_app/features/Home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:chat_app/features/authentication/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

part 'personal_info_state.dart';

class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  PersonalInfoCubit() : super(PersonalInfoInitial());

  Future<PlatformFile?> pickUserPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['JPG', 'JPEG ', 'PNG '],
      allowMultiple: false,
      type: FileType.custom,
    );
    if (result == null) {
      return null;
    } else {
      return result.files.first;
    }
  }

  updateUserPhoto() async {
    try {
      final uId = await getIt<CacheData>().getString(key: 'uId');
      UploadTask? uploadTask;
      PlatformFile? image = await pickUserPhoto();
      if (image != null) {
        emit(PersonalInfoLoading());
        final path = 'users Photos/$uId';
        final file = File(image.path!);
        final ref = FirebaseStorage.instance.ref().child(path);
        uploadTask = ref.putFile(file);
        final snapshot = await uploadTask.whenComplete(() => null);
        final downloadUrl = await snapshot.ref.getDownloadURL();
        // update database for this user
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .update({'photo': downloadUrl});

        emit(PersonalInfoSuccess(newUrl: downloadUrl));
        await getIt<HomeCubit>().getUserData();
      }
    } on SocketException catch (_) {
      defaultErrorToast(message: 'No internet connection');
    } on FirebaseAuthException catch (e) {
      defaultErrorToast(message: e.message!);
    } catch (e) {
      defaultErrorToast(message: e.toString());
    }
  }

  deleteProfilePic(String? photoName) async {
    if (photoName == null || photoName == '') {
      return;
    }
    try {
      emit(PersonalInfoLoading());
      final storageRef = FirebaseStorage.instance.ref();

      final desertRef = storageRef.child("users Photos/$photoName");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(photoName)
          .update({'photo': ''});
      await desertRef.delete();
      emit(PersonalInfoSuccess(newUrl: ''));
      await getIt<HomeCubit>().getUserData();
    } on SocketException catch (_) {
      emit(PersonalInfoInitial());
      defaultErrorToast(message: 'No internet connection');
    } on FirebaseAuthException catch (e) {
      emit(PersonalInfoInitial());
      defaultErrorToast(message: e.message!);
    } catch (e) {
      emit(PersonalInfoInitial());
      defaultErrorToast(message: e.toString());
    }
  }


  updateUserInfo(
    TextEditingController? nameController,
    TextEditingController? phoneController,
    GlobalKey<FormState> formKey,
  ) async {
    UserModel? oldUser = await getIt<HomeCubit>().getUserData();
    try {
      if (formKey.currentState!.validate()) {
        emit(PersonalInfoLoading());
        String? newName = nameController?.value.text;
        String? newPhone = phoneController?.value.text;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(oldUser!.uId)
            .update({
          'name': newName == '' || newName == null ? oldUser.name : newName,
          'phone':
              newPhone == '' || newPhone == null ? oldUser.phone : newPhone,
        });
        getIt<HomeCubit>().getUserData();
        emit(PersonalInfoSuccess(
            newName: newName == '' || newName == null ? oldUser.name : newName,
            newPhone:
                newPhone == '' || newPhone == null ? oldUser.phone : newPhone,
            newUrl: oldUser.photo));
        defaultSuccessToast(message: 'Updated Successfully');
        nameController?.clear();
        phoneController?.clear();
      }
    } on SocketException catch (_) {
      emit(PersonalInfoInitial());
      defaultErrorToast(message: 'No internet connection');
    } on FirebaseAuthException catch (e) {
      emit(PersonalInfoInitial());
      defaultErrorToast(message: e.message!);
    } catch (e) {
      emit(PersonalInfoInitial());
      defaultErrorToast(message: e.toString());
    }
  }

  String? nameValidator(String? value) {
    final validCharacters = RegExp(r'[a-zA-Z0-9._]');
    if (value == null || value.isEmpty || value == '') {
      return null;
    } else if (!validCharacters.hasMatch(value)) {
      return 'Enter valid name';
    }
    return null;
  }


  void sendMessage(
      {required UserModel sender,
      required UserModel receiver,
      required TextEditingController messageController,
     }) async{
    if(messageController.value.text==''){
      return;
    }
    try {
      MessageModel message = MessageModel(
          sender: sender.uId,
          text: messageController.value.text,
          dateTime: DateTime.now().toString(),
          receiver: receiver.uId);

      FirebaseFirestore.instance
          .collection('users')
          .doc(sender.uId)
          .collection('chats')
          .doc(receiver.uId)
          .collection('messages')
          .add(message.toMap());

      FirebaseFirestore.instance
          .collection('users')
          .doc(receiver.uId)
          .collection('chats')
          .doc(sender.uId)
          .collection('messages')
          .add(message.toMap());
      messageController.clear();

      FirebaseFirestore.instance
          .collection('users')
          .doc(sender.uId)
          .collection('chats')
          .doc(receiver.uId).set({'exists':''});

      FirebaseFirestore.instance
          .collection('users')
          .doc(receiver.uId)
          .collection('chats')
          .doc(sender.uId).set({'exists':''});

    } on SocketException catch (_) {
      defaultErrorToast(message: 'No internet connection');
    } on FirebaseAuthException catch (e) {
      defaultErrorToast(message: e.message!);
    } catch (e) {
      defaultErrorToast(message: e.toString());
    }
  }

  void getAllMessages({
    required UserModel sender,
    required UserModel receiver,
    required ScrollController scrollController
  }) {
    try {
      List<MessageModel> allMessages = [];
      FirebaseFirestore.instance
          .collection('users')
          .doc(sender.uId)
          .collection('chats')
          .doc(receiver.uId)
          .collection('messages')
          .orderBy('dateTime')
          .snapshots()
          .listen((event) {
        allMessages = [];
        event.docs.forEach((element) {
          allMessages
              .add(MessageModel.fromJason(element.data()));
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
        emit(MessagesDelivered(allMessages: allMessages));
      });

    } on SocketException catch (_) {
      defaultErrorToast(message: 'No internet connection');
    } on FirebaseAuthException catch (e) {
      defaultErrorToast(message: e.message!);
    } catch (e) {
      defaultErrorToast(message: e.toString());
    }
  }
}
