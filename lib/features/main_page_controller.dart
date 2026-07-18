import 'package:flutter/material.dart';
import 'package:sende_de_var/core/themes/app_colors.dart';
import 'package:sende_de_var/core/widgets/custom_app_bar.dart';
import 'package:sende_de_var/features/channels/presentation/pages/channel_page.dart';
import 'package:sende_de_var/features/hadis/presentation/page/hadis_page.dart';
import 'package:sende_de_var/features/home/presentation/page/home_page.dart';
import 'package:sende_de_var/features/kuran/presentation/pages/kuran_page.dart';
import 'package:sende_de_var/features/profile/presentation/page/profile_page.dart';
import '../core/widgets/custom_bottom_nav_bar.dart';

class MainPageController extends StatefulWidget {
  const MainPageController({Key? key}) : super(key: key);

  @override
  _MainPageControllerState createState() => _MainPageControllerState();
}

class _MainPageControllerState extends State<MainPageController> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    HadisPage(),
    KuranPage(),
    ChannelPage(),
    ProfilePage(),
  ];

  final List<String> pageTitles = [
    "Anasayfa",
    "Hadisler",
    "Kuran",
    "Kanallar",
    "Profil",
  ];

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(isDarkMode: false);

    return Scaffold(
      appBar: CustomAppBar(
        title: pageTitles[currentIndex],
        showBackButton: false,
      ),
      backgroundColor: appColors.home.pageBgColor,
      body: Column(
        children: [
          Expanded(
            child: pages[currentIndex],
          ),
          CustomBottomNavBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
