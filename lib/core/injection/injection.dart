import 'package:chat_app/core/data_sources/cache_data.dart';
import 'package:chat_app/features/Home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:chat_app/features/Home/presentation/manager/personal_info_cubit/personal_info_cubit.dart';
import 'package:chat_app/features/authentication/presentation/manager/auth_manager_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<CacheData>(() => CacheData());
  getIt.registerLazySingleton<AuthManagerCubit>(() => AuthManagerCubit());
  getIt.registerLazySingleton<HomeCubit>(() => HomeCubit());
  getIt.registerLazySingleton<PersonalInfoCubit>(() => PersonalInfoCubit());

}
