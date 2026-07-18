import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sende_de_var/core/routes/app_routes.dart';
import 'package:sende_de_var/features/auth/data/services/user_services.dart';
import 'package:sende_de_var/features/auth/logic/cubit/user_cubit.dart';
import 'package:sende_de_var/features/auth/presentation/pages/login_page.dart';
import 'package:sende_de_var/features/channels/data/services/duty_services.dart';
import 'package:sende_de_var/features/channels/logic/cubit/channel_cubit.dart';
import 'package:sende_de_var/features/channels/logic/cubit/duty_cubit.dart';
import 'package:sende_de_var/features/kuran/data/services/kuran_services.dart';
import 'package:sende_de_var/features/kuran/logic/cubit/kuran_cubit.dart';
import 'package:sende_de_var/features/prayer-times/data/services/prayer_time_services.dart';
import 'package:sende_de_var/features/prayer-times/data/services/weather_services.dart';
import 'package:sende_de_var/features/prayer-times/logic/cubit/prayer_time_cubit.dart';
import 'package:sende_de_var/features/prayer-times/logic/cubit/weather_cubit.dart';
import 'core/utils/fetch_time_util.dart';
import 'features/channels/data/services/channel_services.dart';
import 'firebase_options.dart';
import 'features/user_duties/logic/cubit/user_duty_cubit.dart';
import 'features/user_duties/data/services/user_duty_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("firebase başlatıldı");
  await dotenv.load(fileName: ".env");
  runApp(
    ScreenUtilInit(
      splitScreenMode: true,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<WeatherCubit>(
              create: (_) => WeatherCubit(
                WeatherService(
                  apiKey: dotenv.env['WEATHER_API_KEY'] ?? "",
                  baseUrl: dotenv.env['WEATHER_API_URL'] ?? "",
                ),
              ),
            ),
            BlocProvider<PrayerTimeCubit>(
              create: (_) => PrayerTimeCubit(
                PrayerTimeService(
                  baseUrl: dotenv.env['PRAYER_TIME_API_URL'] ?? "",
                ),
              ),
            ),

            BlocProvider<KuranCubit>(
              create: (_) => KuranCubit(KuranServices()),
            ),
            BlocProvider<UserCubit>(create: (_) => UserCubit(UserServices())),

            BlocProvider<ChannelCubit>(
              create: (_) => ChannelCubit(ChannelServices()),
            ),

            BlocProvider<DutyCubit>(create: (_) => DutyCubit(DutyServices())),
            BlocProvider<UserDutyCubit>(
              create: (_) => UserDutyCubit(UserDutyServices()),
            ),
          ],
          child: const MainApp(),
        );
      },
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final prayerCubit = context.read<PrayerTimeCubit>();
    final weatherCubit = context.read<WeatherCubit>();
    await Future.wait([
      prayerCubit.loadFromCache(),
      weatherCubit.loadFromCache(),
    ]);
    debugPrint("localden yüklendi");
    if (await FetchTimeUtil.shouldFetchData()) {
      await Future.wait([
        prayerCubit.getPrayerTimes(
          lat: 41.0082,
          lng: 28.9784,
          date: DateTime.now().toIso8601String(),
        ),
        weatherCubit.getWeather(41.0082, 28.9784),
      ]);
      await FetchTimeUtil.updateFetchTime();
      debugPrint("veri çekildi");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
