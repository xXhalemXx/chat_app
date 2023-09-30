import 'package:chat_app/features/Home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:chat_app/features/Home/presentation/widgets/home_widgets/home_failed_widget.dart';
import 'package:chat_app/features/Home/presentation/widgets/home_widgets/home_success_widget.dart';
import 'package:chat_app/features/Home/presentation/widgets/home_widgets/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:
          homeDrawer(context: context,),
      appBar: homeAppBar(context: context),
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (p, c) {
          if (c is HomeSuccess || c is HomeFailed || c is HomeInitial) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          if (state is HomeSuccess) {
            return HomeSuccessWidget(allUsers: state.allUsers);
          } else if (state is HomeFailed) {
            return HomeFailedWidget(errorMessage: state.errorMessage);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
