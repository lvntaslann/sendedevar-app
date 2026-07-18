import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sende_de_var/core/utils/font_size.dart';
import '../../../../../core/themes/app_colors.dart';

class SwitchItemButtonRight extends StatelessWidget {
  const SwitchItemButtonRight({
    super.key,
    required this.appColors,
    required this.isActive,
    required this.title,
    required this.onTap,
  });

  final AppColors appColors;
  final String title;
  final bool isActive;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 163.w,
        height: 45.h,
        decoration: BoxDecoration(
          color: isActive
              ? appColors.channelsPage.switchPanelActiveColor
              : appColors.channelsPage.switchPanelPassiveColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(22.r),
            bottomRight: Radius.circular(22.r),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive
                  ? appColors.channelsPage.textColor
                  : appColors.channelsPage.switchPanelPassiveTextColor,
              fontSize: AppFontSizes.s16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}