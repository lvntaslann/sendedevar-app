import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/font_size.dart';

class QiblaLoadingCompass extends StatelessWidget {
  final AppColors appColors;
  final String title;
  final String message;

  const QiblaLoadingCompass({
    super.key,
    required this.appColors,
    this.title = "Hazırlanıyor",
    this.message = "Konum ve pusula verisi alınıyor,\nbu birkaç saniye sürebilir",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: appColors.qiblaPage.accentColor,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            title,
            style: TextStyle(
              color: appColors.qiblaPage.textColor,
              fontSize: AppFontSizes.s16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: appColors.qiblaPage.mutedTextColor,
              fontSize: AppFontSizes.custom(13),
            ),
          ),
          SizedBox(height: 22.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: appColors.qiblaPage.cardBgColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: appColors.qiblaPage.dialStrokeColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.screen_rotation_alt_outlined,
                  color: appColors.qiblaPage.accentColor,
                  size: 20.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    "Daha doğru bir sonuç için telefonunu yere paralel, düz bir şekilde tut",
                    style: TextStyle(
                      color: appColors.qiblaPage.textColor.withOpacity(0.85),
                      fontSize: AppFontSizes.custom(12),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
