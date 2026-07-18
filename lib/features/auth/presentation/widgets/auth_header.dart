import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/font_size.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.appColors,
    required this.subtitle,
  });

  final AppColors appColors;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260.h,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: -70.h,
            left: -60.w,
            child: _blob(160.r, appColors.authPage.containerColor.withOpacity(0.35)),
          ),
          Positioned(
            top: -30.h,
            right: -70.w,
            child: _blob(180.r, const Color(0xFF22C55E).withOpacity(0.25)),
          ),
          Positioned(
            top: 90.h,
            child: _blob(220.r, appColors.authPage.containerColor.withOpacity(0.12)),
          ),

          Padding(
            padding: EdgeInsets.only(top: 48.h),
            child: Column(
              children: [
                Container(
                  width: 108.w,
                  height: 108.w,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: appColors.authPage.containerShadowColor.withOpacity(0.25),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    "assets/logo/sunnet-app-logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  "Sende De Var",
                  style: TextStyle(
                    color: appColors.authPage.textColor,
                    fontSize: AppFontSizes.s30,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: appColors.authPage.textColor.withOpacity(0.7),
                    fontSize: AppFontSizes.s14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
