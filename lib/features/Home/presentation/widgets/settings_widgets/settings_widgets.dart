import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/common_components/default_components.dart';
import 'package:chat_app/core/injection/injection.dart';
import 'package:chat_app/features/Home/presentation/manager/personal_info_cubit/personal_info_cubit.dart';
import 'package:chat_app/features/authentication/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget userProfilePic({UserModel? currentUser, required BuildContext context}) {
  return CircleAvatar(
    radius: MediaQuery.of(context).size.width * 0.25,
    child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Stack(
        children: [
          BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
            buildWhen: (p,c){
              if(c is PersonalInfoSuccess ||c is PersonalInfoInitial ||c is PersonalInfoLoading){
                return true;
              }else{
                return false;
              }
            },
            builder: (context, state) {

              if(state is PersonalInfoLoading){
                return Align(
                  alignment: AlignmentDirectional.center,
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.25,
                    backgroundImage: AssetImage('assets/images/loading.gif'),
                  )
                );
              }else if(state is PersonalInfoSuccess){
                return Align(
                  alignment: AlignmentDirectional.center,
                  child: state.newUrl == null || state.newUrl == ''
                      ? Image.asset('assets/images/login_chat.png')
                      : CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.25,
                    backgroundImage: CachedNetworkImageProvider(state.newUrl!),
                  ),
                );
              }else{
                return Align(
                  alignment: AlignmentDirectional.center,
                  child: currentUser?.photo == null || currentUser?.photo == ''
                      ? Image.asset('assets/images/login_chat.png')
                      : CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.25,
                    backgroundImage:
                    CachedNetworkImageProvider(currentUser!.photo),
                  ),
                );
              }

            },
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(photoOptions(currentUser));
              },
              child: Icon(Icons.camera_enhance),
              mini: true,
            ),
          ),
        ],
      ),
    ),
  );
}

SnackBar photoOptions(UserModel? currentUser) {
  return SnackBar(
    duration: Duration(seconds: 3),
    backgroundColor: Colors.white70,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    content: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: defaultElevatedButton(text: 'Update', onPressed: () {
                getIt<PersonalInfoCubit>().updateUserPhoto();
              })),
          SizedBox(
            width: 5,
          ),
          Expanded(
              child: defaultElevatedButton(text: 'Remove', onPressed: () {
                getIt<PersonalInfoCubit>().deleteProfilePic(currentUser!.uId);
              })),

        ],
      ),
    ),
  );
}


Widget settingsButton(
    TextEditingController? nameController,
    TextEditingController? phoneController,
    GlobalKey<FormState> formKey,
    UserModel? currentUser
    ){
  return BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
    builder: (context, state) {
      if (state is PersonalInfoLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return defaultElevatedButton(
            text: 'Update',
            onPressed: () {
              getIt<PersonalInfoCubit>().updateUserInfo(
                  nameController,
                  phoneController,
                  formKey,);
            });
      }
    },
  );
}
