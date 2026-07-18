import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/font_size.dart';

class QiblaStatusView extends StatelessWidget {
  final AppColors appColors;
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const QiblaStatusView({
    super.key,
    required this.appColors,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88.w,
              height: 88.w,
              decoration: BoxDecoration(
                color: appColors.qiblaPage.cardBgColor,
                shape: BoxShape.circle,
                border: Border.all(color: appColors.qiblaPage.dialStrokeColor.withOpacity(0.4)),
              ),
              child: Icon(icon, color: appColors.qiblaPage.accentColor, size: 38.sp),
            ),
            SizedBox(height: 20.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appColors.qiblaPage.textColor,
                fontSize: AppFontSizes.s18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appColors.qiblaPage.mutedTextColor,
                fontSize: AppFontSizes.s14,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
            if (actionLabel != null) ...[
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: onAction,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [appColors.qiblaPage.dialStrokeColor, appColors.qiblaPage.accentColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    actionLabel!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppFontSizes.s14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
