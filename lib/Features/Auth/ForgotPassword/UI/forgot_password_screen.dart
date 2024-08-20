import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_auth_bloc/Components/entry_field.dart';
import 'package:flutter_auth_bloc/Components/my_button.dart';
import 'package:flutter_auth_bloc/Features/Auth/ForgotPassword/cubit/forgot_password_cubit.dart';
import 'package:flutter_auth_bloc/Global/Style/colors.dart';
import 'package:flutter_auth_bloc/Helpers/dialog_helper.dart';
import 'package:flutter_auth_bloc/Helpers/loading_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validators/form_validators.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPasswordCubit>(
      create: (context) =>
          ForgotPasswordCubit(authRepository: context.read<AuthRepository>()),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
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
              DialogHelper.showCustomAlert(
                context: context,
                title: 'Reset Link Sent',
                content: 'Please check your email to reset password.',
                dismissible: false,
                popDialogOnBtn1Pressed: true,
                onBtnPressed: () {
                  Navigator.of(context).pop();
                },
              );
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
                    'Enter your email to send reset link..',
                    style: TextStyle(
                      color: kMainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
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
                        context.read<ForgotPasswordCubit>().emailChanged(email),
                    errorText: state.email.invalid
                        ? Email.showEmailErrorMessage(state.email.error)
                        : null,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Center(
                    child: MyButton(
                      width: 50.w,
                      text: 'Send Reset Link',
                      onPressed: () {
                        //! Navigation is done by status listener..
                        state.status.isValidated
                            ? context
                                .read<ForgotPasswordCubit>()
                                .forgotPassword()
                            : DialogHelper.showCustomAlert(
                                context: context,
                                title: 'Email not set',
                                content:
                                    'Please make sure to set the email correctly.',
                              );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      '<< Back to sign in',
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
