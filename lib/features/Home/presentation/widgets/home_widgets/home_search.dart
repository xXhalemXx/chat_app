import 'package:chat_app/core/injection/injection.dart';
import 'package:chat_app/features/Home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:chat_app/features/Home/presentation/widgets/home_widgets/home_widgets.dart';
import 'package:chat_app/features/authentication/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewSearchDelegate extends SearchDelegate {
  List<UserModel> suggestions = [];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocProvider.value(
      value: getIt<HomeCubit>(),
      child: BlocBuilder<HomeCubit, HomeState>(buildWhen: (p, c) {
        if (c is HomeInitial || c is HomeGetAllUsers) {
          return true;
        } else {
          return false;
        }
      }, builder: (context, state) {
        if (state is HomeInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeGetAllUsers) {
          suggestions = [];
          if (query.isNotEmpty) {
            for (var user in state.allUsers) {
              String userName = user.name.toLowerCase();
              String searchValue = query.toLowerCase();
              if (userName.contains(searchValue)) {
                suggestions.add(user);
              }
            }
          }
          return suggestions.isNotEmpty
              ? Container(
            alignment: Alignment.centerLeft,
            child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return userChat(
                    context: context,
                    user: suggestions[index],
                  );
                }),
          )
              : const Center(
            child: Text(
              'No Users To Show',
              style: TextStyle(fontSize: 20, color: Colors.blueGrey),
            ),
          );
        } else {
          return Container();
        }
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocProvider.value(
      value: getIt<HomeCubit>(),
      child: BlocBuilder<HomeCubit, HomeState>(buildWhen: (p, c) {
        if (c is HomeInitial || c is HomeGetAllUsers) {
          return true;
        } else {
          return false;
        }
      }, builder: (context, state) {
        if (state is HomeInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeGetAllUsers) {
          suggestions = [];
          if (query.isNotEmpty) {
            for (var user in state.allUsers) {
              String userName = user.name.toLowerCase();
              String searchValue = query.toLowerCase();
              if (userName.contains(searchValue)) {
                suggestions.add(user);
              }
            }
          }
          return suggestions.isNotEmpty
              ? Container(
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                      itemCount: suggestions.length,
                      itemBuilder: (context, index) {
                        return userChat(
                          context: context,
                          user: suggestions[index],
                        );
                      }),
                )
              : const Center(
                  child: Text(
                    'No Users To Show',
                    style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                  ),
                );
        } else {
          return Container();
        }
      }),
    );
  }



}
