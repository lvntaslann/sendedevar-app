import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sunnet_app/core/routes/app_routes.dart'; // Yönlendirme için eklendi
import 'package:sunnet_app/core/themes/app_colors.dart';
import '../../../auth/logic/cubit/user_cubit.dart';
import '../../../user_duties/logic/cubit/user_duty_cubit.dart';
import '../../../user_duties/presentation/widgets/user_duties_section.dart';
import '../widgets/daily_goal_section.dart';
import '../widgets/profile_header.dart';

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
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // GİRİŞ YAPMAMIŞ KULLANICI İÇİN GÖSTERİLECEK EKRAN
  Widget _buildGuestView(BuildContext context, AppColors appColors) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 150.h, left: 20.w, right: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 90.sp,
              color: Colors.white54,
            ),
            SizedBox(height: 20.h),
            Text(
              "Profilinizi görüntülemek ve\ngörevlerinizi takip etmek için\ngiriş yapmalısınız.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 30.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF287D3C,
                  ), // Temandaki yeşil butona uygun
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.login);
                },
                child: Text(
                  "Giriş Yap / Üye Ol",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
