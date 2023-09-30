import 'package:chat_app/core/data_sources/cache_data.dart';
import 'package:chat_app/core/injection/injection.dart';
import 'package:chat_app/core/styling/app_theme.dart';
import 'package:chat_app/features/Home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:chat_app/features/Home/presentation/manager/personal_info_cubit/personal_info_cubit.dart';
import 'package:chat_app/features/Home/presentation/pages/home_page.dart';
import 'package:chat_app/features/authentication/presentation/manager/auth_manager_cubit.dart';
import 'package:chat_app/features/authentication/presentation/pages/first_open.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupGetIt();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      home: appRouter(),
    );
  }

  appRouter() {
    return FutureBuilder(
        future: checkUser(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            FlutterNativeSplash.remove();
            if (snapshot.data!) {
              return MultiBlocProvider(providers: [
                BlocProvider(create: (_) => getIt<HomeCubit>(),),
                BlocProvider(create: (_) => getIt<PersonalInfoCubit>(),),
              ], child:HomePage() );
            } else {
              return MultiBlocProvider(providers: [
                BlocProvider(create: (_) => getIt<AuthManagerCubit>()),
                BlocProvider(create: (_) => getIt<PersonalInfoCubit>()),
                BlocProvider(create: (_) => getIt<HomeCubit>()),
              ], child: FirstOpen());
            }
          } else
            return SizedBox();
        });
  }

  Future<bool> checkUser() async {
    try {
      String? uId = await getIt<CacheData>().getString(key: 'uId');
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null  && uId != null && uId != '') {
        await getIt<HomeCubit>().getUserData();
        getIt<HomeCubit>().getUsersHaveChatWith();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
