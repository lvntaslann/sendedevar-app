import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sende_de_var/core/utils/font_size.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.h,
      decoration: BoxDecoration(
        color: const Color(0xFF0F2016),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, 'assets/bottom_nav_bar/mosque-active.png', 'assets/bottom_nav_bar/mosque-passive.png', "Anasayfa"),
            _buildNavItem(1, 'assets/bottom_nav_bar/hadis-active.png', 'assets/bottom_nav_bar/hadis-passive.png', "Hadis"),
            _buildNavItem(2, 'assets/bottom_nav_bar/kuran-active.png', 'assets/bottom_nav_bar/kuran-passive.png', "Kur'an"),
            _buildNavItem(3, 'assets/bottom_nav_bar/kuran-active.png', 'assets/bottom_nav_bar/kuran-passive.png', "Kanallar"),
            _buildNavItem(4, 'assets/bottom_nav_bar/profile-active.png', 'assets/bottom_nav_bar/profile-passive.png', "Profil"),
          ],
        ),
      ),
    );
  }

Widget _buildNavItem(int index, String activeIcon, String inactiveIcon, String label) {
  bool isActive = index == currentIndex;

  return GestureDetector(
    onTap: () => onTap(index),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          isActive ? activeIcon : inactiveIcon,
          width: 23.w,
          height: 23.h,
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: AppFontSizes.custom(11),
            color: isActive ? const Color(0xFF1C8241) : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

}
