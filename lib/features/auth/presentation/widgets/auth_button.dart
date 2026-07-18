import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/font_size.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.appColors,
    required this.buttonText,
    required this.onTap,
  });

  final AppColors appColors;
  final String buttonText;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            width: 320.w,
            height: 58.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [appColors.authPage.containerColor, const Color(0xFF22C55E)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: appColors.authPage.containerShadowColor.withOpacity(
                    0.25,
                  ),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: appColors.authPage.textColor,
                  fontSize: AppFontSizes.s16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}