import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/font_size.dart';

class DailyGoalSection extends StatelessWidget {
  final AppColors appColors;
  final double progress;

  const DailyGoalSection({
    required this.appColors,
    required this.progress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percent = (progress.clamp(0, 1) * 100).round();

    return Container(
      width: 347.w,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: appColors.profilePage.contentContainerBgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: appColors.profilePage.dailyStatusCompletedColor.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    color: appColors.profilePage.dailyStatusCompletedColor,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Bugünün Hedefi",
                    style: TextStyle(
                      color: appColors.profilePage.textColor,
                      fontSize: AppFontSizes.s16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                "%$percent",
                style: TextStyle(
                  color: appColors.profilePage.dailyStatusCompletedColor,
                  fontSize: AppFontSizes.s16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            height: 14.h,
            decoration: BoxDecoration(
              color: appColors.profilePage.dailyStatusNotCompletedColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  appColors.profilePage.dailyStatusCompletedColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "750/1000",
            style: TextStyle(
              color: appColors.profilePage.textColor.withOpacity(0.6),
              fontSize: AppFontSizes.s12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
