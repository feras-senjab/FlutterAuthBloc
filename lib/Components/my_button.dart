import 'package:flutter_auth_bloc/Global/Style/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  /// Setting fitContentWidth to true makes width takes no effect.
  final bool fitContentWidth;
  final double? width;
  final double? height;

  const MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fitContentWidth = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    //
    final btn = SizedBox(
      width: fitContentWidth ? null : width,
      height: height,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          backgroundColor: kMainColor,
          foregroundColor: Colors.black,
          textStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text(text),
      ),
    );
    //
    return width == null && !fitContentWidth
        ? btn
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              btn,
            ],
          );
  }
}
