import 'package:sende_de_var/core/themes/abdest/abdest_page_colors.dart';
import 'package:sende_de_var/core/themes/auth/auth_page_colors.dart';
import 'package:sende_de_var/core/themes/channels/channels_page_colors.dart';
import 'package:sende_de_var/core/themes/hadis/hadis_page_colors.dart';
import 'package:sende_de_var/core/themes/home/home_colors.dart';
import 'package:sende_de_var/core/themes/prayer/prayer_page_colors.dart';
import 'package:sende_de_var/core/themes/profile/profile_page_colors.dart';
import 'package:sende_de_var/core/themes/qibla/qibla_page_colors.dart';

class AppColors {

  final HomeColors home;
  final AbdestPageColors abdestPage;
  final HadisPageColors hadisPage;
  final PrayerPageColors prayerPage;
  final ProfilePageColors profilePage;
  final AuthPageColors authPage;
  final ChannelsPageColors channelsPage;
  final QiblaPageColors qiblaPage;
  AppColors({required bool isDarkMode})
    : home = HomeColors(isDarkMode: isDarkMode),
      abdestPage = AbdestPageColors(isDarkMode: isDarkMode),
      hadisPage  = HadisPageColors(isDarkMode: isDarkMode),
      prayerPage = PrayerPageColors(isDarkMode: isDarkMode),
      profilePage = ProfilePageColors(isDarkMode: isDarkMode),
      authPage = AuthPageColors(isDarkMode: isDarkMode),
      channelsPage = ChannelsPageColors(isDarkMode: isDarkMode),
      qiblaPage = QiblaPageColors(isDarkMode: isDarkMode);

}