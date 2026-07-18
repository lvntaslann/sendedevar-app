import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/font_size.dart';
import '../../data/model/kuran_model.dart';
import '../widgets/kuran_slide_items.dart';

class KuranPage extends StatelessWidget {
  const KuranPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(isDarkMode: false);
    final previewModel = KuranModel(
      title: "Bakara Suresi, 286",
      arabicText:
          "لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا ۚ لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ",
      turkishText:
          "Allah, hiçbir kimseyi gücünün yetmediği şeyle yükümlü kılmaz. Herkesin kazandığı iyilik kendi yararına, işlediği kötülüğün zararı da yine kendinedir.",
    );

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        children: [
          Icon(
            Icons.menu_book_outlined,
            color: appColors.hadisPage.titleTextColor,
            size: 56.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            "Kur'an-ı Kerim Yakında Burada",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: appColors.hadisPage.hadisTextColor,
              fontSize: AppFontSizes.s20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Bu bölümü senin için hazırlıyoruz. Çok yakında ayetleri\nburadan okuyabileceksin.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: appColors.hadisPage.turkishTextColor,
              fontSize: AppFontSizes.s14,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          SizedBox(height: 28.h),
          Text(
            "Önizleme",
            style: TextStyle(
              color: appColors.hadisPage.titleTextColor,
              fontSize: AppFontSizes.s14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              height: 420.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  IgnorePointer(child: KuranSlideItems(kuranModel: previewModel)),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      color: appColors.hadisPage.pageBgColor.withOpacity(0.35),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: appColors.hadisPage.contentContainerBgColor,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: appColors.hadisPage.contentContainerStrokeColor,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_clock_outlined,
                            color: appColors.hadisPage.titleTextColor,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Yakında",
                            style: TextStyle(
                              color: appColors.hadisPage.hadisTextColor,
                              fontSize: AppFontSizes.s14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
