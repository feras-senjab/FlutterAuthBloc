import 'package:flutter_auth_bloc/Components/my_button.dart';
import 'package:flutter_auth_bloc/Features/Auth/Login/UI/login_screen.dart';
import 'package:flutter_auth_bloc/Features/Auth/Logout/cubit/logout_cubit.dart';
import 'package:flutter_auth_bloc/Features/Logic/UserModel/cubit/user_model_cubit.dart';
import 'package:flutter_auth_bloc/Global/enums.dart';
import 'package:flutter_auth_bloc/Helpers/dialog_helper.dart';
import 'package:flutter_auth_bloc/Helpers/loading_helper.dart';
import 'package:flutter_auth_bloc/Helpers/nav_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 5.h,
            ),
            Text(
              'Welcome ${context.read<UserModelCubit>().state.userModel!.name}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: BlocConsumer<LogoutCubit, LogoutState>(
                listenWhen: (previous, current) =>
                    previous.status != current.status,
                listener: (context, state) {
                  if (state.status == StateStatus.loading) {
                    LoadingHelper.showLoading();
                  } else {
                    LoadingHelper.dismissLoading();
                    if (state.status == StateStatus.failure) {
                      DialogHelper.showCustomAlert(
                        context: context,
                        title: 'Error',
                        content: 'Logout Failed!',
                      );
                    } else if (state.status == StateStatus.success) {
                      NavHelper.pushAndRemoveUntil(
                          context, const LoginScreen());
                    }
                  }
                },
                builder: (context, state) {
                  return MyButton(
                    text: 'Sign out',
                    width: 30.w,
                    onPressed: () {
                      context.read<LogoutCubit>().logout();
                      //! Navigation is done by listener.
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
