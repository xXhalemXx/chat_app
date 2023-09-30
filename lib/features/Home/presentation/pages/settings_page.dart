import 'package:chat_app/core/common_components/default_components.dart';
import 'package:chat_app/core/injection/injection.dart';
import 'package:chat_app/features/Home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:chat_app/features/Home/presentation/manager/personal_info_cubit/personal_info_cubit.dart';
import 'package:chat_app/features/Home/presentation/widgets/settings_widgets/settings_widgets.dart';
import 'package:chat_app/features/authentication/data/models/user_model.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key, required this.currentUser}) : super(key: key);
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        getIt.resetLazySingleton<HomeCubit>();
        getIt.resetLazySingleton<PersonalInfoCubit>();
        await getIt<HomeCubit>().getUserData();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: null,
          title: Text('Settings'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                addVerticalSpace(10),
                userProfilePic(currentUser: currentUser, context: context),
                addVerticalSpace(10),
                defaultTextFiled(
                  textEditingController: nameController,
                  labelText: 'New Name',
                  validator: (value) {
                    return getIt<PersonalInfoCubit>().nameValidator(value);
                  },
                  isPassword: false,
                  prefixIcon: Icons.person,
                ),
                addVerticalSpace(7),
                defaultTextFiled(
                  textEditingController: phoneController,
                  labelText: 'New Phone',
                  validator: (value) {
                    return null;
                  },
                  isPassword: false,
                  prefixIcon: Icons.phone,
                ),
                addVerticalSpace(12),
                settingsButton(
                    nameController, phoneController, formKey, currentUser),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
