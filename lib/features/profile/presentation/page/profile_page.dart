import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sende_de_var/core/routes/app_routes.dart'; // Yönlendirme için eklendi
import 'package:sende_de_var/core/themes/app_colors.dart';
import '../../../auth/logic/cubit/user_cubit.dart';
import '../../../user_duties/logic/cubit/user_duty_cubit.dart';
import '../../../user_duties/presentation/widgets/user_duties_section.dart';
import '../widgets/daily_goal_section.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_settings_section.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Sadece giriş yapmışsa görevleri çek
    final isAuth = context.read<UserCubit>().state.isAuthenticated;
    if (isAuth) {
      context.read<UserDutyCubit>().loadUserDuties();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(isDarkMode: false);
    final authState = context.watch<UserCubit>().state;
    final isAuth = authState.isAuthenticated;

    // Eğer giriş yapmadıysa misafir ekranını döndür
    if (!isAuth) {
      return _buildGuestView(context, appColors);
    }

    // Giriş yaptıysa normal profili göster
    final user = authState.user;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 12.h),
          ProfileHeader(appColors: appColors, user: user!),
          SizedBox(height: 25.h),
          DailyGoalSection(appColors: appColors, progress: 0.5),
          SizedBox(height: 20.h),
          UserDutiesSection(appColors: appColors),
          SizedBox(height: 28.h),
          ProfileSettingsSection(appColors: appColors, user: user, isAdmin: authState.isAdmin),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  // GİRİŞ YAPMAMIŞ KULLANICI İÇİN GÖSTERİLECEK EKRAN
  Widget _buildGuestView(BuildContext context, AppColors appColors) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60.h),
            Container(
              width: 110.w,
              height: 110.w,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF22C55E).withOpacity(0.25),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Image.asset(
                "assets/logo/sunnet-app-logo.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 28.h),
            Text(
              "Profiline Hoş Geldin",
              style: TextStyle(
                color: appColors.profilePage.textColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "Profilini görüntülemek, günlük hedeflerini ve\ngörevlerini takip etmek için giriş yap.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appColors.profilePage.textColor.withOpacity(0.7),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
            SizedBox(height: 32.h),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, Routes.login),
              child: Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF58A47A), Color(0xFF22C55E)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF22C55E).withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Giriş Yap / Üye Ol",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
