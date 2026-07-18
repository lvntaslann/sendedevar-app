import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/font_size.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../data/model/prayer_time_model.dart';
import '../../logic/cubit/prayer_time_cubit.dart';
import '../../logic/cubit/prayer_time_state.dart';

class PrayerTimesSection extends StatelessWidget {
  final AppColors appColors;
  const PrayerTimesSection({super.key, required this.appColors});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              6,
              (_) => ShimmerBox(width: 145.w, height: 82.h, borderRadius: 20),
            ),
          );
        } else if (state.data != null) {
          PrayerDay today = state.data!.days.first;
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (int i = 0; i < today.times.length; i++)
                _buildPrayerTimeBox(today, i),
            ],
          );
        } else if (state.error != null) {
          return Text("Hata: ${state.error}");
        } else {
          return const Text("Namaz vakitleri bulunamadı");
        }
      },
    );
  }

  Widget _buildPrayerTimeBox(PrayerDay today, int i) {
    return Container(
      width: 145.w,
      height: 82.h,
      decoration: BoxDecoration(
        color: appColors.prayerPage.prayerTimeContainerColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: appColors.prayerPage.prayerTimeContainerStrokeColor,
          width: 3,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ["İmsak", "Güneş", "Öğle", "İkindi", "Akşam", "Yatsı"][i],
            style: TextStyle(
              color: appColors.prayerPage.prayerTitleTextColor,
              fontSize: AppFontSizes.s18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            today.times[i],
            style: TextStyle(
              color: appColors.prayerPage.prayerTimeTextColor,
              fontSize: AppFontSizes.s20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}