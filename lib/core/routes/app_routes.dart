import 'package:flutter/material.dart';
import 'package:sende_de_var/features/auth/presentation/pages/login_page.dart';
import 'package:sende_de_var/features/channels/presentation/pages/channel_page.dart';
import 'package:sende_de_var/features/channels/presentation/pages/duty_page.dart';
import 'package:sende_de_var/features/hadis/presentation/page/hadis_page.dart';
import 'package:sende_de_var/features/main_page_controller.dart';
import 'package:sende_de_var/features/prayer-times/presentation/page/prayer_page.dart';
import 'package:sende_de_var/features/namaz/presentation/page/namaz_page.dart';
import 'package:sende_de_var/features/qibla/presentation/page/qibla_page.dart';

import '../../features/auth/presentation/pages/signup_page.dart';
import '../utils/page_transition.dart';

class Routes {
  static const String main = "/main_page";
  static const String namaz = "/namaz";
  static const String kible = "/kible";
  static const String hadis = "/hadis";
  static const String namaz_saatleri = "/namaz_saatleri";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String channel = "/channel";
  static const String duty = "/duty";
  static final Map<String, Widget> _routes = {
    "/": const MainPageController(),
    main: const MainPageController(),
    namaz: const NamazPage(),
    kible: const QiblaPage(),
    hadis: const HadisPage(),
    namaz_saatleri: const PrayerPage(),
    login: const LoginPage(),
    signup: const SignupPage(),
    channel: const ChannelPage(),
  };
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Widget? page = _routes[settings.name];

    if (page == null) {
      return pageTransition(
        const Scaffold(body: Center(child: Text("Route not found"))),
      );
    }

    return pageTransition(page);
  }
}
