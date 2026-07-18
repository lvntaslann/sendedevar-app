import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/font_size.dart';
import 'qibla_dial_painter.dart';
import 'qibla_needle_painter.dart';

class QiblaCompassView extends StatelessWidget {
  final AppColors appColors;
  final QiblahDirection data;

  const QiblaCompassView({super.key, required this.appColors, required this.data});

  @override
  Widget build(BuildContext context) {
    final isAligned = _angleDiff(data.qiblah, 0) < 3;

    return SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Text(
                isAligned ? "Kıble Yönünü Buldun 🎉" : "Telefonu Kıbleye Doğru Çevir",
                style: TextStyle(
                  color: isAligned ? appColors.qiblaPage.accentColor : appColors.qiblaPage.textColor,
                  fontSize: AppFontSizes.s18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "Telefonu düz tutup yavaşça çevir, ok Kâbe'yi gösterecek",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appColors.qiblaPage.mutedTextColor,
                  fontSize: AppFontSizes.s14,
                ),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: 300.w,
                height: 300.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appColors.qiblaPage.cardBgColor,
                        boxShadow: [
                          BoxShadow(
                            color: appColors.qiblaPage.accentColor.withOpacity(isAligned ? 0.4 : 0.15),
                            blurRadius: isAligned ? 30 : 16,
                            spreadRadius: isAligned ? 4 : 1,
                          ),
                        ],
                        border: Border.all(
                          color: appColors.qiblaPage.dialStrokeColor.withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: (data.direction * (pi / 180) * -1),
                      child: CustomPaint(
                        size: Size(300.w, 300.w),
                        painter: QiblaDialPainter(
                          tickColor: appColors.qiblaPage.mutedTextColor.withOpacity(0.6),
                          majorTickColor: appColors.qiblaPage.mutedTextColor,
                          northColor: appColors.qiblaPage.accentColor,
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: (data.qiblah * (pi / 180) * -1),
                      child: CustomPaint(
                        size: Size(300.w, 300.w),
                        painter: QiblaNeedlePainter(
                          needleColor: isAligned ? appColors.qiblaPage.accentColor : appColors.qiblaPage.needleColor,
                          tailColor: appColors.qiblaPage.mutedTextColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Container(
                      width: 54.w,
                      height: 54.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10.w),
                      child: Image.asset(
                        "assets/logo/sunnet-app-logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: appColors.qiblaPage.cardBgColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: appColors.qiblaPage.dialStrokeColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.explore_outlined, color: appColors.qiblaPage.accentColor, size: 18.sp),
                    SizedBox(width: 8.w),
                    Text(
                      "Kâbe'ye açı: ${data.qiblah.toStringAsFixed(0)}°",
                      style: TextStyle(
                        color: appColors.qiblaPage.textColor,
                        fontSize: AppFontSizes.s14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }

  double _angleDiff(double angle, double target) {
    final diff = (angle - target).abs() % 360;
    return diff > 180 ? 360 - diff : diff;
  }
}
