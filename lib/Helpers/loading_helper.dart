import 'package:flutter_auth_bloc/Global/Style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';

class LoadingHelper {
  static showLoading() {
    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
      indicator: Column(
        children: [
          const CircularProgressIndicator(
            color: kMainColor,
          ),
          SizedBox(height: 3.h),
          const Text(
            'Loading...',
            style: TextStyle(
              color: kMainColor,
            ),
          )
        ],
      ),
    );
  }

  static dismissLoading() {
    EasyLoading.dismiss();
  }
}
