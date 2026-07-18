import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/font_size.dart';
import '../../../auth/data/model/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final AppColors appColors;
  final UserModel user;

  const ProfileHeader({required this.appColors, required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 104.w,
          height: 104.w,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF58A47A), Color(0xFF22C55E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF22C55E).withOpacity(0.35),
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: appColors.profilePage.profileContainerBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(child: Image.asset("assets/profile/profile_icon.png")),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          user.name,
          style: TextStyle(
            color: appColors.profilePage.textColor,
            fontSize: AppFontSizes.s18,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: appColors.profilePage.levelTextColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, color: appColors.profilePage.levelTextColor, size: 16.sp),
              SizedBox(width: 6.w),
              Text(
                "Seviye 3 · 1200 puan",
                style: TextStyle(
                  color: appColors.profilePage.levelTextColor,
                  fontSize: AppFontSizes.s14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}