import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sende_de_var/core/themes/app_colors.dart';
import 'package:sende_de_var/core/utils/font_size.dart';

class CustomContentWidget extends StatelessWidget {
  final AppColors appColors;
  final String imagePath;
  final double imageWidth;
  final double imageHeight;
  final String title;

  const CustomContentWidget({
    Key? key,
    required this.appColors,
    required this.imagePath,
    required this.imageWidth,
    required this.imageHeight,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 362.w,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.abdestPage.contentContainerBgColor.withOpacity(0.4),
        border: Border.all(
          color: appColors.abdestPage.contentContainerStrokeColor,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.w,
            height: 191.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAF9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: imageWidth,
                height: imageHeight,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: appColors.abdestPage.textColor,
              fontSize: AppFontSizes.s14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
