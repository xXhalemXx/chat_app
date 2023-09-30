import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/injection/injection.dart';
import 'package:chat_app/features/Home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:chat_app/features/Home/presentation/manager/personal_info_cubit/personal_info_cubit.dart';
import 'package:chat_app/features/Home/presentation/widgets/home_widgets/home_search.dart';
import 'package:chat_app/features/authentication/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

AppBar homeAppBar({required BuildContext context}) {
  return AppBar(
    title: Text('Chats'),
    leading: DrawerButton(),
    actions: [
      IconButton(
          onPressed: () {
            getIt<HomeCubit>().getAllUsers();
            showSearch(
              context: context,
              delegate: NewSearchDelegate(),
            );
          },
          icon: Icon(Icons.search)),
    ],
  );
}

Widget userChat({
  required BuildContext context,
  UserModel? user,
}) {
  return Container(
    decoration: BoxDecoration(color: Colors.transparent),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    height: MediaQuery.of(context).size.height * 0.1,
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            showPhotoDialog(context, user?.photo ?? '');
          },
          child: CircleAvatar(
            backgroundImage: user?.photo == ''
                ? AssetImage('assets/images/login_chat.png')
                : CachedNetworkImageProvider(user!.photo) as ImageProvider,
            radius: 30,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              getIt<HomeCubit>().checkIfWeNeedReload(receiver: user);
              getIt<HomeCubit>()
                  .navigateToChatPage(context: context, sender: user);
            },
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  user!.name,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Drawer homeDrawer({
  required BuildContext context,
}) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
          builder: (context, state) {
            UserModel? user = getIt<HomeCubit>().currentUser;
            return UserAccountsDrawerHeader(
              accountName: Text(user?.name ?? ''),
              accountEmail: Text(user?.email ?? ''),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  showPhotoDialog(context, user?.photo ?? '');
                },
                child: CircleAvatar(
                  backgroundImage: user?.photo == null || user?.photo == ''
                      ? AssetImage('assets/images/login_chat.png')
                      : CachedNetworkImageProvider(user!.photo)
                          as ImageProvider,
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            getIt<HomeCubit>().navigateToSettings(context: context);
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () async {
            await getIt<HomeCubit>().logout(context);
          },
        ),
      ],
    ),
  );
}

void showPhotoDialog(BuildContext context, String photoUrl) {
  Widget dialog = AlertDialog(
    content: SizedBox(
      width: MediaQuery.of(context).size.width*0.4,
      child: photoUrl == ''
          ? Image.asset('assets/images/login_chat.png')
          : CachedNetworkImage(
              imageUrl: photoUrl,
              fit: BoxFit.cover,
            ),
    ),
    contentPadding: EdgeInsets.zero,
    insetPadding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
    elevation: 0,
  );

  showDialog(
    context: context,
    builder: (context) => dialog,
  );
}
