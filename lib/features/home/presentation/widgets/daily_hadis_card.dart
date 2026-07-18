import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/font_size.dart';

class DailyHadisCard extends StatelessWidget {
  const DailyHadisCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(isDarkMode: false);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: appColors.home.contentContainerBgColor,
          border: Border.all(
            color: appColors.home.contentContainerStrokeColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Günün Hadisi",
                    style: TextStyle(
                      color: appColors.home.titleTextColor,
                      fontSize: AppFontSizes.s20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      "“إِنَّمَا الأَعْمَالُ بِالنِّيَّةِ، وَإِنَّمَا لاِمْرِئٍ مَا نَوَى، فَمَنْ كَانَتْ هِجْرَتُهُ إِلَى اللَّهِ وَرَسُولِهِ، فَهِجْرَتُهُ إِلَى اللَّهِ وَرَسُولِهِ، وَمَنْ كَانَتْ هِجْرَتُهُ لِدُنْيَا يُصِيبُهَا أَوِ امْرَأَةٍ يَتَزَوَّجُهَا، فَهِجْرَتُهُ إِلَى مَا هَاجَرَ إِلَيْهِ.”",
                      style: TextStyle(
                        color: appColors.home.textColor,
                        fontSize: AppFontSizes.s16,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "“Ameller niyete göredir. Herkes sadece niyetinin karşılığını alır. Kim Allah ve Resûlü için hicret ederse, hicreti Allah ve Resûlü’nedir. Kim de erişeceği bir dünyalık veya evleneceği bir kadından dolayı hicret ederse, onun hicreti de hicretine sebep olan şeyedir.”",
                    style: TextStyle(
                      color: appColors.home.contentTurkishTextColor,
                      fontSize: AppFontSizes.s14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: appColors.home.contentDetailBgColor,
                border: Border(
                  top: BorderSide(
                    color: appColors.home.contentContainerStrokeColor,
                    width: 2,
                  ),
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(13),
                  bottomRight: Radius.circular(13),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Buhârî, Bedü vahy, 1",
                      style: TextStyle(
                        color: appColors.home.contentTurkishTextColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () => _showComingSoon(context),
                    child: Icon(
                      Icons.favorite,
                      color: appColors.home.contentIconColor,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () => _showComingSoon(context),
                    child: Icon(
                      Icons.share,
                      color: appColors.home.contentIconColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bu özellik yakında eklenecek")),
    );
  }
}
