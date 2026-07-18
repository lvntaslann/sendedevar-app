import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/font_size.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../logic/cubit/prayer_time_cubit.dart';
import '../../logic/cubit/prayer_time_state.dart';
import '../../data/model/prayer_time_model.dart';
import '../page/mosque_map_page.dart';

class PrayerLocationSection extends StatelessWidget {
  final AppColors appColors;

  const PrayerLocationSection({super.key, required this.appColors});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SOL TARAF
            if (state.isLoading)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 120.w, height: 20.h, borderRadius: 6),
                  SizedBox(height: 8.h),
                  ShimmerBox(width: 90.w, height: 14.h, borderRadius: 6),
                ],
              )
            else if (state.data != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.data!.place.name,
                    style: TextStyle(
                      color: appColors.prayerPage.titleTextColor,
                      fontSize: AppFontSizes.s22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (state.data!.days.isNotEmpty)
                    Text(
                      "${state.data!.days.first.getUpcomingPrayer()} namazı",
                      style: TextStyle(
                        color: appColors.prayerPage.topTimeTextColor,
                        fontSize: AppFontSizes.s16,
                      ),
                    ),
                ],
              )
            else
              Text(
                "Namaz verisi yüklenemedi",
                style: TextStyle(color: Colors.red[300], fontSize: 12),
              ),

            // SAĞ TARAF (Harita Butonu)
            InkWell(
              onTap: () {
                if (state.isLoading) return;

                // Namaz API çökse bile, haritanın açılması için cami verilerini kontrol ediyoruz
                if (state.mosqueLat != null && state.mosqueLng != null) {
                  // Kullanıcının konumunu (Namaz API çöktüğü için state.data null olabilir, bu yüzden sabit bir konum veya 0,0 kullanıyoruz)
                  final userLat =
                      state.data?.place.lat ?? 41.0082; // Varsayılan İstanbul
                  final userLng = state.data?.place.lng ?? 28.9784;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MosqueMapPage(
                        userLat: userLat,
                        userLng: userLng,
                        mosqueLat: state.mosqueLat!,
                        mosqueLng: state.mosqueLng!,
                        mosqueName: state.mosqueName ?? "En yakın cami",
                        appColors: appColors,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Cami konumu henüz bulunamadı! API Anahtarını kontrol et.",
                      ),
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: appColors.prayerPage.titleTextColor,
                    ),
                    SizedBox(width: 5.w),
                    SizedBox(
                      width: 110.w,
                      child: Text(
                        state.mosqueName ?? "En yakın camii\nkonumu",
                        style: TextStyle(
                          color: appColors.prayerPage.titleTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: AppFontSizes.s14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
