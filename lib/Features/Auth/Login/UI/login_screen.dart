import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_auth_bloc/Components/entry_field.dart';
import 'package:flutter_auth_bloc/Components/my_button.dart';
import 'package:flutter_auth_bloc/Features/Auth/Login/cubit/login_cubit.dart';
import 'package:flutter_auth_bloc/Features/Auth/SignUp/UI/signup_screen.dart';
import 'package:flutter_auth_bloc/Features/Auth/bloc/auth_bloc.dart';
import 'package:flutter_auth_bloc/Features/AppGate/UI/app_gate.dart';
import 'package:flutter_auth_bloc/Global/Style/colors.dart';
import 'package:flutter_auth_bloc/Helpers/dialog_helper.dart';
import 'package:flutter_auth_bloc/Helpers/loading_helper.dart';
import 'package:flutter_auth_bloc/Helpers/nav_helper.dart';
import 'package:firebase_repository/firebase_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validators/form_validators.dart';
import 'package:sizer/sizer.dart';

import '../../ForgotPassword/UI/forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(
        authBloc: context.read<AuthBloc>(),
        authRepository: context.read<AuthRepository>(),
        userRepository: context.read<FirebaseUsersRepository>(),
      ),
      child: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == FormzStatus.submissionInProgress) {
            LoadingHelper.showLoading();
          } else {
            LoadingHelper.dismissLoading();
            if (state.status == FormzStatus.submissionFailure) {
              DialogHelper.showCustomAlert(
                context: context,
                title: 'Error',
                content: state.errorMessage ?? 'Something Wrong!',
              );
            } else if (state.status == FormzStatus.submissionSuccess) {
              NavHelper.pushAndRemoveUntil(context, const AppGate());
            }
          }
        },
        builder: (context, state) {
          //-------------- Style Values -----------------//
          final inputBorder = OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(3.sp),
            ),
            borderSide: const BorderSide(
              color: Color(0xFFE5E5E5),
              width: 1,
            ),
          );

          final focusedBorder = inputBorder.copyWith(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 255, 221, 0),
              width: 1,
            ),
          );
          //---------------- Scaffold --------------------//
          return Scaffold(
            body: SafeArea(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                ),
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'WELCOME TO APP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kMainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 19.sp,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  EntryField(
                    label: 'Email',
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    inputBorder: inputBorder,
                    focusedBorder: focusedBorder,
                    onChanged: (email) =>
                        context.read<LoginCubit>().emailChanged(email),
                    errorText: state.email.invalid
                        ? Email.showEmailErrorMessage(state.email.error)
                        : null,
                  ),
                  EntryField(
                    label: 'Password',
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    inputBorder: inputBorder,
                    focusedBorder: focusedBorder,
                    onChanged: (password) =>
                        context.read<LoginCubit>().passwordChanged(password),
                    errorText: state.password.invalid
                        ? Password.showPasswordErrorMessage(
                            state.password.error)
                        : null,
                  ),
                  Row(
                    children: [
                      const Text('Forgot your password? '),
                      InkWell(
                        onTap: () {
                          NavHelper.push(context, const ForgotPasswordScreen());
                        },
                        child: const Text(
                          'Click here',
                          style: TextStyle(
                            color: kMainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    children: [
                      const Text('Don\'t have an account? '),
                      InkWell(
                        onTap: () {
                          NavHelper.push(context, const SignupScreen());
                        },
                        child: const Text(
                          'Register Now!',
                          style: TextStyle(
                            color: kMainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Center(
                    child: MyButton(
                      width: 50.w,
                      text: 'Sign in',
                      onPressed: () {
                        //! Navigation is done by listener..
                        state.status.isValidated
                            ? context
                                .read<LoginCubit>()
                                .signInWithEmailAndPassword()
                            : DialogHelper.showCustomAlert(
                                context: context,
                                title: 'Form not completed!',
                                content:
                                    'Please make sure to fill the form fields correctly.',
                              );
                      },
                    ),
                  ),
                  Center(
                    child: MyButton(
                      width: 50.w,
                      text: 'Google sign in',
                      onPressed: () {
                        //! Navigation is done by listener..
                        context.read<LoginCubit>().signInWithGoogle();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
