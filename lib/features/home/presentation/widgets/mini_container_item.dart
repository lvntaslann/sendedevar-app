import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/font_size.dart';
import '../../data/model/mini_container_model.dart';

class MiniContainerItem extends StatelessWidget {
  final MiniContainerDetail item;
  final AppColors appColors;

  const MiniContainerItem({
    Key? key,
    required this.item,
    required this.appColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Container(
        width: 110.w,
        height: 104.h,
        decoration: BoxDecoration(
          color: appColors.home.miniContainerBgColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: appColors.home.miniContainerStrokeColor,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              item.iconPath,
              width: 42.w,
              height: 42.h,
              filterQuality: FilterQuality.high,
            ),
            Text(
              item.title,
              style: TextStyle(
                color: appColors.home.textColor,
                fontSize: AppFontSizes.s12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
