import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart'; // GERÇEK KONUM İÇİN EKLENDİ
import 'package:sunnet_app/core/themes/app_colors.dart';
import 'package:sunnet_app/core/widgets/custom_app_bar.dart';

import '../../logic/cubit/prayer_time_cubit.dart';
import '../widgets/prayer_clock_section.dart';
import '../widgets/prayer_location_section.dart';
import '../widgets/prayer_time_section.dart';
import '../widgets/weather_section.dart';

class PrayerPage extends StatefulWidget {
  const PrayerPage({Key? key}) : super(key: key);

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  @override
  void initState() {
    super.initState();

    // Sayfa açılır açılmaz gerçek konumu almak için fonksiyonu çağırıyoruz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDataWithRealLocation();
    });
  }

  // GERÇEK KONUMU ALAN VE API'Yİ TETİKLEYEN YENİ FONKSİYON
  Future<void> _fetchDataWithRealLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Konum servisleri açık mı kontrol et
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("Konum servisleri kapalı.");
      return;
    }

    // 2. Uygulama için konum izni var mı kontrol et
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("Konum izni reddedildi.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("Konum izni kalıcı olarak reddedildi.");
      return;
    }

    // 3. İzinler tamamsa anlık konumu al
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 4. Gerçek koordinatlarla Cubit'teki API'yi tetikle
    if (mounted) {
      context.read<PrayerTimeCubit>().getPrayerTimes(
        lat: position.latitude,
        lng: position.longitude,
        date: DateTime.now().toIso8601String().split("T").first,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(isDarkMode: false);
    final now = DateTime.now().toLocal();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: appColors.prayerPage.pageBgColor,
      appBar: CustomAppBar(title: "Namaz saatleri", showBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.h),

            // Lokasyon + En yakın cami
            PrayerLocationSection(appColors: appColors),

            SizedBox(height: 20.h),

            // Saat
            PrayerClockSection(
              hour: hour,
              minute: minute,
              appColors: appColors,
            ),

            SizedBox(height: 20.h),

            // Hava durumu
            WeatherSection(appColors: appColors),

            SizedBox(height: 20.h),

            // Namaz vakitleri
            PrayerTimesSection(appColors: appColors),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
