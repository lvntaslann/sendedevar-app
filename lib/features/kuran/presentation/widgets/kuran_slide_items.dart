import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sende_de_var/features/kuran/presentation/widgets/kuran_slide_actions.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/font_size.dart';
import '../../data/model/kuran_model.dart';


class KuranSlideItems extends StatelessWidget {
  final KuranModel kuranModel;

  const KuranSlideItems({Key? key, required this.kuranModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(isDarkMode: false);

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: appColors.hadisPage.contentContainerBgColor,
            border: Border.all(
              color: appColors.hadisPage.contentContainerStrokeColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  kuranModel.title,
                  style: TextStyle(
                    color: appColors.hadisPage.titleTextColor,
                    fontSize: AppFontSizes.s16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Text(
                    kuranModel.arabicText,
                    style: TextStyle(
                      color: appColors.hadisPage.hadisTextColor,
                      fontSize: AppFontSizes.s16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Text(
                  kuranModel.turkishText,
                  style: TextStyle(
                    color: appColors.hadisPage.turkishTextColor,
                    fontSize: AppFontSizes.s14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        const KuranSlideActions(),
      ],
    );
  }
}

